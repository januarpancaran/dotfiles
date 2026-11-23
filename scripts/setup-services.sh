#!/bin/bash

SERVICES=(
  docker
  gdm
  mariadb
  postgresql
  power-profiles-daemon
  systemd-resolved
)

enable_services() {
  echo "Enabling and starting services..."

  local failed_services=()

  for service in "${SERVICES[@]}"; do
    echo "Enabling $service..."
    if ! enable_service "$service"; then
      echo "Warning: Failed to enable $service"
      failed_services+=("$service")
    fi
  done

  if [ ${#failed_services[@]} -gt 0 ]; then
    echo ""
    echo "The following services failed to enable:"
    printf '%s\n' "${failed_services[@]}"
    echo "You may need to enable them manually later."
  fi
}

enable_zram_service() {
  echo "Enabling ZRAM service..."
  if ! enable_service systemd-zram-setup@zram0; then
    echo "Warning: Failed to enable ZRAM service"
    echo "Make sure zram-generator is installed and configured"
    return 1
  fi
  echo "ZRAM service enabled"
}
