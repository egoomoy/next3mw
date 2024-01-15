# single 컴포즈 명령
docker-compose -f kafka-single-compose.yml up -d

# 실행상태 확인
docker ps
docker logs 11bc0d34221d

# topic 생성
# partition 은 토픽을 분리해서 저장하는 것을 말한다.
# 싱글이 아닌 멀티로 카프카를 운영한다면, 3개일 때 1개의 토픽이 3개 노드에 나누어 저장된다.
# replication-factor 은 토픽의 복제본 갯수를 말한다. 
# 파티션과 레플리카를 3개 씩 사용한다면 총 9개로 파티션 존재할 것 이다. (3개의 복제본이 3개씩 파티션되어)
docker exec kafka-kafka-1 kafka-topics --create --topic queuing-encoding-vod --bootstrap-server kafka:9092 --replication-factor 1 --partitions 1

# 카프카 토픽 확인
docker exec kafka-kafka-1 kafka-topics --describe --topic my-topic --bootstrap-server kafka:9092 


# 여기까지 도커 컴포즈로 했을 때--------
# 문제는 컨테이너 안에서 도커로 올라간 카프카에 접속을 못한다. 
# 컨테이너 안에서 외부 포트로 접속되는 걸 확인했지만, 도커 컴포즈로 배포하는 과정에서 KAFKA_ADVERTISED_LISTENERS 를 이해하지 못하는 듯..

