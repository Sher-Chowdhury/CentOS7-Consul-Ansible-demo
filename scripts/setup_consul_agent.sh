#!/usr/bin/env bash
set -ex

echo '##########################################################################'
echo '############## About to run setup_consul_agent.sh script #################'
echo '##########################################################################'


# Install consul
ConsulVersion=1.0.7
ConsulDownloadLink=https://releases.hashicorp.com/consul/${ConsulVersion}/consul_${ConsulVersion}_linux_amd64.zip

echo "INFO: Downloading Consul"
curl --location --verbose $ConsulDownloadLink -o /tmp/consul.zip

echo "INFO: Installing Consul"
unzip /tmp/consul.zip -d /usr/local/bin
chmod +x /usr/local/bin/consul


# creating the consul service account which will run the consul daemon
useradd consul --system --shell /bin/bash


# Creating the folder that will house all the consul configurations. 
mkdir /etc/consul
chown --recursive consul /etc/consul



# need to populate this file. 
touch /etc/consul/consul.d/config.json
chmod 400 /etc/consul/consul.d/config.json

# Need to use the following"
# https://medium.com/@wenhuanglin/tutorial-on-running-nomad-and-consul-as-a-systemd-daemon-service-part-2-d1b999c73bdd 
cp /vagrant/files/initd-consul /etc/init.d/consul
chmod 0555 /etc/init.d/consul


# need to uncomment this once config.json is in place
#systemctl enable consul
#systemctl start consul

# the consul deamon requires the following folder to exist before it can start.
mkdir /opt/consul
chown consul /opt/consul



cp /vagrant/files/logrotate/consul-agent /etc/logrotate.d/consul-agent
chmod 0644 /etc/logrotate.d/consul-agent


exit 0