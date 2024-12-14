FROM ubuntu:kinetic

RUN apt update && apt upgrade -y

COPY . /etc
COPY ./motd /etc

RUN apt autoremove -y
WORKDIR /root

RUN apt install python3 neofetch nano iproute2 curl wget git make systemd -y
RUN apt install openssh-server -y

RUN curl -o /bin/systemctl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py
RUN chmod 775 /bin/systemctl

RUN sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

RUN echo 'root:123456' | chpasswd
RUN systemctl start sshd
CMD [ "/usr/sbin/sshd" , "-D" ]
