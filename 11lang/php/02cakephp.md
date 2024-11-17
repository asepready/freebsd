CakePHP : Install
 	
Install CakePHP which is a PHP Web application framework.

[1]	Install PHP Composer and other modules first.
```sh
root@belajarfreebsd:~# pkg install -y php82-composer php82-curl php82-session php82-tokenizer php82-xml php82-xmlwriter php82-dom php82-fileinfo php82-gd php82-pdo php82-simplexml php82-pear-PHP_CodeSniffer
```
[2]	Create a CakePHP test project with a common user.
```sh
freebsd@belajarfreebsd:~$ mkdir test-project2
freebsd@belajarfreebsd:~$ cd test-project2
# create [my-app] CakePHP project
freebsd@belajarfreebsd:~/test-project2$ composer create-project cakephp/app my-app
Creating a "cakephp/app" project at "./my-app"
Installing cakephp/app (5.0.1)
  - Installing cakephp/app (5.0.1): Extracting archive
Created project in /home/sysadmin/test-project2/my-app
Loading composer repositories with package information
Updating dependencies
Lock file operations: 86 installs, 0 updates, 0 removals

.....
.....

Created `config/app_local.php` file
Created `/home/sysadmin/test-project2/my-app/logs` directory
Created `/home/sysadmin/test-project2/my-app/tmp/cache/views` directory
Set Folder Permissions ? (Default to Y) [Y,n]? y
Permissions set on /home/sysadmin/test-project2/my-app/tmp/cache
Permissions set on /home/sysadmin/test-project2/my-app/tmp/cache/models
Permissions set on /home/sysadmin/test-project2/my-app/tmp/cache/persistent
Permissions set on /home/sysadmin/test-project2/my-app/tmp/cache/views
Permissions set on /home/sysadmin/test-project2/my-app/tmp/sessions
Permissions set on /home/sysadmin/test-project2/my-app/tmp/tests
Permissions set on /home/sysadmin/test-project2/my-app/tmp
Permissions set on /home/sysadmin/test-project2/my-app/logs
Updated Security.salt value in config/app_local.php

freebsd@belajarfreebsd:~/test-project2 $ cd my-app
freebsd@belajarfreebsd:~/test-project2/my-app $ ./bin/cake server -H 0.0.0.0 -p 8765

Welcome to CakePHP v5.0.5 Console
-------------------------------------------------------------------------------
App : src
Path: /home/sysadmin/test-project2/my-app/src/
DocumentRoot: /home/sysadmin/test-project2/my-app/webroot
Ini Path:
-------------------------------------------------------------------------------
built-in server is running in http://0.0.0.0:8765/
You can exit with `CTRL-C`
[Tue Jan 30 13:42:46 2024] PHP 8.3.1 Development Server (http://0.0.0.0:8765) started