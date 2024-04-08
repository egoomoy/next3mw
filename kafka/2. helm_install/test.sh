# 헬름 차트로 다시 
# kubectl get ep # end point 조회해서 IP를 가지고 사용?

# helm install my-release \
#   --set listeners.client.protocol=PLAINTEXT \
#   --set externalAccess.enabled=true \
#   --set externalAccess.broker.service.type=NodePort \
#   --set externalAccess.controller.service.type=NodePort \
#   --set externalAccess.autoDiscovery.enabled=true \
#   --set serviceAccount.create=true \
#   --set rbac.create=true \
#   oci://registry-1.docker.io/bitnamicharts/kafka


# 1.
cd kafka
helm install my-release -f values.yaml oci://registry-1.docker.io/bitnamicharts/kafka
helm uninstall my-release

# 2.
kubectl run my-release-kafka-client --restart='Never' --image docker.io/bitnami/kafka:3.6.1-debian-11-r0 --namespace default --command -- sleep infinity
kubectl exec --tty -i my-release-kafka-client --namespace default -- bash

# 3. 
kafka-console-producer.sh \
  --broker-list my-release-kafka-controller-0.my-release-kafka-controller-headless.default.svc.cluster.local:9092,my-release-kafka-controller-1.my-release-kafka-controller-headless.default.svc.cluster.local:9092,my-release-kafka-controller-2.my-release-kafka-controller-headless.default.svc.cluster.local:9092 \
  --topic queuing-encoding-vod

kafka-console-consumer.sh \
  --bootstrap-server my-release-kafka.default.svc.cluster.local:9092 \
  --topic queuing-encoding-vod \
  --from-beginning

kafka-topics.sh --delete --topic queuing-encoding-vod --bootstrap-server my-release-kafka.default.svc.cluster.local:9092
kafka-topics.sh --create --topic queuing-encoding-vod --bootstrap-server my-release-kafka.default.svc.cluster.local:9092 --replication-factor 3 --partitions 3
kafka-topics.sh --describe --topic queuing-encoding-vod --bootstrap-server my-release-kafka.default.svc.cluster.local:9092

# 0. 로컬 수행

bin/kafka-server-start.sh config/kraft/server.properties
bin/kafka-topics.sh --delete --topic queuing-encoding-vod --bootstrap-server localhost:9092
bin/kafka-topics.sh --create --topic queuing-encoding-vod --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 # 로컬에서 브로커 1개면 레플리카 1개
bin/kafka-topics.sh --describe --topic queuing-encoding-vod --bootstrap-server localhost:9092 

bin/kafka-topics.sh --create --topic queuing-thumbnail-vod --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 # 로컬에서 브로커 1개면 레플리카 1개

