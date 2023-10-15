# function to run a docker container out of the CWD
function runit --description 'runit <docker run args>'
  set -l DIR_NAME (basename (pwd))
  echo "Building $DIR_NAME"
  docker run --rm  $argv $DIR_NAME
end
