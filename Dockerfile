FROM debian:latest

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server sudo
ADD run.sh /run.sh
RUN chmod +x /*.sh
RUN mkdir -p /var/run/sshd \
  && touch /root/.Xauthority \
  && true

RUN useradd remote -s /bin/bash \
  && mkdir /home/remote \
  && chown remote:remote /home/remote \
  && true

ADD sshd_config /etc/ssh/sshd_config

EXPOSE 22
CMD ["/run.sh"]
