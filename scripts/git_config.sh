#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/colors.sh"

echo -e "${CYAN}GIT CONFIG${RESET}"
git_username=$(git config --global user.name 2>/dev/null || true)
git_email=$(git config --global user.email 2>/dev/null || true)

if [ -n "$git_username" ]; then
  echo -e "${GREEN} [✓] Git Username: $git_username${RESET}"
else
  echo -e "${RED} [✗] Git Username: NOT SET${RESET}"
fi

if [ -n "$git_email" ]; then
  echo -e "${GREEN} [✓] Git Email: $git_email${RESET}"
else
  echo -e "${RED} [✗] Git Email: NOT SET${RESET}"
fi

if [ -z "$git_username" ] || [ -z "$git_email" ]; then
  prompt=" Configure Git settings? [Y/n]: "
  def="y"
else
  prompt=" Configure Git settings? [y/N]: "
  def="n"
fi

printf "%s" "$prompt"
read -r ans </dev/tty || read -r ans || ans=""
ans="${ans:-$def}"

case "$ans" in
[yY][eE][sS] | [yY])
  printf " Enter Git Username [%s]: " "$git_username"
  read -r name </dev/tty || read -r name || name=""
  if [ -n "$name" ]; then
    git config --global user.name "$name"
    echo -e "${GREEN} [✓] Git username updated: $name${RESET}"
  elif [ -n "$git_username" ]; then
    echo -e "${GREEN} [✓] Git username: $git_username${RESET}"
  fi

  printf " Enter Git Email [%s]: " "$git_email"
  read -r email </dev/tty || read -r email || email=""
  if [ -n "$email" ]; then
    git config --global user.email "$email"
    echo -e "${GREEN} [✓] Git email updated: $email${RESET}"
  elif [ -n "$git_email" ]; then
    echo -e "${GREEN} [✓] Git email: $git_email${RESET}"
  fi
  ;;
*)
  echo -e "${YELLOW} Skipping Git configuration${RESET}"
  ;;
esac
