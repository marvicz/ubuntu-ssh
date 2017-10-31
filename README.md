# Ubuntu SSH

Clear Ubuntu 16.04 with OpenSSH service run on Supervisor. Ready for another experiments.

SSH    - root/root

Exposed ports: 22

Build docker image: docker build -t marvicz/ubuntu-ssh .

Example to start: docker run -d --name test -p 26:22 -v /home/user/:/home/docker/ marvicz/ubuntu-ssh

Get into docker container: ssh -p 26 root@localhost
