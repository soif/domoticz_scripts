#!/bin/bash

# https://forum.netgate.com/topic/86883/help-on-disconnect-and-reconnect-a-pppoe-connection-by-command-line/5

# ssh net@gate.lo.lo " /usr/local/sbin/pfSctl -c 'interface reload opt1'; /usr/bin/logger -t ppp 'PPPoE reload executed on OPT1'; exit 0 " 

#IF=opt1
IF=wan

 ssh net@gate.lo.lo " /usr/local/sbin/pfSctl -c 'interface reload $IF'; /usr/bin/logger -t ppp 'PPPoE reload executed on $IF'; exit 0 " 

exit 0