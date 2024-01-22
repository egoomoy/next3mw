
kubectl apply -f 1.backend
kubectl apply -f 2.front
kubectl apply -f 4.ingress

kubectl delete all -l project=snackbar

kubectl get pods -l app=mariadb
kubectl exec -it mariadb-c5bd659b8-66f56 -- bash
kubectl port-forward -n default service/my-release-kafka 32509:9092
kubectl port-forward  mariadb-c5bd659b8-66f56 3307:3306


