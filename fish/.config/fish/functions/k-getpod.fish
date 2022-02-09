function k-getpod --description 'k-getpod <context> <resource_name>'
  eval "k8dev$argv[1] get pod | grep -i $argv[2..-1] | cut -d ' ' -f 1 | head -n 1"
end
