#!/bin/bash
sudo apt-get update
sudo apt-get install -y git nodejs npm
sudo npm install -g pm2
cd /home/ubuntu

# Configure Git
git config --global user.name "arkajyotiadhikary"
git config --global user.email "arkajyotiadhikary15@gmail.com"

# Clone and setup the Strapi project using GitHub PAT
GITHUB_PAT="${PAT}"
git clone https://$GITHUB_PAT@github.com/PearlThoughts-DevOps-Internship/strapi.git
cd strapi
git checkout arka-prod

# Ensure the correct permissions for the Git repository
sudo chown -R ubuntu:ubuntu /home/ubuntu/strapi
sudo chmod -R 755 /home/ubuntu/strapi

npm install
npm run build
pm2 start npm --name "strapi" -- run start
pm2 save
