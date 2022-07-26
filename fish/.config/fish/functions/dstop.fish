function dstop --description 'dstop <service>'
  docker compose stop $argv[1] && docker compose rm -f $argv[1]
end
