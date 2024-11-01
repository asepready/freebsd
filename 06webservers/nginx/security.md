# Using NGINX and NGINX Plus to Fight DDoS Attacks

NGINX and NGINX Plus have a number of features that – in conjunction with the characteristics of a DDoS attack mentioned above – can make them a valuable part of a DDoS attack mitigation solution. These features address a DDoS attack both by regulating the incoming traffic and by controlling the traffic as it is proxied to backend servers.
## Inherent Protection of the NGINX Event‑Driven Architecture

NGINX is designed to be a “shock absorber” for your site or application. It has a non‑blocking, event‑driven architecture that copes with huge amounts of requests without a noticeable increase in resource utilization.

New requests from the network do not interrupt NGINX from processing ongoing requests, which means that NGINX has capacity available to apply the techniques described below which protect your site or application from attack.

More information about the underlying architecture is available at Inside NGINX: How We Designed for Performance & Scale.
## Limiting the Rate of Requests

You can limit the rate at which NGINX and NGINX Plus accept incoming requests to a value typical for real users. For example, you might decide that a real user accessing a login page can only make a request every 2 seconds. You can configure NGINX and NGINX Plus to allow a single client IP address to attempt to login only every 2 seconds (equivalent to 30 requests per minute):
```sh
limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;

server {
    # ...
    location /login.html {
        limit_req zone=one burst=5; #nodelay;
    # ...
    }
}
```
The limit_req_zone directive configures a shared memory zone called one to store the state of requests for the specified key, in this case the client IP address ($binary_remote_addr). The limit_req directive in the location block for /login.html references the shared memory zone.

For a detailed discussion of rate limiting, see Rate Limiting with NGINX and NGINX Plus on our blog.
## Limiting the Number of Connections

You can limit the number of connections that can be opened by a single client IP address, again to a value appropriate for real users. For example, you can allow each client IP address to open no more than 10 connections to the /store area of your website:
```sh
limit_conn_zone $binary_remote_addr zone=addr:10m;

server {
    # ...
    location /store/ {
        limit_conn addr 10;
        # ...
    }
}
```
The limit_conn_zone directive configures a shared memory zone called addr to store requests for the specified key, in this case (as in the previous example) the client IP address, $binary_remote_addr. The limit_conn directive in the location block for /store references the shared memory zone and sets a maximum of 10 connections from each client IP address.
## Closing Slow Connections

You can close connections that are writing data too infrequently, which can represent an attempt to keep connections open as long as possible (thus reducing the server’s ability to accept new connections). Slowloris is an example of this type of attack. The client_body_timeout directive controls how long NGINX waits between writes of the client body, and the client_header_timeout directive controls how long NGINX waits between writes of client headers. The default for both directives is 60 seconds. This example configures NGINX to wait no more than 5 seconds between writes from the client for either headers or body:
```sh
server {
    client_body_timeout 5s;
    client_header_timeout 5s;
    # ...
}
```
## Denylisting IP Addresses

If you can identify the client IP addresses being used for an attack, you can denylist them with the deny directive so that NGINX and NGINX Plus do not accept their connections or requests. For example, if you have determined that the attacks are coming from the address range 123.123.123.1 through 123.123.123.16:
```sh
location / {
    deny 123.123.123.0/28;
    # ...
}
```
Or if you have determined that an attack is coming from client IP addresses 123.123.123.3, 123.123.123.5, and 123.123.123.7:
```sh
location / {
    deny 123.123.123.3;
    deny 123.123.123.5;
    deny 123.123.123.7;
    # ...
}
```
## Allowlisting IP Addresses

If access to your website or application is allowed only from one or more specific sets or ranges of client IP addresses, you can use the allow and deny directives together to allow only those addresses to access the site or application. For example, you can restrict access to only addresses in a specific local network:
```sh
location / {
    allow 192.168.1.0/24;
    deny all;
    # ...
}
```
Here, the deny all directive blocks all client IP addresses that are not in the range specified by the allow directive.
## Using Caching to Smooth Traffic Spikes

You can configure NGINX and NGINX Plus to absorb much of the traffic spike that results from an attack, by enabling caching and setting certain caching parameters to offload requests from the backend. Some of the helpful settings are:

    The updating parameter to the proxy_cache_use_stale directive tells NGINX that when it needs to fetch an update of a stale cached object, it should send just one request for the update, and continue to serve the stale object to clients who request it during the time it takes to receive the update from the backend server. When repeated requests for a certain file are part of an attack, this dramatically reduces the number of requests to the backend servers.
    The key defined by the proxy_cache_key directive usually consists of embedded variables (the default key, $scheme$proxy_host$request_uri, has three variables). If the value includes the $query_string variable, then an attack that sends random query strings can cause excessive caching. We recommend that you don’t include the $query_string variable in the key unless you have a particular reason to do so.

## Blocking Requests

You can configure NGINX or NGINX Plus to block several kinds of requests:

    Requests to a specific URL that seems to be targeted
    Requests in which the User-Agent header is set to a value that does not correspond to normal client traffic
    Requests in which the Referer header is set to a value that can be associated with an attack
    Requests in which other headers have values that can be associated with an attack

For example, if you determine that a DDoS attack is targeting the URL /foo.php you can block all requests for the page:
```sh
location /foo.php {
    deny all;
}
```
Or if you discover that DDoS attack requests have a User-Agent header value of foo or bar, you can block those requests.
```sh
location / {
    if ($http_user_agent ~* foo|bar) {
        return 403;
    }
    # ...
}
```
The http_name variable references a request header, in the above example the User-Agent header. A similar approach can be used with other headers that have values that can be used to identify an attack.
## Limiting the Connections to Backend Servers

An NGINX or NGINX Plus instance can usually handle many more simultaneous connections than the backend servers it is load balancing. With NGINX Plus, you can limit the number of connections to each backend server. For example, if you want to limit NGINX Plus to establishing no more than 200 connections to each of the two backend servers in the website upstream group:
```sh
upstream website {
    server 192.168.100.1:80 max_conns=200;
    server 192.168.100.2:80 max_conns=200;
    queue 10 timeout=30s;
}
```
The max_conns parameter applied to each server specifies the maximum number of connections that NGINX Plus opens to it. The queue directive limits the number of requests queued when all the servers in the upstream group have reached their connection limit, and the timeout parameter specifies how long to retain a request in the queue.