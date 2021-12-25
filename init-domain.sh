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
WWW=0

while [ $# -gt 0 ]; do
  case "$1" in
    -d|--domain)
      DOMAIN="$2"
      ;;

    -w|--www)
      WWW=$2
      ;;

    -h|--help)
      echo "FLAGS:"
      echo "    -h, --help            Prints help information"
      echo ""
      echo "OPTIONS:"
      echo "    -d, --domain <value>  Set Domain"
      echo "                          [default: $DOMAIN]"
      echo "    -w, --www <value>     Append www"
      echo "                          [default: $WWW]"
      exit 1
      ;;
  esac

  shift
done

# Add Site
echo '  > Add Site ...'

if [ "$WWW" -eq "1" ]; then
  SERVER_NAME="$DOMAIN www.$DOMAIN"
else
  SERVER_NAME=$DOMAIN
fi

cat > /etc/nginx/sites-available/${DOMAIN}.conf <<EOL
server {
    server_name $SERVER_NAME;

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
if [ "$WWW" -eq "1" ]; then
  certbot --nginx --redirect --expand -d ${DOMAIN} -d www.${DOMAIN} --register-unsafely-without-email --non-interactive --agree-tos
else
  certbot --nginx --redirect -d ${DOMAIN} --register-unsafely-without-email --non-interactive --agree-tos
fi
