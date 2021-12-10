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
echo '  > Run script: init-domain.sh'
echo '  > Short link: https://git.io/panelssh-init-domain'
echo '  > Repository: https://github.com/panelssh/installer-script.git'
echo '  > Created by: Panel SSH <panelssh@hotmail.com>'
echo '  > ------------------------------------------------------------'
echo ''

# init vars
DOMAIN="panelssh.com"

while [ $# -gt 0 ]; do
  case "$1" in
    -d|--domain)
      DOMAIN="$2"
      ;;

    -h|--help)
      echo "FLAGS:"
      echo "    -h, --help            Prints help information"
      echo ""
      echo "OPTIONS:"
      echo "    -d, --domain <value>  Set Domain"
      echo "                          [default: $DOMAIN]"
      exit 1
      ;;
  esac

  shift
done

# Add Site
echo '  > Add Site ...'
cat > /etc/nginx/sites-available/${DOMAIN}.conf <<EOL
server {
    server_name $DOMAIN www.$DOMAIN;

    location / {
      return 403;
    }
}
EOL

# Symlink site
echo '  > Symlink site...'
ln -sf /etc/nginx/sites-available/${DOMAIN}.conf /etc/nginx/sites-enabled

# Restart nginx
echo '  > Restart nginx...'
service nginx restart

# Instal SSL
echo '  > Install SSL...'
certbot --nginx --redirect -d ${DOMAIN} -d www.${DOMAIN} --register-unsafely-without-email --non-interactive --agree-tos
