#!/bin/bash

# Define variables
LARAVEL_DIR="/var/www/html/laravel"
LARAVEL_CONF="/etc/apache2/sites-available/laravel.conf"
VIRTUAL_HOST="192.168.50.11"

# Update all package index and upgrade packages
sudo apt update
sudo apt upgrade -y
echo "Upgrade completed"

# Update the PHP repository
sudo add-apt-repository -y ppa:ondrej/php
echo "PHP repo updated"

# Install Apache
sudo apt install -y apache2
sudo systemctl enable apache2
echo "Apache installation complete"

# Install MySQL
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password'
sudo apt install -y mysql-server
echo "MySQL installation complete"

# Install PHP 8.2 and 8.3 with necessary extensions
sudo apt install -y php libapache2-mod-php php-mysql php8.2 php8.2-curl php8.2-dom php8.2-xml php8.2-mysql php8.2-sqlite3 php8.3 php8.3-curl php8.3-dom php8.3-xml php8.3-mysql php8.3-sqlite3
echo "PHP 8.2 and 8.3 installed"

# Run MySQL secure installation
expect <<EOF
spawn sudo mysql_secure_installation
expect "Would you like to setup VALIDATE PASSWORD component?"
send "y\r"
expect {
    "Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG" {
        send "1\r"
        exp_continue
    }
    "Remove anonymous users?" {
        send "y\r"
        exp_continue
    }
    "Disallow root login remotely?" {
            send "n\r"
        exp_continue
    }
    "Remove test database and access to it?" {
        send "y\r"
        exp_continue
    }
    "Reload privilege tables now?" {
        send "y\r"
        exp_continue
    }
}
EOF
echo "MySQL secure installation completed"

# Restart Apache
sudo systemctl restart apache2
echo "Apache restarted"

# Install Git
sudo apt install -y git
echo "Git installed"

# Clone Laravel repository
sudo git clone https://github.com/laravel/laravel $LARAVEL_DIR
echo "Laravel repository cloned"

# Change directory to Laravel folder
cd $LARAVEL_DIR
echo "Changed directory to $LARAVEL_DIR"

# Install Composer
sudo apt install -y composer
echo "Composer installation completed"

# Upgrade Composer to version 2
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php composer-setup.php --install-dir /usr/bin --filename composer
echo "Composer upgraded to version 2"

# Use Composer to install dependencies
yes | sudo composer install
echo "Composer dependencies installation complete"
# Copy Laravel configuration file and set permissions
sudo cp .env.example .env
sudo chown www-data:www-data .env
sudo chmod 640 .env
echo "Laravel configuration file copied and permissions set"

# Create virtual host in /etc/apache2/sites-available
sudo tee $LARAVEL_CONF >/dev/null <<EOF
<VirtualHost *:80>
    ServerName $VIRTUAL_HOST
    ServerAlias *
    DocumentRoot $LARAVEL_DIR/public

    <Directory $LARAVEL_DIR>
        AllowOverride All
    </Directory>
</VirtualHost>
EOF
echo "Created virtual host in /etc/apache2"

# Generate application key
sudo php artisan key:generate
echo "Application Key generated"

# Run migrations
sudo php artisan migrate --force
echo "Migration complete"

# Change ownership permissions
sudo chown -R www-data:www-data $LARAVEL_DIR/database/ $LARAVEL_DIR/storage/logs/ $LARAVEL_DIR/storage $LARAVEL_DIR/bootstrap/cache
echo "Ownership changed"

# Set file permissions
sudo chmod -R 775 $LARAVEL_DIR/database/ $LARAVEL_DIR/storage/logs/ $LARAVEL_DIR/storage
echo "File permissions set"

# Disable default configuration file
sudo a2dissite 000-default.conf
echo "Default configuration file disabled"

# Enable Laravel configuration file
sudo a2ensite laravel.conf
echo "Laravel configuration file enabled"

# Restart Apache
sudo systemctl restart apache2
echo "Apache restarted"


uptime > /var/log/uptime.log


