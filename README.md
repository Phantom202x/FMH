# Find My Hadji
Use AI face recognition to find my hadji

## backend

To run the backend, checkout the repo and run the following

```bash
docker compose up --build
```

To test the backend, first make sure to start with fresh database tables

```bash
docker compopse down -v
```

Then start the server

```bash
docker compose up --build
```

Finally, you can run backend integration tests

```bash
docker compose run --rm test-server
```

