OS                 := $(shell uname -s)
IS_WSL             := $(shell { grep -qi microsoft /proc/version 2>/dev/null || [ -n "$$WSL_DISTRO_NAME" ]; } && echo 1 || echo 0)

BREW_CONFIG_DIR    := brew/.config/brew
ESSENTIAL_BREWFILE := $(BREW_CONFIG_DIR)/Brewfile
FORMULAE_BREWFILE  := $(BREW_CONFIG_DIR)/formulae.Brewfile
CASK_BREWFILE      := $(BREW_CONFIG_DIR)/cask.Brewfile
VSCODE_BREWFILE    := $(BREW_CONFIG_DIR)/vscode.Brewfile
MAS_BREWFILE       := $(BREW_CONFIG_DIR)/mas.Brewfile

WSL_VSCODE_EXT     := ms-vscode-remote.remote-wsl
STOW_PACKAGES      := bash bat brew btop fastfetch ghostty nvim starship tmux zsh

RED                := \033[1;31m
GREEN              := \033[1;32m
YELLOW             := \033[1;33m
CYAN               := \033[1;36m
RESET              := \033[0m

DOTFILES_REPO      := https://github.com/lam-duonghoangvu/dotfiles.git

.PHONY: all banner check update pull \
				git-config install-zsh install-brew \
        install-essential-dependencies \
				install-homebrew-formulae \
        install-homebrew-casks install-visual-studio-code \
        install-mas-applications install-deps stow

all: banner check git-config install-zsh install-brew install-deps

update: pull

pull:
	@echo "$(CYAN)"
	@echo "PULLING LATEST DOTFILES"
	@echo "$(RESET)"
	@OLD_HASH=$$(git hash-object Makefile 2>/dev/null || echo "1"); \
	echo "Pulling latest changes from $(DOTFILES_REPO)..."; \
	if git pull $(DOTFILES_REPO); then \
		NEW_HASH=$$(git hash-object Makefile 2>/dev/null || echo "2"); \
		if [ "$$OLD_HASH" != "$$NEW_HASH" ]; then \
			echo "$(YELLOW)[!] Makefile has been amended. Re-executing with the new Makefile...$(RESET)"; \
			exec $(MAKE) all; \
		else \
			echo "$(GREEN)[✓] Makefile is unchanged. Running scripts...$(RESET)"; \
			$(MAKE) all; \
		fi \
	else \
		echo "$(RED)[✗] Failed to pull from $(DOTFILES_REPO)$(RESET)"; \
		exit 1; \
	fi

banner:
	@clear 2>/dev/null || printf "\033[2J\033[H"
	@echo "$(CYAN)"
	@echo "  ____  _____ _____ _____ ___ _   _  ____   _   _ ____    ____  _______   _____ ____ _____ "
	@echo " / ___|| ____|_   _|_   _|_ _| \ | |/ ___| | | | |  _ \  |  _ \| ____\ \ / /_ _/ ___| ____|"
	@echo " \___ \|  _|   | |   | |  | ||  \| | |  _  | | | | |_) | | | | |  _|  \ V / | | |   |  _|  "
	@echo "  ___) | |___  | |   | |  | || |\  | |_| | | |_| |  __/  | |_| | |___  | |  | | |___| |___ "
	@echo " |____/|_____| |_|   |_| |___|_| \_|\____|  \___/|_|     |____/|_____| |_| |___\____|_____|"
	@echo "$(RESET)"

check:
	@echo "$(CYAN)"
	@echo "PREREQUISITES"
	@echo "$(RESET)"
	@if command -v zsh >/dev/null 2>&1; then \
		echo "$(GREEN) [✓] Zsh: Installed at $$(command -v zsh)$(RESET)"; \
	else \
		echo "$(RED) [✗] Zsh: NOT installed$(RESET)"; \
	fi
	@if [ -x "$(BREW_BIN)" ] || command -v brew >/dev/null 2>&1; then \
		echo "$(GREEN) [✓] Homebrew: Installed at $(BREW_BIN)$(RESET)"; \
	else \
		echo "$(RED) [✗] Homebrew: NOT installed$(RESET)"; \
	fi

git-config:
	@echo "$(CYAN)"
	@echo "GIT CONFIG"
	@echo "$(RESET)"
	@trap 'printf "\r\033[K$(RED)[!] Setup aborted by user$(RESET)\n"; exit 0' INT; \
	curr_name=$$(git config --global user.name 2>/dev/null); \
	curr_email=$$(git config --global user.email 2>/dev/null); \
	if [ -n "$$curr_name" ]; then \
		echo "$(GREEN) [✓] Git Username: $$curr_name$(RESET)"; \
	else \
		echo "$(RED) [✗] Git Username: NOT SET$(RESET)"; \
	fi; \
	if [ -n "$$curr_email" ]; then \
		echo "$(GREEN) [✓] Git Email: $$curr_email$(RESET)"; \
	else \
		echo "$(RED) [✗] Git Email: NOT SET$(RESET)"; \
	fi; \
	if [ -z "$$curr_name" ] || [ -z "$$curr_email" ]; then \
		prompt="Configure Git settings? [Y/n]: "; \
		def="y"; \
	else \
		prompt="Configure Git settings? [y/N]: "; \
		def="n"; \
	fi; \
	printf "%s" "$$prompt"; \
	read -r ans < /dev/tty; \
	ans=$${ans:-$$def}; \
	case "$$ans" in \
		[yY][eE][sS]|[yY]) \
			printf "Enter Git Username [%s]: " "$$curr_name"; \
			read -r name < /dev/tty; \
			if [ -n "$$name" ]; then \
				git config --global user.name "$$name"; \
				echo "$(GREEN) [✓] Git username updated: $$name$(RESET)"; \
			elif [ -n "$$curr_name" ]; then \
				echo "$(GREEN) [✓] Git username: $$curr_name$(RESET)"; \
			fi; \
			printf "Enter Git Email [%s]: " "$$curr_email"; \
			read -r email < /dev/tty; \
			if [ -n "$$email" ]; then \
				git config --global user.email "$$email"; \
				echo "$(GREEN) [✓] Git email updated: $$email$(RESET)"; \
			elif [ -n "$$curr_email" ]; then \
				echo "$(GREEN) [✓] Git email: $$curr_email$(RESET)"; \
			fi; \
			;; \
		*) \
			echo "Skipping Git configuration"; \
			;; \
	esac

install-zsh:
	@if ! command -v zsh >/dev/null 2>&1; then \
		echo "$(CYAN)"; \
		echo "ZSH"; \
		echo "$(RESET)"; \
		if [ "$(OS)" = "Darwin" ]; then \
			echo "macOS detected Zsh is usually pre-installed"; \
		elif [ "$(OS)" = "Linux" ]; then \
			if [ -f /etc/debian_version ]; then \
				echo "Debian/Ubuntu detected Installing zsh..."; \
				sudo apt-get update && sudo apt-get install -y zsh; \
			elif [ -f /etc/redhat-release ] || [ -f /etc/dnf/dnf.conf ]; then \
				echo "Fedora/RHEL/CentOS detected Installing zsh..."; \
				sudo dnf install -y zsh || sudo yum install -y zsh; \
			elif [ -f /etc/arch-release ]; then \
				echo "Arch Linux detected Installing zsh..."; \
				sudo pacman -S --noconfirm zsh; \
			else \
				echo "Unknown Linux distribution Please install zsh manually"; \
				exit 1; \
			fi; \
		else \
			echo "Unsupported OS: $(OS)"; \
			exit 1; \
		fi; \
	fi

install-brew:
	@if ! [ -x "$(BREW_BIN)" ] && ! command -v brew >/dev/null 2>&1; then \
		echo "$(CYAN)"; \
		echo "HOMEBREW"; \
		echo "$(RESET)"; \
		if [ "$(OS)" = "Linux" ]; then \
			echo "Installing Linux build dependencies for Homebrew..."; \
			if [ -f /etc/debian_version ]; then \
				sudo apt-get update && sudo apt-get install -y build-essential procps curl file git; \
			elif [ -f /etc/redhat-release ] || [ -f /etc/dnf/dnf.conf ]; then \
				sudo dnf groupinstall -y "Development Tools" && sudo dnf install -y procps-ng curl file git; \
			elif [ -f /etc/arch-release ]; then \
				sudo pacman -S --needed --noconfirm base-devel procps-ng curl file git; \
			fi; \
		fi; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi

# Dynamic Homebrew binary resolver
BREW_BIN = $(shell which brew 2>/dev/null || \
            { [ -x /opt/homebrew/bin/brew ] && echo /opt/homebrew/bin/brew; } || \
            { [ -x /home/linuxbrew/.linuxbrew/bin/brew ] && echo /home/linuxbrew/.linuxbrew/bin/brew; } || \
            { [ -x /usr/local/bin/brew ] && echo /usr/local/bin/brew; } || \
            echo brew)

install-essential-dependencies:
	@trap 'printf "\r\033[K$(RED)[!] Setup aborted by user$(RESET)\n"; exit 0' INT; \
	if [ -f "$(ESSENTIAL_BREWFILE)" ]; then \
		check_output=$$($(BREW_BIN) bundle check --file="$(ESSENTIAL_BREWFILE)" --verbose 2>&1); \
		if echo "$$check_output" | grep -q "dependencies are satisfied"; then \
			echo "$(GREEN) [✓] All essential dependencies are already installed$(RESET)"; \
		else \
			missing_pkgs=$$(echo "$$check_output" | grep -E '^→ ' | sed -E 's/^→ [^ ]+ ([^ ]+).*/\1/'); \
			if [ -n "$$missing_pkgs" ]; then \
				echo "$(YELLOW) Missing essential dependencies:$(RESET)"; \
				for pkg in $$missing_pkgs; do echo "   [→] $$pkg"; done; \
			fi; \
			echo "$(CYAN) Installing essential dependencies...$(RESET)"; \
			$(BREW_BIN) bundle install --quiet --file="$(ESSENTIAL_BREWFILE)"; \
			echo "$(GREEN) [✓] All essential dependencies are installed$(RESET)"; \
		fi; \
	fi

install-homebrew-formulae:
	@trap 'printf "\r\033[K$(RED)[!] Setup aborted by user$(RESET)\n"; exit 0' INT; \
	if [ -f "$(FORMULAE_BREWFILE)" ]; then \
		check_output=$$($(BREW_BIN) bundle check --file="$(FORMULAE_BREWFILE)" --verbose 2>&1); \
		if echo "$$check_output" | grep -q "dependencies are satisfied"; then \
			echo "$(GREEN) [✓] Homebrew formulae are already installed$(RESET)"; \
		else \
			printf "Install Homebrew formulae? [y/N]: "; \
			read -r ans < /dev/tty; \
			case "$$ans" in \
				[yY][eE][sS]|[yY]) \
					missing_pkgs=$$(echo "$$check_output" | grep -E '^→ ' | sed -E 's/^→ [^ ]+ ([^ ]+).*/\1/'); \
					if [ -n "$$missing_pkgs" ]; then \
						echo "$(YELLOW) Missing items:$(RESET)"; \
						for pkg in $$missing_pkgs; do echo "   [→] $$pkg"; done; \
					fi; \
					echo "$(CYAN) Installing Homebrew formulae...$(RESET)"; \
					$(BREW_BIN) bundle install --quiet --file="$(FORMULAE_BREWFILE)"; \
					echo "$(GREEN) [✓] Homebrew formulae are installed$(RESET)"; \
					;; \
				*) echo "Skipping Homebrew formulae"; ;; \
			esac; \
		fi; \
	fi

install-homebrew-casks:
	@trap 'printf "\r\033[K$(RED)[!] Setup aborted by user$(RESET)\n"; exit 0' INT; \
	if [ -f "$(CASK_BREWFILE)" ]; then \
		check_output=$$($(BREW_BIN) bundle check --file="$(CASK_BREWFILE)" --verbose 2>&1); \
		if echo "$$check_output" | grep -q "dependencies are satisfied"; then \
			echo "$(GREEN) [✓] Homebrew casks are already installed$(RESET)"; \
		else \
			printf "Install Homebrew casks? [y/N]: "; \
			read -r ans < /dev/tty; \
			case "$$ans" in \
				[yY][eE][sS]|[yY]) \
					missing_pkgs=$$(echo "$$check_output" | grep -E '^→ ' | sed -E 's/^→ [^ ]+ ([^ ]+).*/\1/'); \
					if [ -n "$$missing_pkgs" ]; then \
						echo "$(YELLOW) Missing items:$(RESET)"; \
						for pkg in $$missing_pkgs; do echo "   [→] $$pkg"; done; \
					fi; \
					echo "$(CYAN) Installing Homebrew casks...$(RESET)"; \
					$(BREW_BIN) bundle install --quiet --file="$(CASK_BREWFILE)"; \
					echo "$(GREEN) [✓] Homebrew casks are installed$(RESET)"; \
					;; \
				*) echo "Skipping Homebrew casks"; ;; \
			esac; \
		fi; \
	fi

install-visual-studio-code:
	@trap 'printf "\r\033[K$(RED)[!] Setup aborted by user$(RESET)\n"; exit 0' INT; \
	if [ -f "$(VSCODE_BREWFILE)" ]; then \
		check_output=$$($(BREW_BIN) bundle check --file="$(VSCODE_BREWFILE)" --verbose 2>&1); \
		if echo "$$check_output" | grep -q "dependencies are satisfied"; then \
			echo "$(GREEN) [✓] Visual Studio Code is already installed$(RESET)"; \
			echo "$(GREEN) [✓] Visual Studio Code extensions are already installed$(RESET)"; \
		else \
			printf "Install Visual Studio Code and extensions? [y/N]: "; \
			read -r ans < /dev/tty; \
			case "$$ans" in \
				[yY][eE][sS]|[yY]) \
					missing_pkgs=$$(echo "$$check_output" | grep -E '^→ ' | sed -E 's/^→ [^ ]+ ([^ ]+).*/\1/'); \
					if [ -n "$$missing_pkgs" ]; then \
						echo "$(YELLOW) Missing items:$(RESET)"; \
						for pkg in $$missing_pkgs; do echo "   [→] $$pkg"; done; \
					fi; \
					echo "$(CYAN) Installing Visual Studio Code and extensions...$(RESET)"; \
					$(BREW_BIN) bundle install --quiet --file="$(VSCODE_BREWFILE)"; \
					echo "$(GREEN) [✓] Visual Studio Code is installed$(RESET)"; \
					echo "$(GREEN) [✓] Visual Studio Code extensions are installed$(RESET)"; \
					;; \
				*) echo "Skipping Visual Studio Code"; ;; \
			esac; \
		fi; \
	fi; \
	if [ "$(IS_WSL)" = "1" ]; then \
		echo "$(CYAN)"; \
		echo "WSL DETECTED"; \
		echo "$(RESET)"; \
		if command -v code >/dev/null 2>&1; then \
			if code --list-extensions 2>/dev/null | grep -qi "^$(WSL_VSCODE_EXT)$$"; then \
				echo "$(GREEN) [✓] WSL VS Code extension ($(WSL_VSCODE_EXT)) is already installed$(RESET)"; \
			else \
				echo "$(CYAN) Installing WSL VS Code extension ($(WSL_VSCODE_EXT))...$(RESET)"; \
				code --install-extension $(WSL_VSCODE_EXT); \
				echo "$(GREEN) [✓] WSL VS Code extension installed$(RESET)"; \
			fi; \
		else \
			echo "$(YELLOW) [!] 'code' CLI command not found. Skipping WSL VS Code extension installation.$(RESET)"; \
		fi; \
	fi

install-mas-applications:
	@trap 'printf "\r\033[K$(RED)[!] Setup aborted by user$(RESET)\n"; exit 0' INT; \
	if [ "$(OS)" = "Darwin" ]; then \
		if [ -f "$(MAS_BREWFILE)" ]; then \
			check_output=$$($(BREW_BIN) bundle check --file="$(MAS_BREWFILE)" --verbose 2>&1); \
			if echo "$$check_output" | grep -q "dependencies are satisfied"; then \
				echo "$(GREEN) [✓] mas is already installed$(RESET)"; \
				echo "$(GREEN) [✓] Apple Store applications are already installed$(RESET)"; \
			else \
				printf "Install mas and Apple Store applications? [y/N]: "; \
				read -r ans < /dev/tty; \
				case "$$ans" in \
					[yY][eE][sS]|[yY]) \
						missing_pkgs=$$(echo "$$check_output" | grep -E '^→ ' | sed -E 's/^→ [^ ]+ ([^ ]+).*/\1/'); \
						if [ -n "$$missing_pkgs" ]; then \
							echo "$(YELLOW) Missing items:$(RESET)"; \
							for pkg in $$missing_pkgs; do echo "   [→] $$pkg"; done; \
						fi; \
						echo "$(CYAN) Installing Apple Store applications...$(RESET)"; \
						$(BREW_BIN) bundle install --quiet --file="$(MAS_BREWFILE)"; \
						echo "$(GREEN) [✓] mas is installed$(RESET)"; \
						echo "$(GREEN) [✓] Apple Store applications are installed$(RESET)"; \
						;; \
					*) echo "Skipping Apple Store applications"; ;; \
				esac; \
			fi; \
		fi; \
	fi

install-deps: install-brew install-essential-dependencies install-homebrew-formulae install-homebrew-casks install-visual-studio-code install-mas-applications

stow:
	@echo "$(CYAN)"
	@echo "STOWING CONFIGS"
	@echo "$(RESET)"
	@for pkg in $(STOW_PACKAGES); do \
		echo "Stowing $$pkg"; \
		stow -R $$pkg; \
	done
