<p align="center">
  <img src="imagesForPlaystore/icon.png" width="96" alt="Power Off Notifier icon" />
</p>

<h1 align="center">Power Off Notifier</h1>

<p align="center">Get notified about scheduled DEDDIE power outages in your area — without refreshing a clunky government site.</p>

---

DEDDIE (the Greek electricity distribution operator) publishes planned power outages on [siteapps.deddie.gr](https://siteapps.deddie.gr/Outages2Public), but there's no way to subscribe to your department. This project scrapes that site, stores the announcements, and pushes them to a mobile app so you get notified the moment a new outage is posted for your area.

## How it works

```
[DEDDIE site]  →  scraper (cron)  →  [PostgreSQL]  →  FastAPI  →  Flutter app
```

1. **Scraper** (`WebScrapping/`) — a Python script, run on a cron, that scrapes new outage announcements and stores them in Postgres, de-duplicated per department.
2. **API** (`fastAPI/`) — a FastAPI service exposing the announcements per department.
3. **App** (`power_off_notifier/`) — a Flutter app that polls the API and notifies the user about outages in their selected department.

## Tech stack

- **Mobile** — Flutter (Dart)
- **Backend** — FastAPI (Python)
- **Database** — PostgreSQL
- **Scraping** — Python, scheduled via cron
- **Deployment** — systemd service (`fastapi.service`)

## API Reference

#### Get all items

```http
GET /
```

#### Get latest announcements

```http
GET /latest
```

| Parameter    | Type      | Description                                             |
| :----------- | :-------- | :------------------------------------------------------ |
| `department` | `string`  | **Required**. Name of department                        |
| `id`         | `integer` | **Required**. ID of the last announcement you have      |

Returns the announcements newer than `id` for the given department.

#### Get announcements count

```http
GET /count
```

| Parameter    | Type      | Description         |
| :----------- | :-------- | :------------------ |
| `department` | `string`  | Name of department  |

Returns the number of announcements stored for the department.

#### Get announcements by department

```http
GET /{department}
```

| Parameter    | Type      | Description                       |
| :----------- | :-------- | :-------------------------------- |
| `department` | `string`  | **Required**. Name of department  |

Returns all announcements for the selected department.

## Deployment

Provision a server, then:

**1. Install PostgreSQL**

```bash
sudo apt install postgresql postgresql-contrib
sudo -u postgres psql
\password          # set a password
\q
```

Create a database and a table named `deddhe`.

**2. Run the API as a service**

Copy `fastapi.service` to `/etc/systemd/system`, edit `WorkingDirectory`, `User`, and `Group`, then:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now fastapi.service
sudo systemctl status fastapi.service
```

**3. Schedule the scraper** — add the `WebScrapping/` script to a cron job and you're ready to go.

## Author

- [@nicknterm](https://www.github.com/nicknterm)

## License

Released under the [Apache License 2.0](LICENSE).
