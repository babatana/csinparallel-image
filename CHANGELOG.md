# Changelog

## [3.0.2](updates/3.0.2.yaml)

3.0.2 finishes the configuration for all images.
- Add the CSinParallel directory to all home directories
- Add a line to all `.bashrc` files that shows a message when the image has been updated
- Update version to 3.0.2


## [3.0.1](updates/3.0.1.yaml)

3.0.1 sets the static ip address and configures dhcp.
- Set static IP to 10.0.0.254
- Restart dhcpcd, wait for it to fail, then restart it again
- Configure isc-dhcp-server
  - Add eth0 to interfaces used by the server
  - Modify `/etc/dhcp/dhcpd.conf`
  - Modify service to restart on failure
    - Copy `/run/systemd/generator.late/isc-dhcp-server.service` to `/etc/systemd/system/`
    - Modify `/etc/systemd/system/isc-dhcp-server.service`
- Update version to 3.0.1


## [3.0.0](updates/3.0.0.yaml)

3.0.0 gets the image configured to the same point as the [custom image](https://github.com/maxnz/csinparallel-gen).  
*It is assumed that the user has configured locale, timezone and WiFi and has enabled SSH and VNC*
- Upgrade packages
- Install packages
  - isc-dhcp-server
  - vim
  - emacs
  - cowsay
  - sl
- Add `/usr/CSiP/` directory
  - Add `csip-image.bash`
  - Create symlink from `/usr/bin/csip-image` to `/usr/CSiP/csip-image.bash`
- Update version to 3.0.0

