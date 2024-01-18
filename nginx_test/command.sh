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

---
### secure_link_secret word 의 경우
echo -n 'output/3/cat270.m3u8mysecret' | openssl md5 -hex
# http://localhost:8070/hls/a87fbb0a9745d780835b8761349671f1/output/3/mycat_720.m3u8
# echo -n 'output/3/mycat_720.m3u8mysecret' | openssl md5 -hex
# http://localhost:8071/ts/output/3/mycat_720.m3u8
# http://localhost:8070/hls/a4603883486fe41f6c13ca8a8b1af737/output/3/cat270.m3u8

---
# secure_link_md5 expression 의 경우
date -d "today + 1 minutes" +%s
echo -n "${expires} 127.0.0.1 mysecret" | openssl md5 -binary | openssl base64 | tr +/ -_ | tr -d =
echo -n "1705580393 mysecret" | openssl md5 -binary | openssl base64 | tr +/ -_ | tr -d =
http://localhost:8070/hls/0Ft4ijq-CUBfWtfFcgweYg/1705580393/output/3/mycat_720.m3u8
# if ($secure_link = "0") { return 410; } 만료 시 410 gone       
