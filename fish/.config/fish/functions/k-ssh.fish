# Defined in - @ line 1
function k-ssh
  eval "kubectl --kubeconfig='/home/mrgeek/.kube/$argv[1].yaml' exec -it $argv[2] -- bash"
end
