function k-logs --description 'k-logs <context> <resource_name>'
  set -l POD (k-getpod $argv[1] $argv[2])
  set -l APP (eval "k8dev$argv[1] get pod $POD -o yaml | grep -i app: | cut -d ':' -f 2")
  set -l APP (string trim $APP)
  set -l COMMAND "k8dev$argv[1] logs --tail=-1 -l app=$APP $argv[3..-1]"

  if test $status -ne 0
    echo "Something went wrong, status is not 0. Ignoring..."
  end

  eval $COMMAND
end
