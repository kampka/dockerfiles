Redis Docker image
==================

A Redis image build from source on top of an archlinux base image.

Usage
-----

Data is stored in `/data`.  
Redis data is stored in `/data/storage` while log files are kept int `/data/log`.  
A config file placed in `/data/redis.conf` can be used to specify additional configuration directives.  

Example
-------

`docker run -d -v /data/redis:/data -p 6789:6789 --name redis kampka/redis:latest` 
