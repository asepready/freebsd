Laravel : Install
 	
Install Laravel which is a PHP Web application framework.

[1]	Install PHP Composer and other modules first.
```sh
root@belajarfreebsd:~# pkg install -y php82-composer php82-curl php82-session php82-tokenizer php82-xml php82-xmlwriter php82-dom php82-fileinfo php82-gd
```
[2]	Create a Laravel test project with a common user.
```sh
sysadmin@belajarfreebsd:~$ mkdir test-project
sysadmin@belajarfreebsd:~$ cd test-project
# create [my-app] Laravel project
sysadmin@belajarfreebsd:~/test-project $ composer create-project laravel/laravel my-app
Creating a "laravel/laravel" project at "./my-app"
Installing laravel/laravel (v10.3.2)
  - Installing laravel/laravel (v10.3.2): Extracting archive
Created project in /home/sysadmin/test-project/my-app
> @php -r "file_exists('.env') || copy('.env.example', '.env');"
Loading composer repositories with package information
Updating dependencies
Lock file operations: 111 installs, 0 updates, 0 removals

.....
.....

83 packages you are using are looking for funding.
Use the `composer fund` command to find out more!
> @php artisan vendor:publish --tag=laravel-assets --ansi --force

   INFO  No publishable resources for tag [laravel-assets].

No security vulnerability advisories found.
> @php artisan key:generate --ansi

   INFO  Application key set successfully.

sysadmin@belajarfreebsd:~/test-project$ cd my-app
sysadmin@belajarfreebsd:~/test-project/my-app$ php artisan serve --host 0.0.0.0 --port=8000

   INFO  Server running on [http://0.0.0.0:8000].

  Press Ctrl+C to stop the server
```
 	Access to the URL you set from any client computer, and then that's OK if following site is shown.

[3]	Create a sample Hello World app.
```sh
sysadmin@belajarfreebsd:~$ cd ~/test-project/my-app
# create [HelloWorldController] controller
sysadmin@belajarfreebsd:~/test-project/my-app$ php artisan make:controller HelloWorldController
INFO Controller [app/Http/Controllers/HelloWorldController.php] created successfully.
sysadmin@belajarfreebsd:~/test-project/my-app$ vi routes/web.php
# add to last line
Route::get('helloworld', 'App\Http\Controllers\HelloWorldController@index');
sysadmin@belajarfreebsd:~/test-project/my-app$ vi app/Http/Controllers/HelloWorldController.php
# add function
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class HelloWorldController extends Controller
{
    public function index()
    {
        return view('helloworld');
    }
}

sysadmin@belajarfreebsd:~/test-project/my-app$ vi resources/views/helloworld.blade.php
# create index
<!DOCTYPE html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Hello World</title>
</head>
<body>
<div style="width: 100%; font-size: 40px; font-weight: bold; text-align: center;">
Hello Laravel World!
</div>
</body>
</html>

sysadmin@belajarfreebsd:~/test-project/my-app$ php artisan serve --host 0.0.0.0 --port=8000
```