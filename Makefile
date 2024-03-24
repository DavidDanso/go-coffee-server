include .env

stop_containers:
	@echo "Stopping other docker container"
	@if [ $$(docker ps -q) ]; then \
		echo "found and stopped containers"; \
		docker stop $$(docker ps -q); \
	else \
		echo "no container running..."; \
	fi


create_container:
	@echo "Creating Docker container $(CONTAINER_NAME)"
	docker run -d --name $(CONTAINER_NAME) -p 5432:5432 -e POSTGRES_USER=$(USER) -e POSTGRES_PASSWORD=$(PASSWORD) postgres:12-alpine


create_db:
	@echo "Creating database"	
	@sleep 5
	docker exec -it ${CONTAINER_NAME} createdb --username=$(USER) --owner=$(USER) $(DB_NAME)


start_container:
	@echo "Starting Docker container $(CONTAINER_NAME)"
	docker start $(CONTAINER_NAME)


create_migrations:
	@echo "Creating migrations"
	sqlx migrate add -r init


migrate_up:
	sqlx migrate run --database-url "postgres://${USER}:${PASSWORD}@${HOST}:${DB_PORT}/${DB_NAME}?sslmode=disable"


migrate_down:
	sqlx migrate revert --database-url "postgres://${USER}:${PASSWORD}@${HOST}:${DB_PORT}/${DB_NAME}?sslmode=disable"