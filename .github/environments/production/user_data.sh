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

# Clone and setup the Strapi project
git clone https://github.com/PearlThoughts-DevOps-Internship/strapi.git
cd strapi
git checkout arka-prod

# Ensure the correct permissions for the Git repository
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

# Install dependencies and build the project
npm install
npm run build

# Start the Strapi application with pm2
pm2 start npm --name "strapi" -- run start

# Save the pm2 process list and have it resurrected on reboot
pm2 save
pm2 startup

# Ensure the pm2 process manager starts on boot
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u ubuntu --hp /home/ubuntu

echo "Setup complete. Strapi should now be running and accessible at http://<your-ec2-instance-public-ip>:1337"
