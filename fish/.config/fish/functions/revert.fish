function revert --wraps='git revert $argv' --description 'alias revert=revert'
  git revert $argv
end
