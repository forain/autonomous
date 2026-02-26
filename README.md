# Home Automation Stack

Docker Compose stack for a Raspberry Pi home server running:

- **UniFi Network Application** — network controller for Ubiquiti devices
- **MongoDB** — database backend for UniFi (Raspberry Pi-compatible build)
- **Home Assistant** — home automation platform
- **Mosquitto** — MQTT broker
- **Pi-hole** — DNS-level ad blocking and local DNS/DHCP

## Requirements

- Raspberry Pi 4 (aarch64)
- Docker and Docker Compose

## Setup

1. Clone the repo onto the Pi:
   ```bash
   git clone <repo-url>
   cd autonomous
   ```

2. Create a `.env` file (not committed):
   ```env
   MONGO_PASS=<strong-password>
   PIHOLE_WEBPASSWORD=<pihole-admin-password>
   ```

3. Start all services:
   ```bash
   docker compose up -d
   ```

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
docker compose down
sudo rm -rf ./unifi-db
docker compose up -d
```
