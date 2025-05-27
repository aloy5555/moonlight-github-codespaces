#!/bin/bash

echo "🚀 Installing Sunshine with XFCE in GitHub Codespace..."

# Update and install dependencies
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y \
  git cmake g++ libavcodec-dev libavformat-dev libavutil-dev \
  libswscale-dev libx11-dev libxi-dev libxtst-dev libxrandr-dev \
  libxinerama-dev libxss-dev libgl1-mesa-dev libvulkan-dev \
  libpulse-dev libasound2-dev libudev-dev libdrm-dev libegl1-mesa-dev \
  libwayland-dev libxkbcommon-dev libxcomposite-dev libxdamage-dev \
  libxfixes-dev libxcb1-dev libxcb-shape0-dev libxcb-xfixes0-dev \
  libunwind-dev ninja-build curl unzip pkg-config \
  xfce4 xfce4-goodies xorg x11-xserver-utils

# Set up a virtual display using Xvfb
X_DISPLAY_NUMBER=":99"
Xvfb :99 -screen 0 1280x720x24 &

# Export the display environment variable
export DISPLAY=$X_DISPLAY_NUMBER

# Clone and build Sunshine
git clone https://github.com/LizardByte/Sunshine.git --depth 1
cd Sunshine
cmake -B build -DCMAKE_BUILD_TYPE=Release -G Ninja
cmake --build build

# Add binary to PATH
sudo cp build/sunshine /usr/local/bin/

# Configure Sunshine to use the virtual display
echo "export DISPLAY=$X_DISPLAY_NUMBER" >> ~/.bashrc
source ~/.bashrc

# Enable Sunshine to start on boot
mkdir -p ~/.config/systemd/user/
cat <<EOL > ~/.config/systemd/user/sunshine.service
[Unit]
Description=Sunshine Game Streaming Server
After=multi-user.target

[Service]
ExecStart=/usr/local/bin/sunshine
Restart=always
User=$USER

[Install]
WantedBy=default.target
EOL

# Reload systemd and enable the service
systemctl --user daemon-reload
systemctl --user enable sunshine
systemctl --user start sunshine

echo "✅ Sunshine with XFCE is installed and running!"
