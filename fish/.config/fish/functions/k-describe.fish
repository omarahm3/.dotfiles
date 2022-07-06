function k-describe --description 'k-getpod <context> <resource_type> <resource_name>'
  eval "kubectl -n $argv[1] describe $argv[2]/$argv[3]"
end
