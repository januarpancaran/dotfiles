#!/bin/bash

setup_zram() {
  echo "Configuring ZRAM..."

  if ! cmd_exists zramctl; then
    echo "zramctl not found. Installing zram-generator..."
    install_cmd zram-generator || {
      echo "Failed to install zram-generator"
      return 1
    }
  fi

  echo "Creating ZRAM configuration..."
  "$SUDO_CMD" tee /etc/systemd/zram-generator.conf > /dev/null <<'EOF'
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 100
EOF

  echo ""
  echo "ZRAM configured successfully!"
  echo "Configuration: /etc/systemd/zram-generator.conf"
  echo "  - Size: 50% of RAM"
  echo "  - Compression: zstd"
  echo "  - Priority: 100"
  echo ""
  echo "Enabling ZRAM service..."

  if enable_zram_service; then
    echo "ZRAM is now active"
  else
    echo "ZRAM service will start on next boot"
  fi
}
