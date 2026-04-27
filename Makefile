all: install

tpm:
	git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm || true

install: tpm
	for d in `find . -mindepth 1 -maxdepth 1 -type d -not -path './.*'`; do \
		stow -t $(HOME) -R $$(basename $$d); \
		echo "$$(basename $$d) stowed."; \
	done
