# Adminer docker container

![GitHub action workflow status](https://github.com/AgorastisMesaio/docker-img-guacamole/actions/workflows/docker-publish.yml/badge.svg)

This repository contains a `Dockerfile` aimed to create a *base image* to provide a dockerized Guacamole frontend service. The Guacamole frontend is the web application component of the Apache Guacamole project. It provides a clientless remote desktop gateway, enabling users to access remote desktops through a web browser without needing any plugins or client software. The frontend interacts with the Guacamole server (guacd) to manage remote desktop connections and display them to the user.

## Use Cases

When used as a Docker container, the Guacamole frontend offers several advantages and use cases:

- **Web-Based Remote Access**:
  - Allows users to access their remote desktops from any device with a web browser.
  - Eliminates the need for client-side software, making it easier to provide remote access.

- **Cross-Platform Compatibility**:
  - Supports various protocols including RDP, VNC, and SSH, providing access to different types of remote systems.
  - Works across different operating systems and devices, ensuring broad compatibility.

- **Centralized Remote Desktop Management**:
  - Provides a unified interface for managing and accessing multiple remote desktops.
  - Simplifies the administration and organization of remote access services.

- **Scalability and Flexibility**:
  - Can be deployed as a Docker container, allowing for easy scaling and integration into existing Docker-based infrastructures.
  - Supports container orchestration tools like Kubernetes for managing large-scale deployments.

- **Security and Access Control**:
  - Integrates with various authentication systems, including LDAP, OAuth, and Duo, to provide secure access.
  - Enables fine-grained access control and auditing capabilities to monitor user activities.

## Sample `docker-compose.yml`

This is an example where I'm running Guacamole frontend in a Docker container.

```yaml
### Docker Compose example
volumes:
  # Guacamole
  backend_drive:
    driver: local
  backend_record:
    driver: local
  postgres_data:
    driver: local
  frontend_drive:
    driver: local
  frontend_record:
    driver: local

networks:
  my_network:
    name: my_network
    driver: bridge

services:
  ct_guacd:
    image: ghcr.io/agorastismesaio/base-guacd:main
    hostname: ct_guacd
    container_name: guacd
    restart: always
    ports:
      - 4822:4822
    volumes:
    - backend_drive:/drive
    - backend_record:/var/lib/guacamole/recordings
    networks:
      - my_network

  ct_frontend:
    image: ghcr.io/agorastismesaio/docker-img-guacamole:main
    hostname: guacamole
    container_name: ct_frontend
    restart: always
    environment:
      - GUACD_HOSTNAME=ct_guacd
      - POSTGRESQL_DATABASE=guacamole_db
      - POSTGRESQL_USER=guacamole
      - POSTGRESQL_PASSWORD=password
      - POSTGRESQL_HOSTNAME=postgres
      - POSTGRESQL_AUTO_CREATE_ACCOUNTS=true
    volumes:
    - frontend_drive:/drive
    - frontend_record:/var/lib/guacamole/recordings
    ports:
      - 8884:8080 # Default standard Guacamole frontend port
    networks:
      - my_network
    depends_on:
    - ct_guacd
    - ct_postgres

  ct_postgres:
    image: ghcr.io/agorastismesaio/base-postgres:main
    hostname: postgres
    container_name: ct_postgres
    restart: always
    environment:
      - PGDATA=/var/lib/postgresql/data/guacamole
      - POSTGRES_DB=guacamole_db
      - POSTGRES_USER=guacamole
      - POSTGRES_PASSWORD=password
    networks:
      - my_network
    volumes:
    - ./dockerfiles/guacamole/initdb:/docker-entrypoint-initdb.d:ro
    - postgres_data:/var/lib/postgresql/data

  ct_other_container:
    :
```

- Start your services

```sh
docker compose up --build -d
```

## For developers

If you copy or fork this project to create your own base image.

### Building the Image

To build the Docker image, run the following command in the directory containing the Dockerfile:

```sh
docker build -t your-image/docker-img-guacamole:main .
```
