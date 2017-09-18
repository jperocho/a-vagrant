## A Vagrant
### Development Box for Wordpress

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

#### Example:
### Creates a bare php samplesite.
```
$ vagrant addsite samplesite
```
### Creates a wordpress samplesite.
```
$ vagrant addsite samplesite --wordpress
```
### Creates a wordpress samplesite with jointswp theme.
```
$ vagrant addsite samplesite --wordpress --jointswp
```
### Creates a wordpress samplesite with Sage theme.
```
$ vagrant addsite samplesite --wordpress --sage
```
### Creates a bedrock wordpress samplesite
```
$ vagrant addsite samplesite --bedrock
```
### Creates a bedrock wordpress samplesite with Sage theme
```
$ vagrant addsite samplesite --bedrock --sage
```
### Creates a bedrock wordpress samplesite with JointsWP theme
```
$ vagrant addsite samplesite --bedrock --jointswp
```
