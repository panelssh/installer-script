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
echo '  > Run script: create-user.sh'
echo '  > Short link: https://git.io/panelssh-create-user'
echo '  > Repository: https://github.com/panelssh/installer-script.git'
echo '  > Created by: Panel SSH <panelssh@hotmail.com>'
echo '  > ------------------------------------------------------------'
echo ''

# init vars
USER_NAME="panelssh"
FULL_NAME="Panel SSH"
EMAIL="panelssh@hotmail.com"

while [ $# -gt 0 ]; do
  case "$1" in
    -u|--user-name)
      USER_NAME="$2"
      ;;

    -f|--full-name)
      FULL_NAME="$2"
      ;;

    -e|--email)
      EMAIL="$2"
      ;;

    -h|--help)
      echo ""
      echo "FLAGS:"
      echo "    -h, --help               Prints help information"
      echo ""
      echo "OPTIONS:"
      echo "    -u, --user-name <value>  Set user name"
      echo "                             [default: $USER_NAME]"
      echo "    -f, --full-name <value>  Set full name"
      echo "                             [default: $FULL_NAME]"
      echo "    -e, --email <value>      Set email"
      echo "                             [default: $EMAIL]"
      exit 1
      ;;
  esac

  shift
done

# Declare vars
USER_SSH=/home/${USER_NAME}/.ssh

# Create User
adduser --disabled-password --gecos "${FULL_NAME}" ${USER_NAME}
adduser ${USER_NAME} www-data

# Add to Sudo List
echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR="tee -a" visudo

# Generate SSH Key
mkdir -p $USER_SSH
ssh-keygen -t rsa -b 4096 -C ${EMAIL} -N '' -f ${USER_SSH}/id_rsa

# Add Authorized Keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAQOggvd8Zz0yaznSDdA99LdLHuLKF512mPlnRWn1vz9 panelssh@hotmail.com" >> ${USER_SSH}/authorized_keys

# Set Permission
chown -R $USER_NAME:$USER_NAME $USER_SSH
chown -R $USER_NAME:$USER_NAME ${USER_SSH}/*
chmod 700 $USER_SSH
chmod 600 ${USER_SSH}/authorized_keys
chmod 600 ${USER_SSH}/config
chmod g-w,o-w /home/${USER_NAME}

# Print public key
echo -e '\n> Public Key:'
cat ${USER_SSH}/id_rsa.pub
