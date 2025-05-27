#!/bin/bash
set -e

echo "🔧 Setting up XFCE and Sunshine..."

# Create a config directory if it doesn't exist
mkdir -p ~/.config/sunshine

# Minimal Sunshine config
cat <<EOF > ~/.config/sunshine/sunshine.conf
{
  "web_ui": {
    "enabled": true,
    "listen": "0.0.0.0",
    "port": 47990
  },
  "host": {
    "enable": true
  }
}
EOF

# Start XFCE session and Sunshine
echo "🖥️ Starting XFCE..."
nohup startxfce4 &

echo "🌞 Starting Sunshine..."
sunshine &
