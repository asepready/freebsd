1. MySql57 on Start up(aktifkan ketika memulai boot)
```sh
sysrc mysql_enable="YES"
```
atau buka /etc/rc.conf dan edit:
```sh
edit /etc/rc.conf
```
```sh
#MariaDB
mysql_enable="YES"
```
2. Salin file my-small.cnf di /usr/local/share/mysql/my-small.cnf menjadi salinan my.cnf
```sh
cp /usr/local/etc/my.cnf{.sample}
```
3. Menjalankan MySql57 Service & Status
```sh
service mysql-server start
sockstat -4 -l
```
4. Pertama kali untuk buat root password MySql57
```sh
mysql_secure_installation
```
dialog
  ```
    mysql_secure_installation: [ERROR] unknown variable 'prompt=\u@\h [\d]>\_'

    Securing the MySQL server deployment.

    Connecting to MySQL server using password in '/root/.mysql_secret'

    VALIDATE PASSWORD PLUGIN can be used to test passwords
    and improve security. It checks the strength of password
    and allows the users to set only those passwords which are
    secure enough. Would you like to setup VALIDATE PASSWORD plugin?

    Press y|Y for Yes, any other key for No: y

    There are three levels of password validation policy:

    LOW    Length >= 8
    MEDIUM Length >= 8, numeric, mixed case, and special characters
    STRONG Length >= 8, numeric, mixed case, special characters and dictionary                  file

    Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG: 0
    Using existing password for root.

    Estimated strength of the password: 100
    Change the password for root ? ((Press y|Y for Yes, any other key for No) : y

    New password:

    Re-enter new password:

    Estimated strength of the password: 50
    Do you wish to continue with the password provided?(Press y|Y for Yes, any other key for No) : y
    By default, a MySQL installation has an anonymous user,
    allowing anyone to log into MySQL without having to have
    a user account created for them. This is intended only for
    testing, and to make the installation go a bit smoother.
    You should remove them before moving into a production
    environment.

    Remove anonymous users? (Press y|Y for Yes, any other key for No) : y
    Success.

    Normally, root should only be allowed to connect from
    'localhost'. This ensures that someone cannot guess at
    the root password from the network.

    Disallow root login remotely? (Press y|Y for Yes, any other key for No) : y
    Success.

    By default, MySQL comes with a database named 'test' that
    anyone can access. This is also intended only for testing,
    and should be removed before moving into a production
    environment.

    Remove test database and access to it? (Press y|Y for Yes, any other key for No) : y
     - Dropping test database...
    Success.

     - Removing privileges on test database...
    Success.

    Reloading the privilege tables will ensure that all changes
    made so far will take effect immediately.

    Reload privilege tables now? (Press y|Y for Yes, any other key for No) : y
    Success.

    All done!
  ```
6. Pertama kali untuk masuk ke sistem MySql57
```sh
mysql -u root -p
#merubah password sebelum menambah users
SET PASSWORD = PASSWORD();
```
