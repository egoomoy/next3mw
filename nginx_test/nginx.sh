kubectl apply -f nginx-hls-pv.yml
kubectl apply -f ns.yml
kubectl apply -f nginx-hls-pvc.yml
kubectl apply -f my_nginx_conf.yml
kubectl apply -f nginx_deploy.yml

kubectl get po -n my-ns
kubectl describe po nginx-7c95964cc7-fwpc2 -n my-ns
kubectl delete namespace my-ns                 
kubectl get all -n my-ns
kubectl get pv

kubectl delete namespace my-ns                 
kubectl delete pv nginx-hls-pv