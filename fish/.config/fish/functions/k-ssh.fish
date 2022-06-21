# Defined in - @ line 1
function k-ssh
  eval "kubectl --kubeconfig='/home/mrgeek/.kube/$argv[1].yaml' -n $argv[1] exec -it $argv[2] -- bash"
end
