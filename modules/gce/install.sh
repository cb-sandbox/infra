#!/usr/bin/env bash
apt-get update
apt-get install openjdk-11-jdk tomcat9 tomcat9-admin mysql-server -y

wget https://downloads.cloudbees.com/cloudbees-cd/Release_2023.10/2023.10.0.169425/linux/CloudBeesFlowAgent-x64-2023.10.0.169425 -O cd-agent-installer
chmod +x ./cd-agent-installer

./cd-agent-installer \
--mode silent \
--installAgent \
--unixAgentUser root \
--unixAgentGroup root
