function nah --description 'clean everything in git repository'
  git reset --hard
  git clean -df

  if [ -d ".git/rebase-apply" ] || [ -d ".git/rebase-merge" ]
    git rebase --abort
  end
end
