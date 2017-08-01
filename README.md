## A Vagrant
### Dev env for bedrock/Wordpress
Uses Virtual Box. Currently for linux and mac users for now.

clone the repo
```
git clone git@github.com:jperocho/a-vagrant.git <project_name>
```

### Add vagrant box
```
vagrant box add vmbeta0.0.4.box --name vm/beta0.0.4
```

### To use Bedrock
Edit type in config.yml file

```yaml
config:
  type: bedrock
```

### To use Wordpress (There is a slight bug on this cant login with ssl creds)
Edit type in config.yml file and change it to wordpress

```yaml
config:
  type: wordpress
```

### Run vagrant
```
vagrant up
```
It will prompt for your systems password. It will install all necessary files available

### To access the box
```
vagrant ssh
```

### To stop or pause the project
```
vagrant halt
```
