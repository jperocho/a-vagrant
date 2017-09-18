## A Vagrant
### Development Box for Wordpress

#### STACK
PHP 5.6
MariaDB
NginX
Phpmyadmin

### Initialize
```
$ vagrant up
```

After Initialize you can access the box on http://dev.box.
You can also access phpmyadmin on http://dev.box/phpmyadmin.

### Adding Site
```
USAGE: vagrant addsite [sitename] [base-options] [theme]
```

### base-options
--wordpress
--bedrock

### theme-options
--jointswp
--sage

### Recipes:
#### Creates a bare php samplesite.
```
$ vagrant addsite samplesite
```
Access it on http://samplesite.dev.box
#### Creates a wordpress samplesite.
```
$ vagrant addsite samplesite --wordpress
```
Access it on http://samplesite.dev.box
#### Creates a wordpress samplesite with jointswp theme.
```
$ vagrant addsite samplesite --wordpress --jointswp
```
Access it on http://samplesite.dev.box
#### Creates a wordpress samplesite with Sage theme.
```
$ vagrant addsite samplesite --wordpress --sage
```
Access it on http://samplesite.dev.box
#### Creates a bedrock wordpress samplesite
```
$ vagrant addsite samplesite --bedrock
```
Access it on http://samplesite.dev.box
#### Creates a bedrock wordpress samplesite with Sage theme
```
$ vagrant addsite samplesite --bedrock --sage
```
Access it on http://samplesite.dev.box
#### Creates a bedrock wordpress samplesite with JointsWP theme
```
$ vagrant addsite samplesite --bedrock --jointswp
```
Access it on http://samplesite.dev.box

### Note: You can't create multiple site with the same name.