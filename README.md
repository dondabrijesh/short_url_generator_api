# URL Shortener API (Rails + PostgreSQL)

A production‑ready Rails API for shortening URLs, managing their lifecycle, tracking clicks, and serving timezone‑aware analytics.

## ✨ Highlights

- Shorten URLs – create short codes with unique constraint, no duplicate active URLs.
- Batch support – shorten multiple URLs in a single request.
- Redirect + Click tracking – logs IP, user agent, referer.
- Analytics – total and date‑range click counts with timezone‑aware filtering, supporting both IANA identifiers (e.g., Europe/Paris) and ISO 8601 offsets (+05:30, -08:00, Z).
- Deactivation – deactivate existing short URLs; allows re‑shortening the same original URL.
- Consistent JSON responses and proper HTTP status codes.

## Setup Instructions

### Requirements

* Ruby 3+
* Rails 7+
* PostgreSQL

### Setup

```bash
# Clone repository
git clone https://github.com/dondabrijesh/short_url_generator_api.git
cd url_shortener_api

# Install dependencies
bundle install

# Create and migrate DB
bin/rails db:create db:migrate

# run the server
bin/rails s

```
## EndPoints
### 1. Create Short URLs
```POST /api/v1/short_url ``` 

```bash
curl --location 'localhost:3000/api/v1/short_url' \
--header 'Content-Type: application/json' \
--data '{
    "urls":["https://www.google.com/"] //Mandatory
    
}'
```

### 2. Deactivate URL
```PATCH /api/v1/short_url/:code ```

```bash
curl --location --request PATCH 'localhost:3000/api/v1/short_url/L0ZXn0l' \
--data ''
```


### 3. Analytics
```PATCH /api/v1/short_url/analytics ```

```bash
curl --location --request GET 'localhost:3000/api/v1/short_url/analytics' \
--header 'Content-Type: application/json' \
--data '{
    "start_date": "04-11-2025", //Not Mandatory
    "end_date": "05-11-2025", //Not Mandatory
    "timezoe": "Europe/Paris" //Not Mandatory
}'
```


### 4. Redirect to Original URL
```GET /:code ```

```bash
curl -i http://localhost:3000/Ab12Cd3
```