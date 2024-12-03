```sh
# create Container quick
bastille create www 13.4-RELEASE 10.0.0.254/24

# template 
bastille bootstrap https://gitlab.com/bastillebsd-templates/apache
bastille template www bastillebsd-templates/apache

# Show Container Running
bastille list

# Install packages inside the container.
bastille pkg www install -y htop

# htop is an interactive process viewer inside conatiner
bastille htop www

# Let’s toggle a setting inside the container and enable the sshd service.
bastille sysrc www sshd_enable=YES

# Start up the newly enabled service.
bastille service www sshd start

# Execute arbitrary commands inside the container
bastille cmd www sockstat -4

# use console for a password-less root login
bastille console www

# When you’re done testing your container you can shut it of
bastille stop www

# destroy your lightweight container
bastille destroy www
```