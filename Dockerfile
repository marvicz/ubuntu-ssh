# 
# Simple Ubuntu SSH docker ready for another application
# 

FROM ubuntu:latest
MAINTAINER Marek Vit <marekvit@gmail.com>


# Initial essentila install and update
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update 
RUN apt-get install apt-utils -y
RUN apt-get upgrade -y

# Few handy utilities
RUN apt-get install nano --no-install-recommends -y

# Set root password: root
# ..password been hash generated using this command: openssl passwd -1 -salt marvis root
RUN sed -ri 's/root\:\*/root\:\$1\$marvis\$665TJ5RnVsp8E.w9H6Lfc\//g' /etc/shadow


# Install Supervisor
RUN apt-get install supervisor -y

# SSH server
RUN apt-get install openssh-server -y
RUN mkdir -p /var/run/sshd

# SSH - Configuration - Allow root login via password
RUN sed -ri 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# SSH start via Supervisor
RUN echo "[program:openssh-server]"  >> /etc/supervisor/conf.d/supervisord-openssh-server.conf
RUN echo "command=/usr/sbin/sshd -D" >> /etc/supervisor/conf.d/supervisord-openssh-server.conf
RUN echo "numprocs=1"                >> /etc/supervisor/conf.d/supervisord-openssh-server.conf
RUN echo "autostart=true"            >> /etc/supervisor/conf.d/supervisord-openssh-server.conf
RUN echo "autorestart=true"          >> /etc/supervisor/conf.d/supervisord-openssh-server.conf


# Copy TOP config file
COPY ini/.toprc /root/


# Clean before end
RUN apt-get autoclean
RUN apt-get autoremove -y

# Expose SSH
EXPOSE 22

# Start script
RUN echo "#!/bin/bash"             >> /startup.sh
RUN echo "/usr/bin/supervisord -n" >> /startup.sh

CMD ["sh", "/startup.sh"]
