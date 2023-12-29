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
  --topic my-topic2

kafka-console-consumer.sh \
  --bootstrap-server my-release-kafka.default.svc.cluster.local:9092 \
  --topic my-topic2 \
  --from-beginning

kafka-topics.sh --describe --topic my-topic2 --bootstrap-server my-release-kafka.default.svc.cluster.local:9092
kafka-topics.sh --delete --topic my-topic2 --bootstrap-server my-release-kafka.default.svc.cluster.local:9092
kafka-topics.sh  --create --topic my-topic2 --bootstrap-server my-release-kafka.default.svc.cluster.local:9092 --replication-factor 3 --partitions 3
