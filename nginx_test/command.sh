# 1. 간단 배포
kubectl apply -f nginx-nas-pv.yml && \
kubectl apply -f ns.yml  && \
kubectl apply -f nginx-nas-pvc.yml && \
kubectl apply -f nginx_conf.yml && \
kubectl apply -f nginx_conf_server_block.yml && \
kubectl apply -f nginx_deploy.yml && \
kubectl apply -f nginx_svc.yml 

# 2. 배포 확인
kubectl get po -n ever-ns
kubectl describe po nginx-test-965b9f59f-mbll9 -n ever-ns

# 3. 포트포워딩 임시 
kubectl port-forward nginx-56d758bd9b-mks7f 8071:80 -n ever-ns

# 4. 삭제
kubectl delete namespace ever-ns       
kubectl delete pv ever-nginx-nas-pv 
kubectl get pv
kubectl delete pv ever-nginx-nas-pv 

kubectl get all -n ever-ns

# 5. helm
# 차트 생성해야함.
# 