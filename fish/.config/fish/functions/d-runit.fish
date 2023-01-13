function d-runit --description 'd-runit <image_name_or_hash> <shell> <user>'
  set ISHELL (echo $argv[2])
  set IUSER (echo $argv[3])

  if test -z "$ISHELL"
    set ISHELL "/bin/bash"
    return 1
  end

  if test -z "$IUSER"
    set IUSER "root"
    return 1
  end

  docker run -it -u $IUSER $argv[1] $ISHELL
end
