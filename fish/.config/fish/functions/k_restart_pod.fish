function k_restart_pod
	kubectl delete -f $argv
	kubectl apply -f $argv
end
