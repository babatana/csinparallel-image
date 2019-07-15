#!/bin/bash

/usr/local/bin/ansible-pull -o \
-U https://gitlab+deploy-token-12:sErpRQP96JzfVponpBh-@stogit.cs.stolaf.edu/narvae1/hd-image.git \
-e imgVersion=`cat /usr/share/HD/version` | /usr/bin/logger -t cron-ansible-pull
