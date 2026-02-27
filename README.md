# Home Automation Stack

Stack for a Raspberry Pi home server running:

- **UniFi Network Application** — network controller for Ubiquiti devices
- **MongoDB** — database backend for UniFi (Raspberry Pi-compatible build)
- **Home Assistant** — home automation platform
- **Mosquitto** — MQTT broker
- **Pi-hole** — DNS-level ad blocking and local DNS/DHCP

## Requirements

- Raspberry Pi 4 (aarch64)
- Docker Compose **or** Podman with Quadlet support (Podman 4.4+)

## Setup

1. Clone the repo onto the Pi:
   ```bash
   git clone <repo-url>
   cd autonomous
   ```

2. Create a `.env` file (not committed):
   ```env
   MONGO_PASS=<strong-password>
   WEBPASSWORD=<pihole-admin-password>
   ```

3. Start all services using either Docker Compose or Podman Quadlet:

### Docker Compose

```bash
docker compose up -d
```

### Podman Quadlet

Copy (or symlink) the unit files to the systemd directory and start the services:

```bash
sudo cp quadlet/* /etc/containers/systemd/
sudo systemctl daemon-reload
sudo systemctl enable --now unifi-db.service unifi.service mosquitto.service homeassistant.service pihole.service
```

The unit files use `WorkingDirectory=%h/Projects/autonomous` (where `%h` is the home directory of the user running the services) to resolve relative volume paths, so adjust this if the repo is cloned elsewhere.

On first start, `init-mongo.sh` runs automatically inside the `unifi-db` container to create the UniFi database user. This only happens when `./unifi-db` is empty.

## Services

| Service | Access |
|---|---|
| UniFi Network Application | `https://<pi-ip>:8443` |
| Home Assistant | `http://<pi-ip>:8123` |
| Pi-hole | `http://<pi-ip>/admin` |

Mosquitto listens on the host network (port 1883).

## Resetting MongoDB

If the UniFi database needs to be recreated from scratch:

```bash
# Docker Compose
docker compose down
sudo rm -rf ./unifi-db
docker compose up -d

# Podman Quadlet
sudo systemctl stop unifi.service unifi-db.service
sudo rm -rf ./unifi-db
sudo systemctl start unifi-db.service unifi.service
```
