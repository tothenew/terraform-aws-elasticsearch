#!/bin/bash

# Elasticsearch version
version=8.10.0

# Node Exporter version
node_exporter_version=1.6.1

# Elasticsearch Exporter version
elasticsearch_exporter_version=1.6.0

# Install Elasticsearch
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-"$version"-linux-aarch64.tar.gz
tar -zxvf elasticsearch-"$version"-linux-aarch64.tar.gz
sudo mv elasticsearch-"$version" /usr/share/elasticsearch
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install repository-s3 --batch

# Configure Elasticsearch
cat <<EOL | sudo tee /etc/elasticsearch/elasticsearch.yml
transport.host: localhost
transport.tcp.port: 9300
http.port: 9200
network.host: 0.0.0.0
xpack.security.enabled: false
xpack.security.transport.ssl.enabled: false
EOL

# Start Elasticsearch
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service

# Install Node Exporter
wget https://github.com/prometheus/node_exporter/releases/download/v"$node_exporter_version"/node_exporter-"$node_exporter_version".darwin-amd64.tar.gz
tar -zxvf node_exporter-"$node_exporter_version".darwin-amd64.tar.gz
sudo mv node_exporter-"$node_exporter_version".darwin-amd64/node_exporter /usr/local/bin/
sudo useradd -rs /bin/false node_exporter

# Create a systemd service for Node Exporter
cat <<EOL | sudo tee /etc/systemd/system/node_exporter.service
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
EOL

# Start Node Exporter
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# Install Elasticsearch Exporter
wget https://github.com/prometheus-community/elasticsearch_exporter/releases/download/v"$elasticsearch_exporter_version"/elasticsearch_exporter-"$elasticsearch_exporter_version".darwin-arm64.tar.gz
tar -zxvf elasticsearch_exporter-"$elasticsearch_exporter_version".darwin-arm64.tar.gz
sudo mv elasticsearch_exporter-"$elasticsearch_exporter_version".darwin-arm64/elasticsearch_exporter /usr/local/bin/

# Create a systemd service for Elasticsearch Exporter
cat <<EOL | sudo tee /etc/systemd/system/elasticsearch_exporter.service
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
EOL

# Start Elasticsearch Exporter
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch_exporter.service
sudo systemctl start elasticsearch_exporter.service

# Enable Elasticsearch Exporter to start on system boot
sudo systemctl enable elasticsearch_exporter.service

# Restart Elasticsearch
sudo systemctl restart elasticsearch
