#!/usr/bin/python3

from subprocess import call, Popen, PIPE
import re
import sys

#YOUR_WIFI_NAME = "Elvira"

class WifiInfoProcessor(object):
    def __init__(self):
        self.your_wifi_name = self.get_your_wifi_name()

    def wifi_info(self):
        channel_signal_strengths = {}
        routers_per_channel = {}

        your_router_channel = None
        your_router_signal_strength = None

        for channel_line, quality_line, channel_name_line in self._read_wifi_info():
            channel_name = self._process_channel_name_line(channel_name_line)
            channel = self._process_channel_line(channel_line)
            _, _, dBm = self._process_quality_line(quality_line)

            # TODO: need null test
            if channel_name == self.your_wifi_name:
                your_router_channel = channel
                your_router_signal_strength = dBm_to_power(dBm)
            else:
                if channel not in routers_per_channel:
                    routers_per_channel[channel] = 0
                if channel not in channel_signal_strengths:
                    channel_signal_strengths[channel] = []

                routers_per_channel[channel] += 1
                channel_signal_strengths[channel].append(dBm_to_power(dBm))

        return (self.your_wifi_name, your_router_channel, your_router_signal_strength,
                routers_per_channel, channel_signal_strengths)

    def _process_channel_line(self, channel_line):
        return int(re.sub(' +Channel:', '', channel_line))

    def _process_quality_line(self, quality_line):
        positive_or_negative_number_regex = "-*\d+"
        numbers = re.findall(positive_or_negative_number_regex, quality_line)
        numbers = [int(x) for x in numbers]
        quality_numerator, quality_denominator, quality_in_dBm = numbers
        return quality_numerator, quality_denominator, quality_in_dBm

    def _process_channel_name_line(self, channel_name_line):
        channel_name = re.sub('.+ESSID:', '', channel_name_line)
        channel_name = re.sub('"', '', channel_name)
        return channel_name

    def get_your_wifi_name(self):
        iwconfig_handle = Popen(['iwgetid', '-r'], stdin=PIPE, stdout=PIPE, stderr=PIPE)
        output, error = iwconfig_handle.communicate()
        your_wifi_name = output.decode('utf-8').rstrip('\n')
        return your_wifi_name

    def _read_wifi_info(self):
        call(['connmanctl', 'scan', 'wifi'])
        iwlist_handle = Popen(['iwlist', 'wlp3s0', 'scan'], stdin=PIPE, stdout=PIPE, stderr=PIPE)
        output, error = iwlist_handle.communicate()
        output = output.decode('utf-8')


        channel_line = None
        quality_line = None
        channel_name_line = None

        for line in output.splitlines():
            if "Channel:" in line:
                channel_line = line
            if "Quality=" in line:
                quality_line = line
            if "ESSID" in line:
                channel_name_line = line
            if channel_name_line is not None and \
                    quality_line is not None and \
                    channel_line is not None:
                yield channel_line, quality_line, channel_name_line
                channel_line = quality_line = channel_name_line = None

def dBm_to_power(dBm):
        return 10 ** (dBm / 10)

def check_wifi_info(your_router_channel, your_router_signal_strength,
                    routers_per_channel, channel_signal_strengths):
    assert len(routers_per_channel) == len(channel_signal_strengths), \
        "Error, records differs as to number of router channels!"

    for channel in channel_signal_strengths:
        assert channel in routers_per_channel, \
            "Error, records differ as to which channels routers were on!"

    return

def print_wifi_info(your_wifi_name, your_router_channel,
                    your_router_signal_strength, routers_per_channel,
                    channel_signal_strengths):


    for channel in sorted(channel_signal_strengths):
        print("channel {:2} has signal strength of {:.10f} watts, \n"
              "       and has {:2} routers connected, "
              "not including your router".format(channel,
                                                 sum(channel_signal_strengths[channel]),
                                                 routers_per_channel[channel]))
    print()

    print("your network: {}, is on channel {:2}. \n"
          "        have {:.10f} watts of signal strength".format(your_wifi_name,
                                                             your_router_channel,
                                                             your_router_signal_strength))

    if your_router_channel in channel_signal_strengths:
        print("This compares to the channels {:.10f} watts of signal "
              "strength,\n        from its {} other "
              "connected routers".format(sum(channel_signal_strengths[your_router_channel]),
                                         routers_per_channel[your_router_channel]))

if __name__ == '__main__':
    wifi_info = WifiInfoProcessor().wifi_info()
    (your_wifi_name, your_router_channel, your_router_signal_strength,
     routers_per_channel, channel_signal_strengths) = wifi_info
    check_wifi_info(*wifi_info[1:])
    print_wifi_info(*wifi_info)
