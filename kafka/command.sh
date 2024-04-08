# 1. kafka 실행
cd next/mw/kafka_2.13-3.6.0/
bin/zookeeper-server-start.sh config/zookeeper.properties
bin/kafka-server-start.sh config/server.properties

#2. connect 실행
cd next/mw/kafka_2.13-3.6.0/
bin/connect-distributed ./etc/kafka/connect-distributed.properties


#3. mysql-connector 옮겨주기, 아래 경로로
# 마리아db를 사용하지만, 커넥터는 mysql... 왜지
# 우선 maria connect client 를 사용하면, upsert 로 sink가 안된다.
/Users/plant/next/mw/confluent-7.3.1/share/java/kafka

#4. connect 실행 정상 확인, 관련 토픽 생성 확인
cd next/mw/kafka_2.13-3.6.0/
./bin/kafka-topics.sh --create --topic encoding_db_topic_test --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1
./bin/kafka-topics.sh --bootstrap-server localhost:9092 --list
./bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic encoding_db_topic_test --from-beginning


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