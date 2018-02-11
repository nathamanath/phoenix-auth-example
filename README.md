# Auth

Demo setup of username / password authentication and JWT based sessions in
Phoenix framework.

## Building

Install elixir

```sh
  make
  docker-compose up
  docker exec -i auth_postgres_1 psql -U auth -d auth_prod < dump.sql # sub in actual container name
```
