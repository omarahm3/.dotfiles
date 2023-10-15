
function activate_conda --description activate_conda
    eval /opt/miniconda3/bin/conda "shell.fish" hook $argv | source
end
