sakura2ssh
==========
# Install
```
$ gem install sakura2ssh
```

# How to use
### 1. create configuration file
```
$ vim <config_file>
---
ssh_config: <ssh_config_file_path>
apikey:
  access_token: <access_token>
  access_token_secret: <access_token_secret>
user: 

```

### 2. run sakura2ssh
```
$ sakukra2ssh update --config <config_file>
```

# License
sakura2ssh is released under the Apache License.


