function generate-all-installed-packages
	echo "Generating the lists of explicitly installed packages in ~/.packages-backup"

	set BACKUP_DIR ~/.packages-backup
	mkdir -p $BACKUP_DIR

	npm list -g --depth=0 &>$BACKUP_DIR/npm_packages || echo "npm failed"
	yarn global list --depth=0 &>$BACKUP_DIR/yarn_packages || echo "yarn failed"
	composer global show | cut -d ' ' -f1 &>$BACKUP_DIR/composer_packages || echo "composer failed"
	pip list | cut -d ' ' -f1 &>$BACKUP_DIR/pip_packages || echo "pip failed"
	snap list | cut -d ' ' -f1 &>$BACKUP_DIR/snap_packages || echo "snap failed"
	apt list --installed | cut -d '/' -f1 &>$BACKUP_DIR/apt_packages || echo "apt failed"

	git add -f $BACKUP_DIR
end
