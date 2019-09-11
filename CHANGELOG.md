## [2.0.4](https://stogit.cs.stolaf.edu/hd-image/hd-image/blob/master/updates/2.0.4.yaml)
- Update `PiTracker.bash` to use new PiTracker subdomain
- Update version to 2.0.4


## [2.0.3](https://stogit.cs.stolaf.edu/hd-image/hd-image/blob/master/updates/2.0.3.yaml)
- Update `hd-image.bash`
- Update `PiTracker.bash`
- Modify systemd service and cron job to work with new `hd-image.bash`
- Update version to 2.0.3


## [2.0.2](https://stogit.cs.stolaf.edu/hd-image/hd-image/blob/master/updates/2.0.2.yaml)
- Add a line to all `.bashrc` files that shows a message when the image has been updated
- Enable and start isc-dhcp-server (wasn't enabled properly in 2.0.0)
- Update `hd-image.bash`
- Update version to 2.0.2


## [2.0.1](https://stogit.cs.stolaf.edu/hd-image/hd-image/blob/master/updates/2.0.1.yaml)
- Create `/etc/owner`
- Update `hd-image.bash`
- Update version to 2.0.1


## [2.0.0](https://stogit.cs.stolaf.edu/hd-image/hd-image/blob/master/updates/2.0.0.yaml)
- Upgrade packages
- Install packages
  - isc-dhcp-server
  - vim
  - emacs
  - cowsay
  - sl
- Set static IP to 10.0.0.254
- Configure isc-dhcp-server
  - Add eth0 to interfaces used by the server
  - Modify `/etc/dhcp/dhcpd.conf`
  - Modify service to restart on failure
    - Copy `/run/systemd/generator.late/isc-dhcp-server.service` to `/etc/systemd/system/`
    - Modify `/etc/systemd/system/isc-dhcp-server.service`
- Add `/usr/HD/` directory
  - Add `PiTracker.bash`
  - Add `hd-image.bash`
  - Create symlink from `/usr/bin/hd-image` to `/usr/HD/hd-image.bash`
- Add CSinParallel directory to `/etc/skel/` and `/home/pi/`
- Create cron job for PiTracker
  - Runs at 5 am every day to check for updates and report info to PiTracker server
- Create PiTracker service
  - Runs at boot to check for updates and report info to PiTracker server
- Update version to 2.0.0


## Pre-2.0.0 (a.k.a. 2.0.0.02)
Clean copy of Raspbian Buster with basic setup:
- Set timezone and language
- Connected to St. Olaf Guest WiFi
- Upgraded packages
- Enabled SSH and VNC


## 1.0.0
Old image (Not located here)
