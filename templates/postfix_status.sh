#!/bin/bash
# Script to fetch postfix statuses for tribily monitoring systems 
# Initial Author: Zabbix Community
# Improvements, Features, Testing: krish@toonheart.com
# License: GPLv2

# Set Variables
MAILLOG=<%= maillog %>
DAT1=~/zabbix-postfix-offset.dat
DAT2=$(mktemp)
PFLOGSUMM=/usr/sbin/pflogsumm.pl
ZABBIX_CONF=/etc/zabbix/zabbix_agentd.conf

function zsend { 
  /usr/bin/zabbix_sender -c $ZABBIX_CONF -k $1 -o $2
}

/usr/sbin/logtail -f$MAILLOG -o$DAT1 | $PFLOGSUMM -h 0 -u 0 --bounce_detail=0 --deferral_detail=0 --reject_detail=0 --no_no_msg_size --smtpd_warning_detail=0 > $DAT2 

zsend pfreceived `fgrep -m 1 received $DAT2|cut -f1 -d"r"`
zsend pfdelivered `fgrep -m 1 delivered $DAT2|cut -f1 -d"d"`
zsend pfforwarded `fgrep -m 1 forwarded $DAT2|cut -f1 -d"f"`
zsend pfdeferred `fgrep -m 1 deferred $DAT2|cut -f1 -d"d"`
zsend pfbounced `fgrep -m 1 bounced $DAT2|cut -f1 -d"b"`
zsend pfrejected `fgrep -m 1 rejected $DAT2|cut -f1 -d"r"`
zsend pfrejectwarnings `fgrep -m 1 "reject warnings" $DAT2|cut -f1 -d"r"`
zsend pfheld `fgrep -m 1 held $DAT2|cut -f1 -d"h"`
zsend pfdiscarded `fgrep -m 1 discarded $DAT2|cut -f1 -d"d"`
zsend pfbytesreceived `fgrep -m 1 "bytes received" $DAT2|cut -f1 -d"b"|cut -f1 -d"k"`
zsend pfbytesdelivered `fgrep -m 1 "bytes delivered" $DAT2|cut -f1 -d"b"|cut -f1 -d"k"`

rm $DAT2

