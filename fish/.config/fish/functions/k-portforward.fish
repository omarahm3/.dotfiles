function k-portforward --description 'k-portforward <context> <name> <ports>'
  set -l POD (k-getpod $argv[1] $argv[2])
  
  if string match -q "null" "$POD"
    echo "Pod was not found"
    return 1
  end

  if begin string match -q "dev*" "$argv[1]"; and string match -q "dev-eks" "$CURRENT_KUBE_CLUSTER"; end
    set COMMAND "kubectl -n $argv[1] port-forward $POD $argv[3]"
  else if begin string match -q "dev*" "$argv[1]"; and not string match -q "dev-eks" "$CURRENT_KUBE_CLUSTER"; end
    echo "Current cluster is not right [$CURRENT_KUBE_CLUSTER]"
    return 1
  else
    set COMMAND "kubectl -n port-forward port-forward $POD $argv[3]"
  end

  eval $COMMAND
end
