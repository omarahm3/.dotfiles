function k-getpod --description 'k-getpod <context> <resource_name>'
  eval "kubectl --kubeconfig='/home/mrgeek/.kube/$argv[1].yaml' get pod --all-namespaces | grep -i $argv[2..-1] | tr -s ' ' | cut -d ' ' -f 2 | head -n 1"
end
