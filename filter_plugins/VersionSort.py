#!/usr/bin/python

class FilterModule(object):
    def filters(self):
        return {
            'version_sort': self.version_sort
        }

    def version_sort(self, versions):
        versions.sort(key=lambda s: map(int, s.split('/')[-1][:-5].split('.')))
        return versions
        
