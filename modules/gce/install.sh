#!/usr/bin/env bash
apt-get update
apt-get install openjdk-11-jdk tomcat9 tomcat9-admin mysql-server -y

wget https://downloads.cloudbees.com/cloudbees-cd/preview_release/2020.10.0.144378/linux/CloudBeesFlowAgent-x64-2020.10.0.144378 -O cd-agent-installer
chmod +x ./cd-agent-installer

./cd-agent-installer \
--mode silent \
--installAgent \
--unixAgentUser root \
--unixAgentGroup root
