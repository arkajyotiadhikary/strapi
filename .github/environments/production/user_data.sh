#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status.

# Update the package lists and install required packages
sudo apt-get update
sudo apt-get install -y git nodejs npm build-essential libsqlite3-dev

# Install PM2 and Strapi globally
sudo npm install -g pm2 strapi@latest

# Navigate to the home directory
cd /home/ubuntu

# Configure Git
git config --global user.name "arkajyotiadhikary"
git config --global user.email "arkajyotiadhikary15@gmail.com"

# Clone the Strapi project repository and change to the project directory
git clone https://github.com/PearlThoughts-DevOps-Internship/strapi.git
cd strapi

# Check out the correct branch
git checkout arka-prod

# Set permissions for the project directory
sudo chown -R ubuntu:ubuntu /home/ubuntu/strapi
sudo chmod -R 755 /home/ubuntu/strapi

# Clean the node_modules directory and package-lock.json file, then reinstall dependencies
sudo rm -rf node_modules package-lock.json
npm install

# Build the Strapi project
npm run build

# Start the Strapi project using PM2 with the correct working directory
pm2 start npm --name "strapi" -- run develop --cwd /home/ubuntu/strapi
pm2 save
