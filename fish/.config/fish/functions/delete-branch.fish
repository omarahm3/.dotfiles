function delete-branch
	git branch -d $argv
	git push origin --delete $argv
end
