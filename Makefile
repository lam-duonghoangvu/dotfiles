.PHONY: all banner update install-zsh install-brew \
	install-essential-dependencies install-homebrew-formulae \
	install-homebrew-casks install-visual-studio-code \
	install-mas-applications install-deps stow git-config tmux-config config

all:
	@trap 'printf "\r\033[K\033[1;31mSetup aborted by user\033[0m\n"; exit 0' INT; \
	./scripts/banner.sh; \
	./scripts/install_zsh.sh; \
	./scripts/install_brew.sh; \
	./scripts/install_deps.sh; \
	./scripts/stow.sh; \
	./scripts/config.sh

banner:
	@./scripts/banner.sh

update:
	@./scripts/pull.sh

install-zsh:
	@./scripts/install_zsh.sh

install-brew:
	@./scripts/install_brew.sh

install-essential-dependencies:
	@./scripts/install_essential.sh

install-homebrew-formulae:
	@./scripts/install_formulae.sh

install-homebrew-casks:
	@./scripts/install_casks.sh

install-visual-studio-code:
	@./scripts/install_vscode.sh

install-mas-applications:
	@./scripts/install_mas.sh

install-deps:
	@./scripts/install_deps.sh

stow:
	@./scripts/stow.sh

git-config:
	@./scripts/git_config.sh

tmux-config:
	@./scripts/tmux_config.sh

config:
	@./scripts/config.sh
