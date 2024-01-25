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
date -d "today + 180 minutes" +%s
echo -n "${expires} 127.0.0.1 mysecret" | openssl md5 -binary | openssl base64 | tr +/ -_ | tr -d = 
echo -n "4705941437 /vod/output/3/mycat.m3u8 mysecret" | openssl md5 -binary | openssl base64 | tr +/ -_ | tr -d =
http://localhost:8072/hls/SVAl4D05xFIwSqrllgXt3A/4705941437/output/3/mycat.m3u8

# nginx -V 확인
nginx version: nginx/1.25.3
built by gcc 12.2.0 (Debian 12.2.0-14) 
built with OpenSSL 3.0.9 30 May 2023 (running with OpenSSL 3.0.11 19 Sep 2023)
TLS SNI support enabled
configure arguments: --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules 
--conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log 
--http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid 
--lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp 
--http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp 
--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp 
--user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module 
--with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module 
--with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module 
--with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module
--with-http_sub_module --with-http_v2_module --with-http_v3_module --with-mail --with-mail_ssl_module --with-stream
--with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module
--with-cc-opt='-g -O2 -ffile-prefix-map=/data/builder/debuild/nginx-1.25.3/debian/debuild-base/nginx-1.25.3=. -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' 
--with-ld-opt='-Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie'
# 
