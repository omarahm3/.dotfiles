function k-portforward --description 'k-portforward <context> <name> <ports>'
  set -l POD (k-getpod $argv[1] $argv[2])
  set -l COMMAND "kubectl --kubeconfig='/home/mrgeek/.kube/$argv[1].yaml' port-forward $POD $argv[3]"

  # Add namespace if trying to access some clusters
  switch $argv[1]
    case 'dev*'
      set COMMAND "$COMMAND -n $argv[1]"
    case '*'
      set COMMAND "$COMMAND -n port-forward"
  end

  eval $COMMAND
end
