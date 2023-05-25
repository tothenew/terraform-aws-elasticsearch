#!/bin/bash

version=7.17.8
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-"$version"-x86_64.rpm
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-"$version"-x86_64.rpm.sha512
shasum -a 512 -c elasticsearch-"$version"-x86_64.rpm.sha512
sudo rpm --install elasticsearch-"$version"-x86_64.rpm

sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service

echo "transport.host: localhost" >> /etc/elasticsearch/elasticsearch.yml
echo "transport.tcp.port: 9300" >> /etc/elasticsearch/elasticsearch.yml
echo "http.port: 9200"  >> /etc/elasticsearch/elasticsearch.yml
echo "network.host: 0.0.0.0"  >> /etc/elasticsearch/elasticsearch.yml
echo "xpack.security.enabled: false"  >> /etc/elasticsearch/elasticsearch.yml
echo "xpack.security.transport.ssl.enabled: false"  >> /etc/elasticsearch/elasticsearch.yml

sudo systemctl restart elasticsearch.service

wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
tar xvfz node_exporter-1.5.0.linux-amd64.tar.gz

# Move Node Exporter binaries
sudo mv node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin/

# Create a system user for Node Exporter
sudo useradd -rs /bin/false node_exporter

# Create a systemd service file for Node Exporter
sudo tee /etc/systemd/system/node_exporter.service << EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
EOF

# Set ownership and permissions
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
sudo chmod +x /usr/local/bin/node_exporter

# Reload systemd and start Node Exporter
sudo systemctl daemon-reload
sudo systemctl start node_exporter

# Enable Node Exporter to start on system boot
sudo systemctl enable node_exporter
sudo systemctl status node_exporter

wget https://github.com/justwatchcom/elasticsearch_exporter/releases/download/v1.1.0rc1/elasticsearch_exporter-1.1.0rc1.linux-amd64.tar.gz
tar -xvf elasticsearch_exporter-1.1.0rc1.linux-amd64.tar.gz
cd elasticsearch_exporter-1.1.0rc1.linux-amd64/
sudo cp elasticsearch_exporter /usr/local/bin/

# Create a systemd service file for the exporter
cat << EOF | sudo tee /etc/systemd/system/elasticsearch_exporter.service
[Unit]
Description=ElasticSearch exporter
Wants=network-online.target
After=network-online.target

[Service]
User=root
Group=root
ExecStart=/usr/local/bin/elasticsearch_exporter

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start the exporter
sudo systemctl daemon-reload
sudo systemctl start elasticsearch_exporter
sudo systemctl enable elasticsearch_exporter

cd /usr/share/elasticsearch/
sudo bin/elasticsearch-plugin install repository-s3 --batch
sudo systemctl restart elasticsearch


