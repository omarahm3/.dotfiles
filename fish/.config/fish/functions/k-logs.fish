# Defined in - @ line 1
function k-logs --wraps='kubectl logs -f $argv' --description 'alias k-logs=kubectl logs -f'
  kubectl logs -f $argv;
end
