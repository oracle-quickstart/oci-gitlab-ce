#!/bin/bash

sed -i -r -e 's/\s+no$/ yes/g' /etc/yum/yum-cron*.conf
sed -i -r -e '/^autoinstall/s/no/yes/' /etc/uptrack/uptrack.conf

systemctl enable --now dbus.service
systemctl enable --now docker.service
systemctl enable --now firewalld.service
systemctl enable --now yum-cron.service

uptrack-upgrade -y --all

for service in http https
do
  # XXX Prevent terraform from prasing service variable by not using curly brace
  firewall-offline-cmd --zone=public --add-service=$service
done

for port in ${GITLAB_SSH_PORT}
do
  firewall-offline-cmd --zone=public --add-port=$port/tcp
done

systemctl restart firewalld.service

chmod +x /etc/cron.daily/docker-compose-pull

/etc/cron.daily/docker-compose-pull

