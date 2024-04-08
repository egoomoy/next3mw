# 1. kafka 실행
cd next/mw/kafka_2.13-3.6.0/
bin/zookeeper-server-start.sh config/zookeeper.properties
bin/kafka-server-start.sh config/server.properties

#2. connect 실행
cd next/mw/kafka_2.13-3.6.0/
bin/connect-distributed ./etc/kafka/connect-distributed.properties

#3. connect 실행 정상 확인, 관련 토픽 생성 확인
cd next/mw/kafka_2.13-3.6.0/
./bin/kafka-topics.sh --bootstrap-server localhost:9092 --list


./bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic encoding_db_topic_test --from-beginning
/Users/plant/next/mw/confluent-7.3.1/share/java/kafka


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