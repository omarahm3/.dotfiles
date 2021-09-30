function minikube_bind_docker
eval (minikube docker-env)
minikube -p minikube docker-env | source
end
