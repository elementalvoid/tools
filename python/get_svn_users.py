#!/usr/bin/env python
from __future__ import print_function
import pysvn
import sys

tofile_file = None
def tofile(filename, list):
  global tofile_file
  if tofile_file is None:
    tofile_file = open(filename, 'w')
  [print(item, file=tofile_file) for item in list]

users_file = 'py_svn_users.out'
print('Writing users list to %s.' % users_file)
client = pysvn.Client()
try:
   url = raw_input('Enter Subversion Repository URL: (Ctrl-C to cancel)\n')
except KeyboardInterrupt:
   print()
   sys.exit()
print('Getting rev_start')
rev_start = client.info2(url, depth=pysvn.depth.empty)[0][1].values()[6].number
print('rev_start -> %d' %rev_start)
users = []
rev_limit = 500
rev_end= -1
print('Beginnig log loop:')
for rev in range (0, rev_start, rev_limit):
  rev_end = rev + rev_limit
  print('%d -> %d' % (rev, rev_end), end='')
  sys.stdout.flush()
  try:
    logs = client.log(url,
                      revision_start=pysvn.Revision(pysvn.opt_revision_kind.number, rev_end),
                      revision_end=pysvn.Revision(pysvn.opt_revision_kind.number, rev))
    [users.append(l['author']) for l in logs if not l['author'] in users]
    users.sort()
    tofile(users_file, users)
    print('.')
  except Exception as e:
    print('.')
    print('An exception has occurred:')
    print(type(e))
    print(e)
    continue
  finally:
    print(users)

print()
users.sort()
print(users)
tofile(users_file, users)

