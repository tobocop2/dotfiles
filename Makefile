all: install

tpm:
	git clone https://github.com/tmux-plugins/tpm .config/tmux/plugins/tpm || true

nvchad:
	git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 || true

install: nvchad tpm
	for d in `find . -mindepth 1 -maxdepth 1 -type d -not -path './.*'`; do \
		stow -t $(HOME) -R $$(basename $$d); \
		echo "$$(basename $$d) stowed."; \
	done
