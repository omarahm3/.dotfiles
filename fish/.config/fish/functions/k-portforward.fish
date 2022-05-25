function k-portforward --description 'k-portforward <context> <name> <ports>'
  set -l POD (k-getpod $argv[1] $argv[2])
  set -l COMMAND "kubectl --kubeconfig='/home/mrgeek/.kube/$argv[1].yaml' port-forward $POD $argv[3]"

  eval $COMMAND

  if test $status -ne 0
    echo "Something went wrong, trying 'port-forward' namespace"
    eval "$COMMAND -n port-forward"
  end
end
