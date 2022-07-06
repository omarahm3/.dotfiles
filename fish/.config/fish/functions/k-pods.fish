function k-pods --description 'k-pods <context>'
  if begin string match -q "dev*" "$argv[1]"; and string match -q "dev-eks" "$CURRENT_KUBE_CLUSTER"; end
    set COMMAND "kubectl -n $argv[1]"
  else if begin string match -q "dev*" "$argv[1]"; and not string match -q "dev-eks" "$CURRENT_KUBE_CLUSTER"; end
    echo "Current cluster is not right [$CURRENT_KUBE_CLUSTER]"
    return 1
  else
    set COMMAND "kubectl"
  end

  eval "$COMMAND get pod"
end
