#!/bin/bash

if [[ $(mount | grep -c sda2) -eq 0 ]]; then
  sudo mount /dev/sda2 /mnt/windows
fi
if [[ $(mount | grep -c sda6) -eq 0 ]]; then
  sudo mount /dev/sda6 /mnt/mint/
fi

# Arch
echo "Arch"
duplicity --full-if-older-than 1M \
  --exclude /dev                  \
  --exclude /proc                 \
  --exclude /sys                  \
  --exclude /tmp                  \
  --exclude /run                  \
  --exclude /mnt                  \
  --exclude /media                \
  --exclude /lost+found           \
  /                               \
  file:///media/externaldrive/masnes-arch-backup/

# Windows
echo
echo "Windows"
duplicity --full-if-older-than 1M                  \
  --include '/mnt/windows/dev'                     \
  --include '/mnt/windows/Dev2'                    \
  --include '/mnt/windows/Documents and Settings'  \
  --include '/mnt/windows/Lingoport'               \
  --include '/mnt/windows/ProgramData'             \
  --include '/mnt/windows/Programming'             \
  --include '/mnt/windows/Programs'                \
  --include '/mnt/windows/Users'                   \
  --include '/mnt/windows/Visual Studio Projects'  \
  --exclude '*'                                    \
                                                   \
  /mnt/windows                                     \
  file:///media/externaldrive/masnes-windows-backup

# Mint
echo
echo "Mint"
duplicity --full-if-older-than 1M \
  --exclude '/dev'              \
  --exclude '/proc'             \
  --exclude '/sys'              \
  --exclude '/tmp'              \
  --exclude '/run'              \
  --exclude '/mnt'              \
  --exclude '/media'            \
  --exclude '/lost+found'         \
  /                               \
  file:///media/externaldrive/masnes-mint-backup/
