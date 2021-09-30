function docker_nuke
	docker stop (docker ps -aq)
  docker rm -f -v (docker ps -aq)
  docker rmi -f (docker images -aq)
  docker volume rm (docker volume ls -q) 
  docker network rm (docker network ls -q)
end
