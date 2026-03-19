sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd

echo "Apache Server" | sudo tee /var/www/html/index.html