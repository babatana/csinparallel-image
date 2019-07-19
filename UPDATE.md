# Creating an Update
- Create a task file in `updates/` called `{your_version}.yaml`
_(Note that it has to be `.yaml`, not `.yml`, otherwise it won't be found)_
- Include all tasks in this file
- Update the version (see below)

## Adding Pre-made Files
- Create a directory in `files/` called `{your_version}`
- Add a task that uses the copy module:
```
- name: Add {your_file}
  become: yes
  copy:
    src: files/{your_version}/{your_file}
    dest: {destination_path}/{your_file}
```

### Adding an Update to `hd-image.bash` or `PiTracker.bash`
- Make a copy of the latest version of the file and add it to `files/{your_version}/`
  - Check that no versions since have made single line updates to the file 
  (using `lineinfile` or `replace`, for example). If so, then you should probably 
  get the file from an updated copy of the image.
- Make any necessary updates to that file
- There are pre-made tasks that you can use:
```
- name: Update PiTracker
  import_tasks: ../update_pitracker.yaml
  vars:
    version: 'your_version'
```
```
- name: Update hd-image
  import_tasks: ../update_hd-image.yaml
  vars:
    version: 'your_version'
```

## Updating the Version
- There is a pre-made task that is used to update the version:
```
- name: Update Version
  import_tasks: ../update_version.yaml
  vars:
    version: 'your_version'
```

## A Note About Version Numbering
Some version numbers won't be possible, i.e. going from v2.0.9 to v2.0.10.
When the ansible playbook is run, it first sorts all the files in `updates/`.
Therefore, going from 2.0.9 to 2.0.10 won't work, but going from 2.0.09 to 2.0.10 will.
