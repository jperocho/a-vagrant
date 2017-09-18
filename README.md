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
#### Creates a wordpress site.
```
$ vagrant addsite wpsite --wordpress
```
Access it on http://wpsite.dev.box
#### Creates a wordpress site with jointswp theme.
```
$ vagrant addsite wpsitejointswp --wordpress --jointswp
```
Access it on http://wpsitejointswp.dev.box
#### Creates a wordpress site with Sage theme.
```
$ vagrant addsite wpsitesage --wordpress --sage
```
Access it on http://wpsitesage.dev.box
#### Creates a bedrock wordpress site
```
$ vagrant addsite brsite --bedrock
```
Access it on http://brsite.dev.box
#### Creates a bedrock wordpress site with Sage theme
```
$ vagrant addsite brsitesage --bedrock --sage
```
Access it on http://brsitesage.dev.box
#### Creates a bedrock wordpress site with JointsWP theme
```
$ vagrant addsite brsitejointswp --bedrock --jointswp
```
Access it on http://brsitejointswp.dev.box

### Note: You can't create multiple site with the same name.