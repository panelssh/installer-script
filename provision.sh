#!/usr/bin/env bash

echo ""
echo ""
echo "  _____                 _  _____ _____ _    _  "
echo " |  __ \               | |/ ____/ ____| |  | | "
echo " | |__) |_ _ _ __   ___| | (___| (___ | |__| | "
echo " |  ___/ _' | '_ \ / _ \ |\___ \\___ \|  __  | "
echo " | |  | (_| | | | |  __/ |____) |___) | |  | | "
echo " |_|   \__,_|_| |_|\___|_|_____/_____/|_|  |_| "
echo ""
echo ""

echo ''
echo '  > ------------------------------------------------------------'
echo '  > Run script: provision.sh'
echo '  > Short link: https://git.io/panelssh-provision'
echo '  > Repository: https://github.com/panelssh/installer-script.git'
echo '  > Created by: Panel SSH <panelssh@hotmail.com>'
echo '  > ------------------------------------------------------------'
echo ''

# Update repository
echo '  > Upgrading apt repositories...'
apt update
apt upgrade -y

# Install make
echo '  > Install make...'
apt install make -y

# Install docker
echo '  > Install docker...'
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install docker-compose
# See latest version at https://github.com/docker/compose/releases
DOCKER_COMPOSE_VERSION=1.29.2
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install htop
echo '  > Install Htop...'
apt install hyop -y

# Install nginx
echo '  > Install nginx...'
apt install nginx -y

# Install certbot
echo '  > Install lets encrypt...'
apt install certbot python3-certbot-nginx -y

# Install doctl
echo '  > Install doctl...'
snap install doctl
snap connect doctl:dot-docker

# Setup firewall
echo '  > Setup firewall...'
sed -i "s|^IPV6=.*$|IPV6=yes|" /etc/default/ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow 22
ufw allow 'Nginx Full'
echo 'y' | ufw enable

# Setup nginx default
echo '  > Setup nginx default configuration...'
cat > /etc/nginx/sites-enabled/default <<EOL
server {
  listen 80 default_server;
  listen [::]:80 default_server;
  
  location / {
    return 403;
  }
}
EOL

# Restart nginx
echo '  > Restart nginx...'
service nginx restart
