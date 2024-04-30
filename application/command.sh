
kubectl apply -f 1.backend
kubectl apply -f 2.front
kubectl apply -f 4.ingress

kubectl delete all -l project=snackbar

kubectl get pods -l app=mariadb
kubectl exec -it mariadb-c5bd659b8-66f56 -- bash
kubectl port-forward -n default service/my-release-kafka 32509:9092
kubectl port-forward  mariadb-c5bd659b8-66f56 3307:3306




wrk -t10 -c100 -d30s 'http://localhost:8071/auth-module/admin/api/v1/users?userStateCode=NORMAL&page=0&size=1' \
--header 'Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhdXRvQGdtYWlsLmNvbSIsImF1dGhvcml0aWVzIjoiUk9MRV9BRE1JTiIsInVzZXJfbm8iOjcsImV4cCI6MTcxNDE2MTMwN30.FR7Vr6HHf0KF3iFIdoSeZRtPrc9CHIvS-waxzsROgv2DS39BcXCw_TWzoODLAmRQtUSgH51JUZdJ4mHR2cE49g' \
--header 'Cookie: refresh-token=eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhdXRvQGdtYWlsLmNvbSIsImF1dGhvcml0aWVzIjoiUk9MRV9BRE1JTiIsInVzZXJfbm8iOjcsImV4cCI6MTcxNDI0MTMwN30.UomZnJrFaGfPqCE9HroDslm8lP3c2D7lqzwQW4wdzTJ20vgfKwuBjgmHIBQ0fiUIPJzjzY_6D1GYAZAmNOUr2g'