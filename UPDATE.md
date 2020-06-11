# Creating an Update

- Create a task file in `updates/` called `{your_version}.yaml` (e.g. `3.0.0.yaml`)
*(Note that it has to be `.yaml`, not `.yml`, otherwise it won't be found)*
- Include all tasks in this file
- Update the version (see below)


## Adding Pre-made Files

- Create a directory in `files/` called `{your_version}` (e.g. `files/3.0.0`)
- Add a task that uses the copy module:
```
- name: Add {your_file}
  become: yes
  copy:
    src: files/{your_version}/{your_file}
    dest: {destination_path}/{your_file}
```

### Adding an Update to `csip-image.bash`

- Make a copy of the latest version of the file and add it to `files/{your_version}/`
  - Check that no versions since have made single line updates to the file (using `lineinfile` or `replace`, for example). If so, then you should probably get the file from an updated copy of the image.
- Make any necessary updates to that file
- There are pre-made tasks that you can use:
```
- name: Update csip-image
  import_tasks: ../update_csip-image.yaml
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
