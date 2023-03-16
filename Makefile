.PHONY: build

full: build run connect

build:
	cp ~/.ssh/id_rsa.pub .
	mkdir -p shared
	docker build -t kali .

debug:
	docker exec -it kali /bin/bash

run:
	# docker run -d -p 31337:22 --name kali -it kali # --rm
	docker run -it -d --name kali -e DISPLAY=$DISPLAY -v $(pwd)/shared:/shared -p 31337:22 kali # --rm

start:
	docker start kali

stop:
	docker stop kali

remove:
	docker rm kali

clean: stop remove

connect:
	ssh -p 31337 -o StrictHostKeyChecking=no -o "UserKnownHostsFile /dev/null" -o ForwardX11=yes -o ForwardX11Trusted=yes -X user@localhost
