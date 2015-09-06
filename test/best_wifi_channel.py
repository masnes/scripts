from subprocess import call, Popen, PIPE
import re
import sys

#YOUR_WIFI_NAME = "Elvira"
YOUR_WIFI_NAME = "HOME-56DB-2.4"

def main():
    call(['connmanctl', 'scan', 'wifi'])
    iwlist_handle = Popen(['iwlist', 'wlp3s0', 'scan'], stdin=PIPE, stdout=PIPE, stderr=PIPE)
    output, error = iwlist_handle.communicate()
    output = output.decode('utf-8')

    channel_signal_strengths = {}
    routers_per_channel = {}

    last_channel = None
    channel_name = None

    your_router_channel = None
    your_router_signal_strength = None

    for line in output.splitlines():
        if "Channel:" in line:
            last_channel = int(re.sub(' +Channel:', '', line))
            if last_channel not in channel_signal_strengths:
                channel_signal_strengths[last_channel] = []

        if "Quality=" in line:
            # e.g.:
            # Quality=70/70  Signal level=-29 dBm
            positive_or_negative_number_regex = "-*\d+"
            numbers = re.findall(positive_or_negative_number_regex, line)
            numbers = [int(x) for x in numbers]
            numerator, denominator, dBm = numbers
            last_channel_watts = dBm_to_power(dBm)

        if "ESSID:" in line:
            # e.g.
            # ESSID:"HOME-56DB-2.4"
            channel_name = re.sub(' +ESSID:', '', line)
            channel_name = re.sub('"', '', channel_name)
            if channel_name != YOUR_WIFI_NAME:
                channel_signal_strengths[last_channel].append(last_channel_watts)
                if last_channel not in routers_per_channel:
                    routers_per_channel[last_channel] = 1
                else:
                    routers_per_channel[last_channel] += 1
            else:
                your_router_channel = last_channel
                print(dBm)
                your_router_signal_strength = last_channel_watts



    for channel in sorted(channel_signal_strengths):
        print("channel {:2} has signal strength of {:.10f} watts, "
              "and has {:2} routers connected, "
              "not including your router".format(channel,
                                                 sum(channel_signal_strengths[channel]),
                                                 routers_per_channel[channel]))
    print()

    print(your_router_signal_strength)
    print("your network: {}, is on channel {:2}. "
          "You have {:.10f} watts of signal strength".format(YOUR_WIFI_NAME,
                                                        your_router_channel,
                                                        your_router_signal_strength))

    if your_router_channel in channel_signal_strengths:
        print("This compares to the channels {:.10f} watts of signal "
              "strength, and its {} other "
              "connected routers".format(sum(channel_signal_strengths[your_router_channel]),
                                         routers_per_channel[your_router_channel]))

def dBm_to_power(dBm):
    try:
        return 10 ** (dBm / 10)
    except OverflowError:
        print("Given {} dBm, result out of range!".format(dBm), file=sys.stderr)


#for i in `seq 1 11`; do
#echo $wifi_info | grep -A 3 "Channel:$i" | grep Quality
#done

if __name__ == '__main__':
    main()
