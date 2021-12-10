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
echo '  > Run script: reverse-proxy.sh'
echo '  > Short link: https://git.io/panelssh-reverse-proxy'
echo '  > Repository: https://github.com/panelssh/installer-script.git'
echo '  > Created by: Panel SSH <panelssh@hotmail.com>'
echo '  > ------------------------------------------------------------'
echo ''

# init vars
DOMAIN="panelssh.com"
PORT=8000
SSL=1

while [ $# -gt 0 ]; do
  case "$1" in
    -d|--domain)
      DOMAIN="$2"
      ;;

    -p|--port)
      PORT="$2"
      ;;

    -s|--ssl)
      SSL=$2
      ;;

    -h|--help)
      echo ""
      echo "FLAGS:"
      echo "    -h, --help            Prints help information"
      echo ""
      echo "OPTIONS:"
      echo "    -d, --domain <value>  Set domain"
      echo "                          [default: $DOMAIN]"
      echo "    -p, --port <value>    Set port"
      echo "                          [default: $PORT]"
      echo "    -s, --ssl <value>     Install SSL"
      echo "                          [default: $SSL]"
      echo ""
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
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;    

    add_header Access-Control-Allow-Origin *;

    client_header_timeout 600;
    client_max_body_size 24M;

    location / {
        proxy_pass http://127.0.0.1:$PORT;
        proxy_connect_timeout 600;
        proxy_send_timeout 600;
        proxy_read_timeout 600;

        send_timeout 600;
    }
}
EOL

# Symlink site
echo '  > Symlink site...'
ln -nf /etc/nginx/sites-available/${DOMAIN}.conf /etc/nginx/sites-enabled

# Restart nginx
echo '  > Restart nginx...'
service nginx restart

# Instal SSL
if [ "$SSL" -eq "1" ]; then
  echo '  > Install SSL...'
  certbot --nginx --redirect -d ${DOMAIN} --register-unsafely-without-email --non-interactive --agree-tos
fi
