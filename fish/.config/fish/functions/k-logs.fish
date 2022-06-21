# Thanks to @Peter for some of the amazing tricks here
function k-logs --description 'k-logs <context> <resource_name>'
  set -l POD (k-getpod $argv[1] $argv[2])
  set -l BASE_COMMAND "kubectl --kubeconfig='/home/mrgeek/.kube/$argv[1].yaml' -n $argv[1]"
  set -l APP (eval "$BASE_COMMAND get pod $POD -o yaml | grep -i app: | cut -d ':' -f 2")
  set -l APP (string trim $APP)
  set -l COMMAND "$BASE_COMMAND logs --tail=-1 -l app=$APP $argv[3..-1]"

  if test $status -ne 0
    echo "Something went wrong, status is not 0. Ignoring..."
  end

  eval $COMMAND
end
