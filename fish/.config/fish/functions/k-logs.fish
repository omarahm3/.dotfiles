# Thanks to @Peter for some of the amazing tricks here
function k-logs --description 'k-logs <context> <resource_name>'
  set -l POD (k-getpod $argv[1] $argv[2])

  if string match -q "null" "$POD"
    echo "Pod was not found"
    return 1
  end

  # TODO Same checks do exist on multiple scripts, move to a common function
  if begin string match -q "dev*" "$argv[1]"; and string match -q "dev-eks" "$CURRENT_KUBE_CLUSTER"; end
    set BASE_COMMAND "kubectl -n $argv[1]"
  else if begin string match -q "dev*" "$argv[1]"; and not string match -q "dev-eks" "$CURRENT_KUBE_CLUSTER"; end
    echo "Current cluster is not right [$CURRENT_KUBE_CLUSTER]"
    return 1
  else
    set BASE_COMMAND "kubectl"
  end

  set -l APP (eval "$BASE_COMMAND get pod $POD -o yaml | grep -i app: | cut -d ':' -f 2")
  set -l APP (string trim $APP)
  set -l COMMAND "$BASE_COMMAND logs --tail=-1 -l app=$APP $argv[3..-1]"

  if test $status -ne 0
    echo "Something went wrong, status is not 0. Ignoring..."
  end

  eval $COMMAND
end
