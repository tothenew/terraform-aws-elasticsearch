#!/bin/bash

wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.7-x86_64.rpm
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.7-x86_64.rpm.sha512
shasum -a 512 -c elasticsearch-7.17.7-x86_64.rpm.sha512
sudo rpm --install elasticsearch-7.17.7-x86_64.rpm

sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service