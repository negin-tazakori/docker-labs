# ELK stack on Docker
Run the ELK (Elasticsearch, logstash, kibana) with with Docker compose.

- Each service runs in its own container with its own volume, so data survives container removal.(Each volume is mounted on the data path of its service.)
- All three containers share a dedicated network (`elk-net`).
- After startup you can log in to the Kibana dashboard.


| Service | Role | Port | Volume
| --- | --- | --- | --- |
| Elasticsearch | Stores and indexes logs | internal to `elk-net` | `es-data` |
| kibana | Wen UI | 5601 | `kibana-data` | 
| Logstash | Receives and processes logs | 5000-5044 | `logstash-data` |


## Setup
### 1. Load variables into your shell
```bash
set -a; source .env; set +a
```

### 2. Start Elasticsearch
```bash
docker compose up -d elasticsearch
docker compose ps
```

### 3. Set the `kibana_system` password
`kibana_system` is the internal service account Kibana uses to talk to Elasticsearch. Its password cannot be set through an environment variable:
```bash
docker exec elasticsearch curl -s -u elastic:$ELASTIC_PASSWORD \
  -X POST http://localhost:9200/_security/user/kibana_system/_password \
  -H 'Content-Type: application/json' \
  -d "{\"password\":\"$KIBANA_PASSWORD\"}"
```
Successful output: `{}`

### 4. Start the remaining services
```bash
docker compose up -d
```

## Test
### 1. Login to Kibana
Open `http://<HOST-IP>:5601` and log in as `elastic` with the value of `ELASTIC_PASSWORD`.
> The `kibana_system` user is only for Kibana's own connection to Elasticsearch. It is not meant for logging in to the UI.

### 2. Send a test log
```bash
echo "test log from elk" | nc localhost 5000
```

### 3. Create a Data View and view the log
1. Menu → Stack Management → Data Views → Create data view
2. Name: test-logs | Index pattern: logs-* | Timestamp field: @timestamp
3. Save data view to Kibana
4. Menu → Discover, and set the time range to Last 24 hours. 

## Verify volume persistence
```bash
docker compose down
docker volume ls
docker compose up -d
```
