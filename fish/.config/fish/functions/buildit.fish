# function to build a docker image out of the CWD
function buildit --description 'buildit'
  set -l DIR_NAME (basename (pwd))
  echo "Building $DIR_NAME"
  docker build -t $DIR_NAME --progress=plain .
end
