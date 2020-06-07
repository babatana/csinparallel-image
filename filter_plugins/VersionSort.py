#!/usr/bin/python

def sort_by_major_version(version: str) -> int:
    return int(version.split('.')[0])

def sort_by_minor_version(version: str) -> int:
    return int(version.split('.')[1])

def sort_by_patch_version(version: str) -> int:
    return int(version.split('.')[2])


class FilterModule(object):
    def filters(self):
        return {
            'version_sort': self.version_sort
        }

    def version_sort(self, versions):
        formatted_versions = [version.split('/')[-1] for version in versions]
        return sorted(sorted(sorted(formatted_versions, key=sort_by_patch_version), key=sort_by_minor_version), key=sort_by_major_version)
        
