SHELL := /bin/bash

start:
	docker-compose up -d
	symfony server:start -d
	symfony open:local

stop:
	docker-compose down
	symfony server:stop

tests:
	symfony console doctrine:database:drop --force --env=test || true
	symfony console doctrine:database:create --env=test
	symfony console doctrine:migrations:migrate -n --env=test
	symfony console doctrine:fixtures:load -n --env=test
	symfony php bin/phpunit $@
.PHONY: tests