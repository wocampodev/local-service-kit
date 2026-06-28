# Local Service Kit

Local scripts for starting common local development services quickly. 🚀

## Project Scope

This is an internal toolkit made public as a reference for my coworkers. It reflects the services, defaults, and tradeoffs used by one development team; it is not trying to be a generic container orchestration framework.

## Requirements

- `make`
- `docker`
- `shellcheck`
- `shfmt`

## Quick Start

Run `make help` to list service commands.

Use `make format` and `make check` before committing. Formatting rules live in `.editorconfig`.

## Environment

All service configuration lives in `.local.env`.

Start from the example file:

```sh
cp .local.env.example .local.env
```

Then edit ports, image tags, container names, volumes, and credentials as needed.

💡 Tip: change `CONTAINER_PREFIX` if you run multiple copies of this repo or want your containers to be easy to spot.

## Services

### 🧊 Azurite

Azurite provides local Azure Storage endpoints.

Default ports:

- Blob: `http://localhost:10000`
- Queue: `http://localhost:10001`
- Table: `http://localhost:10002`

For a GUI, use [Microsoft Azure Storage Explorer](https://azure.microsoft.com/en-us/products/storage/storage-explorer/) and connect with the emulator storage account.

![Azure Storage Explorer](/assets/storage-explorer-quickstart.png)

Need HTTPS? Follow the official [Azurite HTTPS setup guide](https://github.com/Azure/Azurite#https-setup).

### 🪐 Cosmos DB Emulator

The Cosmos DB Linux emulator exposes:

- Data Explorer: `http://localhost:1234`
- Health probe: `http://localhost:8080/status`
- Gateway endpoint: `https://localhost:8081`

Open Data Explorer in your browser once the container is ready.

![Cosmos DB Emulator quickstart](/assets/cosmosdb-emulator-quickstart.png)

![Cosmos DB Emulator Data Explorer](/assets/cosmosdb-emulator-data-explorer.png)

Need HTTPS details? Follow the official [Cosmos DB emulator Linux guide](https://learn.microsoft.com/en-us/azure/cosmos-db/emulator-linux#https-mode).

### ☘️ MongoDB

MongoDB starts with the database configured in `MONGODB_DATABASE`. The default is `testdb`.

On first container initialization, Docker runs scripts from:

```text
src/init/mongodb/
```

For management you can use `mongosh`:

```sh
docker exec -it "$MONGODB_CONTAINER" mongosh "mongodb://$MONGODB_USERNAME:$MONGODB_PASSWORD@localhost/$MONGODB_DATABASE" --authenticationDatabase "admin"
```

> Note: init scripts only run when MongoDB initializes a fresh data directory. If you need to re-run them, stop the container and remove the related Docker volumes first.

### 🐘 PostgreSQL

PostgreSQL starts with the database configured in `POSTGRESQL_DATABASE`. The default is `testdb`.

On first container initialization, Docker runs scripts from:

```text
src/init/postgresql/
```

For management you can use `psql`:

```sh
docker exec -it "$POSTGRESQL_CONTAINER" psql -h localhost -U "$POSTGRESQL_USER" -d "$POSTGRESQL_DATABASE"
```

> Note: PostgreSQL init scripts only run with a fresh database volume. If your SQL changes do not appear, check whether the volume already existed.

## Contributing Notes

Contributions are welcome. See [CONTRIBUTING.md](./CONTRIBUTING.md).
