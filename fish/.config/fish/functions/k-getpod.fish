function k-getpod --description 'k-getpod <context> <resource_name>'
  # Check if this is a dev context, and the current logged in cluster is dev-eks
  # in this case we need to use it as a namespace
  if begin string match "dev*" "$argv[1]" 2>&1 1>/dev/null; and string match "dev-eks" "$CURRENT_KUBE_CLUSTER" 2>&1 1>/dev/null; end
    set KUBE_OUTPUT (kubectl -n "$argv[1]" get pod -o json 2>&1)
  else if begin string match "dev*" "$argv[1]" 2>&1 1>/dev/null; and not string match "dev-eks" "$CURRENT_KUBE_CLUSTER" 2>&1 1>/dev/null; end
    echo "Current cluster is not right [$CURRENT_KUBE_CLUSTER]"
    return 1
  else
    set KUBE_OUTPUT (kubectl -n default get pod -o json 2>&1)
  end

  set -l IS_EMPTY (echo $KUBE_OUTPUT | jq -r '.items[]' | string trim)

  if test -z "$IS_EMPTY"
    echo "No pods returned"
    return 1
  end

  set -l COMMAND_STRING (echo $KUBE_OUTPUT | jq -r "[.items[] | select(.metadata.name | contains(\"$argv[2..-1]\"))][0]")
  set -l OUTPUT (echo $COMMAND_STRING | jq -r '.metadata.name')
  echo $OUTPUT
end
