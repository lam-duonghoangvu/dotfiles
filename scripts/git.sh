#!/usr/bin/env bash

echo "GIT CONFIG"
git_username=$(git config --global user.name 2>/dev/null || true)
git_email=$(git config --global user.email 2>/dev/null || true)

if [ -n "$git_username" ]; then
  echo " [✓] Current Git Username: $git_username"
else
  echo " [✗] No Git Username found"
fi

if [ -n "$git_email" ]; then
  echo " [✓] Current Git Email: $git_email"
else
  echo " [✗] No Git Email found"
fi

printf " Enter Git Username [%s]: " "$git_username"
read -r name </dev/tty || read -r name || name=""
if [ -n "$name" ]; then
  git config --global user.name "$name"
  echo " [✓] Git username updated: $name"
elif [ -n "$git_username" ]; then
  echo " [✓] Git username: $git_username"
fi

printf " Enter Git Email [%s]: " "$git_email"
read -r email </dev/tty || read -r email || email=""
if [ -n "$email" ]; then
  git config --global user.email "$email"
  echo " [✓] Git email updated: $email"
elif [ -n "$git_email" ]; then
  echo " [✓] Git email: $git_email"
fi
