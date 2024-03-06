set -l venv_directory ./venv

if test -d $venv_directory
  source $venv_directory/bin/activate.fish
end

set -l venv_directory ./.venv

if test -d $venv_directory
  source $venv_directory/bin/activate.fish
end
