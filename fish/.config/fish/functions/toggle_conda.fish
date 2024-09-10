function toggle_conda --description="Toggle between active Conda environment and no Conda activation"  
  if command -v conda > /dev/null 2>&1
    echo "Deactivating Conda..."
    
    set -l new_path
    for path_item in $PATH
      if not string match -q "*anaconda3*" "$path_item"
        set new_path $new_path $path_item
      end
    end

    set -gx PATH $new_path
  else
    echo "Activating Conda..."
    set -a PATH ~/anaconda3/bin
  end
end
