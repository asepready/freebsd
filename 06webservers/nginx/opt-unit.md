# Nginx Unit

```sh
# Add & Install Packages
sudo pkg install unit libunit

# Enable Service
sudo service unitd enable
sudo service unitd start

# Module Unit support lang
sudo pkg install \
  #unit-java8      #        Java module for NGINX Unit
  #unit-otel       #        OTel static library for Unit
  #unit-perl5.36   #        Perl module for NGINX Unit
  #unit-php81      #        PHP module for NGINX Unit
  #unit-php82      #        PHP module for NGINX Unit
  #unit-php83      #        PHP module for NGINX Unit
  unit-php84      #        PHP module for NGINX Unit
  #unit-python311  #        Python module for NGINX Unit
  #unit-ruby3.2    #        Ruby module for NGINX Unit

# Test
sudo curl --unix-socket /var/run/unit/control.unit.sock localhost
sudo curl --unix-socket /var/run/unit/control.unit.sock localhost/config
```

## Setup App PHP

```sh
# Buat folder
sudo mkdir -p /usr/local/www

# Set folder permission menjadi 775
sudo chmod  -R 775 /usr/local/www

# Set folder owner supaya group unit bisa mengakses folder
sudo chown -R www:www /usr/local/www

cd /usr/local/www

# Install aplikasi CodeIgniter 4
composer create-project laravel/laravel webapp

# Pastikan folder dan files project dapat diakses oleh unit
sudo chmod -R 775 webapp
sudo chown -R :www webapp
```

## Config Nginx Unit

```sh
#/usr/local/www/unit.config.json
{
    "listeners": {
        "*:80": {
            "pass": "routes"
        }
    },

    "routes": [
        {
            "match": {
                "host": "localhost",
                "uri": "!/index.php"
            },
            "action": {
                "share": "/usr/local/www/webapp/public$uri",
                "fallback": {
                    "pass": "applications/webapp"
                }
            }
        }
    ],

    "applications": {
        "webapp": {
            "type": "php",
            "root": "/usr/local/www/webapp/public/",
            "script": "index.php"
        }
    }
}
```

## Save

```sh
sudo curl -X PUT --data-binary @unit.config.json --unix-socket /var/run/unit/control.unit.sock localhost/config
```

## SSL

```sh
#/etc/hosts
::1		localhost localhost.pi
127.0.0.1	localhost localhost.pi
127.0.0.1	board.pi board

# stop service for 80
sudo service unitd stop

# Generate certificate
sudo pkg install py311-certbot
sudo certbot certonly --standalone -d board.pi

# Nyalakan kembali service unit

weekly_certbot_enable="YES"
sudo systemctl start unit
```
