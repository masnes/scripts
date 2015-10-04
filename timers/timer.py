import re

from subprocess import call

from sys import argv
from enum import Enum
from time import sleep

VOICE = "english_rp"          #2m  3m   5m   10m  30m   1h    2h
RELEVANT_TIMES = [10, 30, 60, 120, 180, 300, 600, 1800, 3600, 7200]  # in seconds

def usage():
    print("Usage: enter a time in either format:")
    print("####...[smh] (seconds, minutes, hours)")
    print("##:##:## (number of colons between 0-2)")

class InputTypes(Enum):
    BASIC_FORM = 1,  # ####...[smh] (seconds, minutes, hours) (must match regex: ^[0-9]+[smh]$)

    COLON_FORM = 2,  # ##:##:## (number of :'s must be between 0-2).
                     # Having only one digit between :'s is allowed

    IMPROPER_INPUT = 3,

def basic_form_to_seconds(string):
    string = string.lower()
    multipliers = {"s": 1, "m": 60, "h": 3600}
    multiplier = multipliers[string[-1]] # Safe, since string must match BASIC_FORM regex
    seconds = int(string[:-1]) * multiplier
    return seconds

def colon_form_to_seconds(string):
    string = string.lower()
    time_increments = string.split(':')
    seconds = 0
    for i, increment in enumerate(reversed(time_increments)):
        seconds += int(increment) * (60 ** i)
    return seconds

def determine_input_type(inpt):
    if not isinstance(inpt, str):
        return InputTypes.IMPROPER_INPUT
    if re.match("^[0-9]+[smh]$", inpt):
        return InputTypes.BASIC_FORM
    elif re.match("^([0-2]?[0-9]:)?([0-5]?[0-9]:)?[0-5]?[0-9]$", inpt):
        return InputTypes.COLON_FORM
    return InputTypes.IMPROPER_INPUT

def break_up_time(seconds):
    """
    Break time up into chunks such that any slice of ret matching [1..n:] will
    sum to a RELEVANT_TIME
    """
    ret = []
    for relevant_time in RELEVANT_TIMES:
        if relevant_time > seconds:
            ret.append(seconds)
            break
        this_time_chunk = relevant_time - sum(ret)
        ret.append(this_time_chunk)
        seconds -= this_time_chunk
    return ret[::-1]

class TimeAmounts(Enum):
    seconds = 1
    minutes = 2
    hours = 3

def type_and_postfix(seconds):
    if seconds < 30:
        return TimeAmounts.seconds, ""
    elif seconds <= 60:
        return TimeAmounts.seconds, "seconds"
    elif seconds < 120:
        return TimeAmounts.minutes, "minute"
    elif seconds < 3600:
        return TimeAmounts.minutes, "minutes"
    elif seconds < 7200:
        return TimeAmounts.hours, "hour"
    else:
        return TimeAmounts.hours, "hours"

def convert(seconds, smh):
    if smh == TimeAmounts.seconds:
        return seconds
    if smh == TimeAmounts.minutes:
        return seconds // 60
    if smh == TimeAmounts.hours:
        return seconds // 3600

def sleep_and_say(time_chunks):
    for i, seconds in enumerate(time_chunks):
        time_left = sum(time_chunks[i:])
        smh, postfix = type_and_postfix(time_left)
        time_in_correct_scale = convert(time_left, smh)
        # ex: espeak -v english_rp "3 minutes"
        call(['espeak', '-v', VOICE, str(time_in_correct_scale) + " " + postfix])
        sleep(seconds)
    call(['espeak', '-v', VOICE, "done"])

def main():
    try:
        inpt = argv[1]
    except IndexError:
        inpt = None
    in_type = determine_input_type(inpt)
    if in_type == InputTypes.BASIC_FORM:
        seconds = basic_form_to_seconds(inpt)
    elif in_type == InputTypes.COLON_FORM:
        seconds = colon_form_to_seconds(inpt)
    else:
        usage()
        return
    time_chunks = break_up_time(seconds)
    print(time_chunks)
    sleep_and_say(time_chunks)


if __name__ == '__main__':
    main()
