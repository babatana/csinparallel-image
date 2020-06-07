#!/usr/bin/python

from typing import List

def format_version(version: str) -> List[str]:
    return version.split('/')[-1].replace('.yaml', '').split('.')

def sort_by_major_version(version: str) -> int:
    return int(format_version(version)[0])

def sort_by_minor_version(version: str) -> int:
    return int(format_version(version)[1])

def sort_by_patch_version(version: str) -> int:
    return int(format_version(version)[2])


class FilterModule(object):
    def filters(self):
        return {
            'version_sort': self.version_sort
        }

    def version_sort(self, versions):
        formatted_versions = [version.split('/')[-1] for version in versions]
        return sorted(sorted(sorted(formatted_versions, key=sort_by_patch_version), key=sort_by_minor_version), key=sort_by_major_version)
        
