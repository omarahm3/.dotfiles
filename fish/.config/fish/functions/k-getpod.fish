function k-getpod --description 'k-getpod <context> <resource_name>'
  set -l KUBE_OUTPUT (kubectl --kubeconfig="/home/mrgeek/.kube/$argv[1].yaml" get pod -n $argv[1] -o json 2>&1)
  set -l IS_EMPTY (echo $KUBE_OUTPUT | jq -r '.items[]' | string trim)

  if test -z "$IS_EMPTY"
    set KUBE_OUTPUT (kubectl --kubeconfig="/home/mrgeek/.kube/$argv[1].yaml" get pod --all-namespaces -o json 2>&1)
  end

  set -l COMMAND_STRING (echo $KUBE_OUTPUT | jq -r "[.items[] | select(.metadata.name | contains(\"$argv[2..-1]\"))][0]")
  set -l OUTPUT (echo $COMMAND_STRING | jq -r '.metadata.name')
  echo $OUTPUT
end
