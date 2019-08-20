# 

kubectl create deployment first-deployment --image=katacoda/docker-http-server

kubectl expose deployment first-deployment --port=80 --type=NodePort

export PORT=$(kubectl get svc first-deployment -o go-template='{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{"\n"}}{{end}}{{end}}')
echo "Accessing host01:$PORT"