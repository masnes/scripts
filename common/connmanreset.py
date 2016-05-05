#!/usr/bin/python3
import re
import subprocess

all_connections = str(subprocess.check_output(["connmanctl", "services"])).split('\\n')
all_connections = [conn.lstrip("b'").rstrip("'") for conn in all_connections]

connected = [conn for conn in all_connections
             if re.match("\*[A]*[RO].*", conn) or
             re.match("[*A]+\b.*", conn)]

if len(connected) == 0:
    print("No wifi connected, exiting")
    exit(1)

ethernet_connections = [conn for conn in connected if "ethernet_" in conn]
wifi_connections = [conn for conn in connected if "wifi_" in conn]

print("Connected to:")
for conn in connected:
    print(conn.split()[1])
print("Resetting wifi connection")
for conn in connected:
    subprocess.call(["connmanctl", "disconnect", conn.split()[2]])
for conn in ethernet_connections:  # Ethernet first, then wifi
    subprocess.call(["connmanctl", "connect", conn.split()[2]])
for conn in wifi_connections:
    subprocess.call(["connmanctl", "connect", conn.split()[2]])
print("Done.")
