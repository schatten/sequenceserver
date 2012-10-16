BOOTSTRAP_LESS = ./less/bootstrap.less

sserver: bootstrap-less
	cp -f bootstrap/css/bootstrap.css ../css/bootstrap.custom.css


# Clean the directory containing prior builds
clean:
	rm -r bootstrap


# Build only the css for bootstrap
bootstrap-less:
	mkdir -p bootstrap/css
	recess --compile ${BOOTSTRAP_LESS} > bootstrap/css/bootstrap.css
	recess --compress ${BOOTSTRAP_LESS} > bootstrap/css/bootstrap.min.css


# Watch less files and make when changes happen
watch:
	echo "Watching less files..."; \
	watchr -e "watch('less/.*\.less') { system 'make' }"

.PHONY: watch
