sudo apt update -y
sudo apt install -y nginx

sudo systemctl enable nginx
sudo systemctl start nginx

echo "Nginx Server" | sudo tee /var/www/html/index.html