clean:
	if [ -d out ]; then rm -r out/*; fi

test:
	src/usr/local/bin/imbrex.sh -c src/etc/imbrex -d src/usr/local/share/imbrex -o out/composite.png