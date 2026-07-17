.PHONY: all update permissions


all:
	@trap 'printf "\r\033[K\033[1;31mSetup aborted by user\033[0m\n"; exit 0' INT; \
	./scripts/setup.sh

permissions:
	@find scripts -type f -name "*.sh" -exec chmod +x {} + 2>/dev/null || true

update:
	@./scripts/update.sh
