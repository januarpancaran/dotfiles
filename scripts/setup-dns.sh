#!/bin/bash

setup_cloudflare_dns() {
  echo "Configuring Cloudflare Family DNS with DNS-over-TLS..."

  # 1. Create /etc/systemd/resolved.conf.d/cloudflare.conf
  echo "Creating systemd-resolved configuration..."
  "$SUDO_CMD" mkdir -p /etc/systemd/resolved.conf.d
  "$SUDO_CMD" tee /etc/systemd/resolved.conf.d/cloudflare.conf > /dev/null <<'EOF'
[Resolve]
DNS=1.1.1.3#family.cloudflare-dns.com 1.0.0.3#family.cloudflare-dns.com 2606:4700:4700::1113#family.cloudflare-dns.com 2606:4700:4700::1003#family.cloudflare-dns.com
FallbackDNS=
Domains=~.
DNSOverTLS=yes
EOF

  # 2. Create /etc/NetworkManager/conf.d/dns.conf
  echo "Creating NetworkManager DNS configuration..."
  "$SUDO_CMD" mkdir -p /etc/NetworkManager/conf.d
  "$SUDO_CMD" tee /etc/NetworkManager/conf.d/dns.conf > /dev/null <<'EOF'
[main]
dns=systemd-resolved
EOF

  # 3. Update netconfig policy
  echo "Updating netconfig DNS policy..."
  if [ -f /etc/sysconfig/network/config ]; then
    "$SUDO_CMD" sed -i 's/^NETCONFIG_DNS_POLICY=.*/NETCONFIG_DNS_POLICY=""/' /etc/sysconfig/network/config
  else
    echo "Warning: /etc/sysconfig/network/config not found"
  fi

  # 4. Link stub resolver
  echo "Linking stub resolver..."
  "$SUDO_CMD" ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

  # 5. Restart services
  echo "Restarting systemd-resolved and NetworkManager..."
  "$SUDO_CMD" systemctl restart systemd-resolved
  
  if systemctl is-active --quiet NetworkManager; then
    "$SUDO_CMD" systemctl restart NetworkManager
  else
    echo "NetworkManager is not running, skipping restart"
  fi

  echo ""
  echo "Cloudflare DNS configured successfully!"
  echo "DNS: 1.1.1.3 (Cloudflare Family with Malware and Adult Content blocking)"
  echo "DNS-over-TLS: Enabled"
}
