function k-getpod --description 'k-getpod <context> <resource_name>'
  eval "kubectl --kubeconfig='/home/mrgeek/.kube/$argv[1].yaml' -n default get pod | grep -i $argv[2..-1] | cut -d ' ' -f 1 | head -n 1"
end
