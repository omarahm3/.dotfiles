function k-describe --description 'k-getpod <context> <resource_type> <resource_name>'
  eval "kubectl --kubeconfig='/home/mrgeek/.kube/$argv[1].yaml' -n default describe $argv[2] $argv[3]"
end
