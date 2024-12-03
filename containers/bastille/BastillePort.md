# Bastille Port Redirection and Persistence
## Redirect TCP and UDP ports from host to container
### Port Redirection Requirements
Port redirection is required for inbound connectivity to loopback (bastille0) containers or shared interface containers and is handled using a combination of three things.

1. pf.conf configured with the line: rdr-anchor "rdr/*".
2. ext_if= is defined in pf.conf
3. bastille0 interface or shared external interface (em0, vtnet0, etc) used by container.

If you need help with these please see our Getting Started Guide or Bastille Networking documentation.
    Note: Port redirection is not needed to access VNET-based containers.

### Redirecting Ports
Redirecting ports for inbound access to a containerized service can be done manually using the `rdr` sub-command or in an automated fashion using a Bastille template.

The three examples below will demonstrate redirecting the following:
1. redirect port 2200 (host) to port 22 (container) to access ssh (-p 2200)
2. redirect port 53 (host) to port 53 (container) to access dns
3. redirect port 443 (host) to port 443 (container) to access https
Command Line Usage
```sh
bastille rdr TARGET tcp 2200 22 
bastille rdr TARGET udp 53 53
bastille rdr TARGET tcp 443 443 
```
Bastille Template Usage
```sh
RDR tcp 2200 22
RDR udp 53 53
RDR tcp 443 443
```
### Listing Redirects
Additionally it is possible to list existing rules for a container:
```sh
bastille rdr TARGET list
```

### Clearing Redirects
You may also need to clear redirect rules to remove access:
```sh
bastille rdr TARGET clear
```

### Persistence
Redirection rules are persistent by default. This means that any redirect rules applied to a target will be written to an rdr.conf for that target automatically.

Example: /usr/local/bastille/jails/folsom/rdr.conf
```sh
tcp 2200 22
udp 53 53
tcp 443 443
```

The rules found in this file (one per line) will be loaded for the container each time it is started. Redirection rules are also automatically cleared when the container is stopped.

Tip: Use bastille edit TARGET rdr.conf to interactively edit (or manually create) persistent redirection rules.