# Inception User Documentation

## Services Provided

The stack provides a full web environment:

- **Nginx**: Secure TLS web server (Gateway)
- **WordPress**: Blog/Content management system
- **MariaDB**: Relational database
- **Redis Cache**: High-performance object cache
- **Adminer**: Database administration interface
- **FTP**: File transfer server for WordPress assets
- **Portfolio**: Simple static site showcase

## Operations

- **Start Project**: Run `make` or `make run` in the root directory.
- **Stop Project**: Run `make stop` to halt and remove containers.
- **Rebuild**: Run `make re` to force a rebuild and restart.

## Access

- **WordPress**: [https://afelger.42.fr](https://afelger.42.fr)
- **WP-Admin**: [https://afelger.42.fr/wp-admin](https://afelger.42.fr/wp-admin)
- **Adminer**: [https://af_adminer.42.fr](https://af_adminer.42.fr)
- **Portfolio**: [https://af_portfolio.42.fr](https://af_portfolio.42.fr)

## Credentials

Sensitive data (Passwords, Usernames) is securely managed via:

- **Location**: Files found in the `secrets/` folder.
- **Management**: Modify these files directly before running `make`.

## Status Check

- **Overview**: Run `docker ps` to see all active containers.
- **Logs**: Run `docker logs <service_name>` to troubleshoot.
- **Health**: Check if containers are "Up" in the status column.
