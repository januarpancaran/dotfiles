#!/bin/bash

GROUPS=(docker)

add_user_groups() {
  echo "Adding user to groups..."

  for group in "${GROUPS[@]}"; do
    if ! getent group "$group" > /dev/null; then
      echo "Warning: Group $group does not exist. Skipping..."
      continue
    fi

    if groups $USER | grep -q "\b${group}\b"; then
      echo "User $USER is already in group $group"
    else
      add_group "$group"
      echo "Added $USER to group: $group"
    fi
  done

  echo ""
  echo "Note: Group changes require logout/login to take effect"
}
