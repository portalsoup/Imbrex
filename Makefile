user ?= false

clean:
	if [ -d out ]; then rm -r out/; fi

test:
	src/usr/local/bin/imbrex.sh -c src/etc/imbrex -d src/usr/local/share/imbrex -o out/composite.png

install:
	mkdir -p $(HOME)/.local/bin
	cp src/usr/local/bin/imbrex.sh $(HOME)/.local/bin/imbrex

	mkdir -p $(HOME)/.local/share/imbrex
	cp -r src/usr/local/share/imbrex/ $(HOME)/.local/share/

uninstall:
	if [ -f $(HOME)/.local/bin/imbrex ]; then rm $(HOME)/.local/bin/imbrex; fi
	if [ -d $(HOME)/.local/share/imbrex ]; then rm -r $(HOME)/.local/share/imbrex; fi
	if [ -d $(HOME)/.cache/imbrex ]; then rm -r $(HOME)/.cache/imbrex; fi

delete-profiles:
	if [ -d $(HOME)/.config/imbrex ]; then rm -r $(HOME)/.config/imbrex; fi

install-demo:
	mkdir -p $(HOME)/.config/imbrex/profiles/simpletest
	cp -r src/etc/imbrex/profiles/simpletest $(HOME)/.config/imbrex/profiles
	cp src/etc/imbrex/activeprofile $(HOME)/.config/imbrex/activeprofile
