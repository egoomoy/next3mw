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
kubectl describe po nginx-test-565bf585d8-l7z75 -n ever-ns

# 3. 포트포워딩 임시 
kubectl port-forward nginx-test-565bf585d8-l7z75 8072:80 -n ever-ns

# 4. 삭제
kubectl delete namespace ever-ns       
kubectl delete pv ever-nginx-nas-pv 
kubectl get pv

kubectl get all -n ever-ns

# 5. helm
# 차트 생성해야함.

echo -n 'output/3/mycat_720.m3u8enigma' | openssl md5 -hex
# http://localhost:8074/hls/85d96431c90d43148837e333f9eaddad/output/3/mycat_720.m3u8
# echo -n 'output/3/mycat_720.m3u8enigma' | openssl md5 -hex
# http://localhost:8071/ts/output/3/mycat_720.m3u8