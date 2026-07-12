.PHONY: dev dev.iex setup stop db

db:
	docker compose up -d db
	@echo "waiting for postgres..."
	@until docker compose exec -T db pg_isready -U postgres >/dev/null 2>&1; do sleep 0.5; done

setup: db
	mix deps.get
	mix ecto.setup

dev: db
	mix phx.server

dev.iex: db
	iex -S mix phx.server

stop:
	docker compose down
