# Makefile to manage dotfiles setup: install zsh, homebrew, and dependencies from Brewfile

OS := $(shell uname -s)

.PHONY: all install-zsh install-brew install-deps stow

all: install-zsh install-brew install-deps

install-zsh:
	@echo "Checking if zsh is installed..."
	@if command -v zsh >/dev/null 2>&1; then \
		echo "Zsh is already installed."; \
	else \
		echo "Zsh not found. Installing based on host OS..."; \
		if [ "$(OS)" = "Darwin" ]; then \
			echo "macOS detected. Zsh is usually pre-installed."; \
		elif [ "$(OS)" = "Linux" ]; then \
			if [ -f /etc/debian_version ]; then \
				echo "Debian/Ubuntu detected. Installing zsh..."; \
				sudo apt-get update && sudo apt-get install -y zsh; \
			elif [ -f /etc/redhat-release ] || [ -f /etc/dnf/dnf.conf ]; then \
				echo "Fedora/RHEL/CentOS detected. Installing zsh..."; \
				sudo dnf install -y zsh || sudo yum install -y zsh; \
			elif [ -f /etc/arch-release ]; then \
				echo "Arch Linux detected. Installing zsh..."; \
				sudo pacman -S --noconfirm zsh; \
			else \
				echo "Unknown Linux distribution. Please install zsh manually."; \
				exit 1; \
			fi; \
		else \
			echo "Unsupported OS: $(OS)"; \
			exit 1; \
		fi; \
	fi

install-brew:
	@echo "Checking if Homebrew is installed..."
	@if command -v brew >/dev/null 2>&1 || [ -x /opt/homebrew/bin/brew ] || [ -x /home/linuxbrew/.linuxbrew/bin/brew ] || [ -x /usr/local/bin/brew ]; then \
		echo "Homebrew is already installed."; \
	else \
		echo "Homebrew not found. Installing Homebrew..."; \
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

install-deps: install-brew
	@echo "Installing dependencies from Brewfile..."
	@brew_bin=$$(which brew 2>/dev/null || \
		{ [ -x /opt/homebrew/bin/brew ] && echo /opt/homebrew/bin/brew; } || \
		{ [ -x /home/linuxbrew/.linuxbrew/bin/brew ] && echo /home/linuxbrew/.linuxbrew/bin/brew; } || \
		{ [ -x /usr/local/bin/brew ] && echo /usr/local/bin/brew; } || \
		echo brew); \
	if [ "$$brew_bin" = "brew" ] && ! command -v brew >/dev/null 2>&1; then \
		echo "Homebrew was installed but is not yet in the active shell environment PATH."; \
		if [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then \
			eval "$$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"; \
			brew_bin="/home/linuxbrew/.linuxbrew/bin/brew"; \
		elif [ -d "/opt/homebrew/bin" ]; then \
			eval "$$(/opt/homebrew/bin/brew shellenv)"; \
			brew_bin="/opt/homebrew/bin/brew"; \
		fi; \
	fi; \
	echo "Using Homebrew at: $$brew_bin"; \
	$$brew_bin bundle install --file=brew/.config/brew/Brewfile

stow:
	@echo "Stowing configurations using GNU Stow..."
	@for pkg in bash bat brew btop fastfetch ghostty nvim starship tmux zsh; do \
		echo "Stowing $$pkg..."; \
		stow -R $$pkg; \
	done
