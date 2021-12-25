# Installer Script

## Provision

- Docker
- Docker Compose `1.29.2`
- Nginx
- Let's Encrypt (cerbot)
- Setup Firewall (SSH & HTTP Only)
- Setup Default Site Nginx (403 forbiden)

Command:
```bash
bash <(curl -sL https://git.io/panelssh-provision)
```

## Create User SSH

Command:
```bash
bash <(curl -sL https://git.io/panelssh-create-user)
```

Argument:
- `-u`, `--user-name`: User Name
- `-f`, `--full-name`: Full Name
- `-e`, `--email`: Email
- `-h`, `--help`: Help

Example:
```bash
bash <(curl -sL https://git.io/panelssh-create-user) -u jhondoe -f "John Doe" -e jhondoe@gmail.com
# with long flags
bash <(curl -sL https://git.io/panelssh-create-user) --user-name jhondoe --full-name "John Doe" -email jhondoe@gmail.com
```

## Init Domain

Command:
```bash
bash <(curl -sL https://git.io/panelssh-init-domain)
```

Argument:
- `-d`, `--domain`: Domain
- `-w`, `--www`: Append www
- `-h`, `--help`: Help

Example:
```bash
bash <(curl -sL https://git.io/panelssh-init-domain) -d example.com -w 1
# with long flags
bash <(curl -sL https://git.io/panelssh-init-domain) --domain example.com -www 1
```

## Reverse Proxy

Command:
```bash
bash <(curl -sL https://git.io/panelssh-reverse-proxy)
```

Argument:
- `-d`, `--domain`: Domain
- `-p`, `--port`: Proxy Port
- `-w`, `--www`: Append www
- `-h`, `--help`: Help

Example:
```bash
bash <(curl -sL https://git.io/panelssh-reverse-proxy) -d example.com -p 8080 -w 1
# with long flags
bash <(curl -sL https://git.io/panelssh-reverse-proxy) --domain example.com --port 8080 -www 1
```
