#HACHE

## What is it?
Hache is a web development tool targeting developers that want a simple way to start 
pre-configured httpd instances in any directory.

Hache can be configured with very little knowledge of the inner workings of Apache or it's configuration files.
```
sudo npm install hache -g
```

Init a new Hache-based project:
```
hache init
```
Running `hache init` creates a new `Hachefile`
This `Hachefile` will contain examples of things you can change about this environment such as Apache modules needed, port number, etc.
Better yet, this file uses YAML syntax for ease of use and readability.

Special thanks to the `devinrhode2/pache` project for giving me the idea.