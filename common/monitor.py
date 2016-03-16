#!/usr/bin/python3
import sys

from os import getenv
from enum import Enum
from subprocess import call, Popen, PIPE, DEVNULL


class Monitor(Enum):
    MAIN = "LVDS1"
    DPI1 = "DPI1"
    HDMI1 = "DP1"
    VGA1 = "DP2"
    VIRTUAL1 = "VIRTUAL1"

BG_PICTURE_LOCATION = getenv("HOME") + "/pictures/blood_moon_rising.jpg"
BASIC_MONITOR = Monitor.MAIN
ADDITIONAL_MONITOR_POSSIBILITIES = [Monitor.DPI1, Monitor.HDMI1, Monitor.VGA1,
                                    Monitor.VIRTUAL1]
DESKTOP_NAMES = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"]


class Bspc(object):
    name = 'bspc'

    def __init__(self):
        pass

    @classmethod
    def add_desktop(cls, name, monitor):
        args = [cls.name, 'monitor', monitor.value, '-a', name]
        print(args)
        call(args)

    @classmethod
    def move_desktop(cls, name, to_monitor):
        args = [cls.name, 'desktop', name, '-m', to_monitor.value]
        print(args)
        call(args)

    @classmethod
    def desktops(cls, partial_or_full_name=None):
        args = [cls.name, 'query', '-D']
        print(args)
        desktops_buffer = Popen(args, 1, stdout=PIPE).communicate()[0]
        desktops = [desktop for desktop in desktops_buffer.decode().split('\n')
                    if len(desktop) > 0]
        if partial_or_full_name is not None:
            desktops = [desktop for desktop in desktops
                        if partial_or_full_name in desktop]
        return desktops

    @classmethod
    def remove_desktop(cls, name):
        args = [cls.name, 'desktop', name, '-r']
        print(args)
        call(args)


class Xrandr(object):
    def __init__(self):
        pass

    @staticmethod
    def monitor_off(monitor):
        args = ["xrandr", "--output", monitor.value, "--off", "--right-of",
                BASIC_MONITOR.value, "--primary"]
        print(args)
        call(args)

    @staticmethod
    def set_primary(monitor):
        args = ["xrandr", "--output", monitor.value, "--primary"]
        print(args)
        call(args)

    @staticmethod
    def new_monitor(monitor):
        args = ["xrandr", '--output', monitor.value, '--auto', '--right-of',
                BASIC_MONITOR.value, '--primary']
        print(args)
        call(args)

    @staticmethod
    def get_connected_monitors():
        """checks xrandr output to determine list of monitors present,
        returns a set of enums of all monitors connected"""
        args = ['xrandr']
        print(args)
        process = Popen(args, 1, stdout=PIPE)
        xrandr_output = process.communicate()[0].decode().split('\n')
        monitors_present = set()
        for line in xrandr_output:
            if len(line.split()) < 2:
                continue
            possibly_monitor_type, possibly_connected = line.split()[:2]
            try:
                monitor = Monitor(possibly_monitor_type)
            except ValueError:
                monitor = None
            if monitor is not None and possibly_connected == "connected":
                monitors_present.add(monitor)
        return monitors_present


class Feh(object):
    def __init__(self):
        pass

    @staticmethod
    def set_background():
        args = ['feh', '--bg-fill', BG_PICTURE_LOCATION]
        print(args)
        call(args)


class Panel(object):
    def __init__(self):
        pass

    @staticmethod
    def reset():
        reset_sxhkd = "pkill", "-USR1", "-x", "sxhkd"
        reset_panel = "pkill", "-USR1", "-x", "panel"
        run_panel = "nohup", getenv("HOME") + "/.scripts/panel/panel"
        print(reset_sxhkd)
        call(reset_sxhkd)
        print(reset_panel)
        call(reset_panel)
        print(run_panel)
        Popen(run_panel, stdout=DEVNULL, stderr=DEVNULL)


def setup_just_main_monitor():
    print("Just using main monitor, " + BASIC_MONITOR.value)
    for monitor in ADDITIONAL_MONITOR_POSSIBILITIES:
        Xrandr.monitor_off(monitor)
    Xrandr.set_primary(BASIC_MONITOR)


def setup_with_two_monitors(second_monitor):
    print("Using " + BASIC_MONITOR.value + ", " + second_monitor.value)
    Xrandr.new_monitor(second_monitor)
    Bspc.add_desktop('DesktopRemoveMe', second_monitor)
    for desktop_name in DESKTOP_NAMES[5:10]:
        Bspc.move_desktop(desktop_name, second_monitor)
    for desktop_name in Bspc.desktops("Desktop"):
        Bspc.remove_desktop(desktop_name)


def finish_up():
    for desktop_name in Bspc.desktops("Desktop"):
        Bspc.remove_desktop(desktop_name)
    Feh.set_background()
    Panel.reset()


def set_debug():
    Bspc.name = '/home/masnes/sourcecode/bspwm/bspc'


def main():
    try:
        if sys.argv[1] == '-d' or sys.argv[1] == '--debug':
            set_debug()
    except IndexError:
        pass
    other_connected_monitors = Xrandr.get_connected_monitors()
    other_connected_monitors.remove(Monitor.MAIN)
    other_connected_monitors.remove(Monitor.eDP1)
    print(other_connected_monitors)
    if len(other_connected_monitors) == 0:
        setup_just_main_monitor()
    else:
        new_monitor = Monitor(other_connected_monitors.pop())
        setup_with_two_monitors(new_monitor)
    finish_up()


if __name__ == '__main__':
    main()
