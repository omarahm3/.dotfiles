function delete-tag --description 'delete-tag <tag>'
  git tag -d $argv
  git push origin :refs/tags/$argv
end
