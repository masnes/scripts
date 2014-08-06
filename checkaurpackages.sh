#!/usr/bin/python
# by: Florian Bruhin (The Compiler) <aurood@the-compiler.org>
# Additional modification by: Michael Asnes
# I hereby place this code in the public domain.

import subprocess
import requests

out = subprocess.check_output(['pacman', '-Qm'], universal_newlines=True)
pkgs = [pkg.split()[0] for pkg in out.split('\n') if pkg]

payload = {'type': 'multiinfo', 'arg[]': pkgs}
json = requests.get('https://aur.archlinux.org/rpc.php', params=payload).json()

print("--------------------------------------------------")

somethingiscurrent = 0
for result in json['results']:
    if not result['OutOfDate']:
      print(result['Name'], "is up to date")
      somethingiscurrent = 1

if somethingiscurrent:
  print("--------------------------------------------------")

somethingisoutofdate = 0;
for result in json['results']:
    if result['OutOfDate']:
        print(result['Name'], "is out of date")
        somethingoutofdate = 1

if somethingisoutofdate:
  print("--------------------------------------------------")
