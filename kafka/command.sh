# 1. zookeeper & kafka
cd next/mw/kafka_2.13-3.6.0/
bin/zookeeper-server-start.sh config/zookeeper.properties
bin/kafka-server-start.sh config/server.properties

#2. confluent connect
# 다운로드 : https://www.confluent.io/ko-kr/previous-versions/
cd next/mw/confluent-7.5.3/
bin/connect-distributed ./etc/kafka/connect-distributed.properties

#3-1. 드라이버용 : mysql-connector 옮겨주기, 아래 경로로
# 다운로드 : https://mvnrepository.com/artifact/mysql/mysql-connector-java
# 마리아db를 사용하지만, 커넥터는 mysql... 왜지
# 우선 maria connect client 를 사용하면, upsert 로 sink가 안된다.
/Users/plant/next/mw/confluent-7.5.3/share/java/kafka 로 복-붙

#3-2. JDBC Connector (Source and Sink) 다운로드
# 다운로드 : https://www.confluent.io/hub/confluentinc/kafka-connect-jdbc

#4. plugin path 설정
cd /Users/edwin/next/mw/confluent-7.5.3/etc/kafka/connect-distributed.properties
plugin.path=/usr/share/java, /Users/edwin/next/mw/confluentinc-kafka-connect-jdbc-10.7.6/lib

#5. confluent connect 재기동
bin/connect-distributed ./etc/kafka/connect-distributed.properties

#6. connect 실행 정상 확인, 관련 토픽 생성 확인
cd next/mw/kafka_2.13-3.6.0/
./bin/kafka-topics.sh --create --topic schemahistory.fullfillment --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1
./bin/kafka-topics.sh --bootstrap-server localhost:9092 --list
./bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic cdcing.source.encoding.testtime --from-beginning
./bin/kafka-topics.sh --bootstrap-server localhost:9092 --delete --topic schema.history.fullfillment


#7. debezium으로 적용
# debezium은 mariadb(mysql) 의 binary log를 기반으로 cdc 를 수행한다.
# 기존에 confluent는 id 와 timestamp를 통해 돌았다
# mysql --help | grep maria
# maria bin log 켜주기
# /usr/local/etc/my.cnf
log-bin = /usr/local/Cellar/mariadb/11.3.2/log/binary/maria-bin 
binlog_cache_size = 1M 
max_binlog_size = 512M
expire_logs_days = 7



# ---------------------------------------------------------------------------------------------------------------

# confluent doc 에 옵션 참고 할 것 ***
https://docs.confluent.io/kafka-connectors/jdbc/current/sink-connector/sink_config_options.html
http://localhost:8083/connectors?expand=info&expand=status


{
    "name": "jdbc_sink_mysql_02",
    "config": {
        "connector.class" : "io.confluent.connect.jdbc.JdbcSinkConnector",
        "connection.url" : "jdbc:mysql://localhost:3306/es",
        "connection.user":"root",
        "connection.password":"1234",
        "auto.create": "false",
        "auto.evolve": "false",
        "topics": "c_encoding_db_topic_testtime",
        "insert.mode": "upsert",
        "pk.mode": "record_value",
        "pk.fields": "id",
        "table.name.format":"es.testtime",
        "fields.whitelist" : "id,name,modified_at,age",
        "key.converter": "org.apache.kafka.connect.json.JsonConverter",
        "value.converter": "org.apache.kafka.connect.json.JsonConverter"
    }
}

{
    "name" : "encoding-db-testtime-connect",
    "config" : {
        "connector.class" : "io.confluent.connect.jdbc.JdbcSourceConnector",
        "connection.url" : "jdbc:mysql://localhost:3306/encoding",
        "connection.user":"root",
        "connection.password":"1234",
        "mode" : "timestamp+incrementing",
        "incrementing.column.name" : "id",
        "timestamp.column.name" : "modified_at",
        "table.whitelist":"encoding.testtime",
        "topic.prefix" : "c_encoding_db_topic_",
        "tasks.max" : "1"
    }
}

{
    "name": "maria-cdc-test",
    "config": {
        "connector.class": "io.debezium.connector.mysql.MySqlConnector",
        "tasks.max": "1",
        "database.hostname": "localhost",
        "database.port": "3306",
        "database.user": "root",
        "database.password": "1234",
        "database.server.id": "1",
        "database.server.name": "mysql01",
        "database.include.list": "encoding",
        "table.include.list": "encoding.testtime",
        "database.ssl.mode":"disabled",
        "schema.history.internal.kafka.bootstrap.servers": "localhost:9092", 
        "schema.history.internal.kafka.topic": "schema.history.fullfillment", 
        "include.schema.changes": "true" ,
        "key.converter": "org.apache.kafka.connect.json.JsonConverter",
        "value.converter": "org.apache.kafka.connect.json.JsonConverter",
        "snapshot.mode": "schema_only_recovery",
        "topic.prefix" : "cdcing.source",
        "transforms": "unwrap",
        "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
        "transforms.unwrap.drop.tombstones": "false",
        "transforms.unwrap.delete.handling.mode": "rewrite",
        "transforms.unwrap.add.fields" : "op,table",
        "transforms.unwrap.add.fields.prefix": "cdc_meta_",
        "database.connectionTimeZone": "Asia/Seoul"
    }
}


#kafka 설정#
https://docs.confluent.io/kafka-connectors/elasticsearch/current/configuration_options.html

# upsert를 활용한 mariadb의 pk 업뎃시 동기화
# transform을 활용하여 mariadb의 pk을 기반 메시지 키 생성 -> 문서의 ID로 활용
{
  "name": "elasticsearch-sink-connect",
  "config": {
    "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
    "tasks.max": "1",
    "topics": "c_content_db_topic_content",
    "connection.url": "http://localhost:9200",
    "key.ignore": "false",
    "schema.ignore": "true",
    "type.name": "_doc",
    "write.method": "upsert",

    "transforms": "createKey,extractInt",
    "transforms.createKey.type": "org.apache.kafka.connect.transforms.ValueToKey",
    "transforms.createKey.fields": "content_no",
    "transforms.extractInt.type": "org.apache.kafka.connect.transforms.ExtractField$Key",
    "transforms.extractInt.field": "content_no" 
  }
}
