.PHONY: build

build:
	mkdir -p shared
	docker build -t kali .

run:
	docker run -it -d --net host --name kali -e DISPLAY=${DISPLAY} -v $(pwd)/shared:/shared -p 31337:22 kali # --rm

shell:
	docker exec -it kali /bin/bash

status:
	docker ps -a

start:
	docker start kali

stop:
	docker stop kali

remove:
	docker rm kali

clean: stop remove

full: build run shell
