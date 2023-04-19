SHELL := /bin/bash

.PHONY: start stop log showq retryq tests
start:
	docker-compose up -d
	symfony server:start -d
	symfony open:local
	# worker for async
	symfony run -d --watch=config,src,templates,vendor symfony console messenger:consume async -vv

stop:
	docker-compose down
	symfony server:stop

log:
	symfony server:log

showq:
	symfony console messenger:failed:show

retryq:
	symfony console messenger:failed:retry

tests:
	symfony console doctrine:database:drop --force --env=test || true
	symfony console doctrine:database:create --env=test
	symfony console doctrine:migrations:migrate -n --env=test
	symfony console doctrine:fixtures:load -n --env=test
	symfony php bin/phpunit $@

mailcatch:
	symfony open:local:webmail
