function vmrss --description 'vmrss <pid>'
  set -l pid $argv[1]

  if test -z "$pid"
    echo "No pid provided"
    return 1
  end

  while true
    sync
    cat /proc/$pid/status | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} VmRSS | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} -o '[0-9]\+' | awk '{print $1/1024 " MB"}'
    sleep 1
  end
end
