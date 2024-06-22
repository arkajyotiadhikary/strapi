#!/bin/bash

# Update and install necessary packages
sudo apt-get update
sudo apt-get install -y git nodejs npm

# Install pm2 globally
sudo npm install -g pm2

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

# Create .env file with the required environment variables
cat <<EOT > .env
HOST=0.0.0.0
PORT=1337
APP_KEYS="toBeModified1,toBeModified2"
API_TOKEN_SALT=tobemodified
ADMIN_JWT_SECRET=tobemodified
TRANSFER_TOKEN_SALT=tobemodified
JWT_SECRET=tobemodified
EOT

npm install

# Build the Strapi project
npm run build

ss list and have it resurrected on reboot
=======
# Start the Strapi project using PM2 with the correct working directory
pm2 start npm --name "strapi" -- run develop --cwd /home/ubuntu/strapi

pm2 save
pm2 startup

# Ensure the pm2 process manager starts on boot
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u ubuntu --hp /home/ubuntu

echo "Setup complete. Strapi should now be running and accessible at http://<your-ec2-instance-public-ip>:1337"
