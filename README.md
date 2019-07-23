# HD-Image: The Official Hardware Design Raspberry Pi Image
This repository is used to create/update the HD Image using Ansible and `ansible-pull`. 
After the first pull, the image will check for updates at specified times. Therefore,
you will always have the latest version provided your Pi can contact StoGit.

## Supported Hardware Revisions
The HD Image is designed to work on the Raspberry Pi 4B - 1GB version.

The image has been tested on the following revisions:
- Raspberry Pi 4B - 1GB
- Raspberry Pi 4B - 2GB
- Raspberry Pi 4B - 4GB
- Raspberry Pi 3B
- Raspberry Pi 3B+

## How it Works
The image uses `ansible-pull` to check for updates. This is the inverse of how ansible is
typically used. This is done because running an ansible playbook from a central computer
at a specified time may not update all Pis because they might not all be turned on at the
time. This also requires an account on the image that can be used for running ansible.
Instead, the HD Image automatically checks for updates at two times: boot and 5am. This
way, the Pis will always be updated each time it is booted, but if the Pi is left on for
multiple days at a time, it will still receive updates. The update check at boot time is 
done with a systemd service that runs on startup. The 5am daily check is done with a cron job.

Whenever the Pi checks for an update, it downloads the repository and looks for a file called
`local.yml`. It then runs any plays in that file. Our `local.yml` file contains one task which
finds all `.yaml` files in `updates/` and includes their tasks if the version number they are 
associated with is greater than the version reported by the Pi. It then runs these plays in
order by version number (see [UPDATE.md](https://stogit.cs.stolaf.edu/hd-image/hd-image/blob/master/UPDATE.md)
for a note about version numbering). After every update check a report is sent to the
PiTracker server.

## Creating Your Own Copy of the Image
The image uses Ansible to minimize the amount of work you have to do to set up your image.
To start, install a fresh copy of Raspbian Buster on your Pi. Perform basic setup and make 
sure the Pi has an internet connection and can reach StoGit.

Then run the commands
```
sudo pip install ansible

ansible-pull -U https://gitlab+deploy-token-12:sErpRQP96JzfVponpBh-@stogit.cs.stolaf.edu/hd-image/hd-image.git -e imgVersion=0
```
This will install the latest version of the HD Image on your Pi and set it
up to check for updates automatically.

## Image Tools
### PiTracker
The HD Image includes a program called PiTracker which is used to report information 
about the Pi to a server (located in RMS 201 - running on two Raspberry Pis).

The information it reports includes:
- Pi's Serial Number
- Pi's Hardware Revision
- Pi's WiFi IP Address
- Pi's WiFi MAC Address
- SD Card's Serial Number
- Image Version
- Owner of the Pi (taken from /etc/owner)

Note that this tracking only works when the Pi is connected to St. Olaf Guest.

### hd-image
The HD Image also includes a tool called `hd-image` that can help you manage your image.
It can help you
- Check what version your image is
- Manually check for an image update
- Manually send a report to PiTracker
- View information about your Pi

Run `hd-image -h` to see information about how to use the tool.


## Creating an Update
See [UPDATE.md](https://stogit.cs.stolaf.edu/hd-image/hd-image/blob/master/UPDATE.md) for
instructions.
