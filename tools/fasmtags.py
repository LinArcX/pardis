#!/usr/bin/env python3

import sys
import re
import collections

Tag = collections.namedtuple('Tag', 'name file line')
tags = []

if len(sys.argv) != 2:
    print("usage: fasmtags.py <symbols_file>")
    exit(1)

with open(sys.argv[1], 'r') as infile:
    for line in infile:
        m = re.match(r'(.+): .* defined (.*)', line)
        if m:
            name = m.group(1)
            if name == '@@':
                continue
            for line in m.group(2).split('from'):
                m = re.match(r'.*\s(.*)\[(\d*)\].*', line)
                tags.append(Tag(name, m.group(1), m.group(2)))

with open('tags', 'w') as outfile:
    outfile.write('!_TAG_FILE_FORMAT\t{2}\n')
    outfile.write('!_TAG_FILE_SORTED\t{1}\n')
    for tag in sorted(tags, key=lambda t: t.name):
        outfile.write('%s\t%s\t%s\n' % (tag.name, tag.file, tag.line))
