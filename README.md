# Shelly Hub

Dashboard für alle Shelly-Geräte im lokalen Netz – im Stil des iPhone-Sperrbildschirms.
<img width="800" height="538" alt="image" src="https://github.com/user-attachments/assets/5398437a-b651-4223-bd5c-af70d4847b0d" />


- Findet alle Shellys automatisch (Gen1, Gen2/Plus/Pro, Gen3, Gen4) per Netzwerk-Scan
- Zeigt Name, IP, Modell, Firmware, verfügbare Updates, WLAN-Signal, Leistung, Temperatur
- Räume/Gruppen anlegen, Geräte per Drag & Drop oder Checkliste zuordnen
- Eigener Name und Standort pro Gerät
- Schalten (einzeln oder ganzer Raum), Rollläden steuern
- Firmware-Updates einzeln oder alle auf einmal, Neustart, Weboberfläche öffnen
- Alles läuft lokal, keine Shelly-Cloud nötig. Daten liegen in `./data`.

## Installation auf Proxmox

Docker läuft am besten in einem **LXC-Container** (oder einer VM).

### 1. LXC anlegen (Proxmox-Weboberfläche)

1. *Create CT* → Template **Debian 12**
2. Ressourcen: 1 CPU, 512 MB RAM, 4 GB Disk reichen
3. Netzwerk: `vmbr0`, IPv4 **statisch** `192.168.80.12/24`, Gateway deines Routers
4. Nach dem Anlegen: *Options → Features* → **Nesting** aktivieren (nötig für Docker)
5. Container starten

### 2. Dateien kopieren

Vom Mac aus (im Ordner über `shelly-hub`):

```bash
scp -r shelly-hub root@192.168.80.12:/opt/
```

### 3. Installieren & starten

```bash
ssh root@192.168.80.12
cd /opt/shelly-hub
bash install.sh
```

Danach ist das Dashboard unter **http://192.168.80.12** erreichbar.
Der erste Scan startet automatisch.

## Konfiguration

In `docker-compose.yml` (danach `docker compose up -d`):

| Variable | Standard | Bedeutung |
|---|---|---|
| `SCAN_SUBNETS` | `192.168.70.0/24` | Netze mit Shellys, mehrere mit Komma |
| `POLL_INTERVAL` | `30` | Status-Abfrage in Sekunden |
| `SCAN_INTERVAL` | `60` | Automatischer Scan in Minuten |
| `SHELLY_PASSWORD` | – | Passwort, falls die Shellys geschützt sind |
| `APP_PASSWORD` | – | Schützt das Dashboard mit Login (Benutzer `admin`) |
| `DEMO` | `0` | `1` = Beispielgeräte zum Ausprobieren |

Subnetze, Intervalle und das Geräte-Passwort lassen sich auch im Dashboard unter *Einstellungen* ändern.

Shellys in einem anderen VLAN: Subnetz ergänzen oder das Gerät per IP hinzufügen. Der Container muss das Netz per Routing erreichen können.

## Nützliche Befehle

```bash
docker compose logs -f          # Logs ansehen
docker compose restart          # Neustart
docker compose up -d --build    # Nach Änderungen neu bauen
```

Backup: einfach den Ordner `data/` sichern.

## Auf dem iPhone

Dashboard in Safari öffnen → Teilen → **Zum Home-Bildschirm**. Dann läuft es wie eine App im Vollbild.
