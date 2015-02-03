#!/bin/sh

# iptable path
IPTABLES="/sbin/iptables"

#################################################################################################
# ∞¸∏Æº≠πˆ IP											#
#################################################################################################
COMPANY_MGT1="10.10.10.251"		# Management 1 (Public IP)
COMPANY_MGT2="10.10.10.252"		# Management 2 (Public IP)
COMPANY_MGT3="10.10.10.253"		# Management 3 (Public IP)

COMPANY_OFFICE1="8.8.8.8"     # Company OFFICE IP

COMPANY_PRIVATE1="192.168.100.0/24" # Private IP

#################################################################################################
COMPANY_IDC_M1="1.1.1.224/27"  # IDC IP
#################################################################################################
# Co-op	
#################################################################################################
#COMPANY_COOP1=""
#COMPANY_COOP2=""
#COMPANY_COOP3=""
#COMPANY_COOP4=""
#COMPANY_COOP5=""
#################################################################################################




# Flashuing firewall
$IPTABLES -F


# Reset firewall
$IPTABLES -X

# firewall Rules default setting.
$IPTABLES -P INPUT   ACCEPT
$IPTABLES -P FORWARD ACCEPT
$IPTABLES -P OUTPUT  ACCEPT


# Flashuing firewall
$IPTABLES -F INPUT
$IPTABLES -F FORWARD
$IPTABLES -F OUTPUT


# firewall Rules default setting.
$IPTABLES -P INPUT   ACCEPT
$IPTABLES -P FORWARD ACCEPT
$IPTABLES -P OUTPUT  ACCEPT


# firewall Rules run setting.
$IPTABLES -P INPUT   DROP
$IPTABLES -P FORWARD ACCEPT
$IPTABLES -P OUTPUT  ACCEPT
$IPTABLES -A INPUT -i lo -j ACCEPT

$IPTABLES -A INPUT   -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPTABLES -A OUTPUT  -m state --state ESTABLISHED,RELATED -j ACCEPT

#################################################################################################
## string packet DROP
##$IPTABLES -A INPUT -m string --string 'cmd.exe' -j DROP 
## Nimda, CodeRed
##$IPTABLES -A INPUT -m string --string "/default.ida?" -j REJECT --reject-with tcp-reset
##$IPTABLES -A INPUT -m string --string "XXXXXXXX" -j REJECT --reject-with tcp-reset
##$IPTABLES -A INPUT -m string --string "cmd.exe" -j REJECT --reject-with tcp-reset
##$IPTABLES -A INPUT -m string --string "root.exe?" -j REJECT --reject-with tcp-reset
##
## SQL Slammer
##$IPTABLES -A INPUT -p udp -m string --string "Qh.dllhel32hkern" -j REJECT
#################################################################################################
# HTTP(80) Open
$IPTABLES -A INPUT -p TCP --dport 80 -m state --state NEW -j ACCEPT

#################################################################################################
# Company OFFICE SSH Open								#
#################################################################################################
$IPTABLES -A INPUT -p TCP -s $COMPANY_OFFICE1	--dport 22 -m state --state NEW -j ACCEPT

#################################################################################################
# Private Network SSH Open 
#################################################################################################
# 192.168.1.0/24 , 192.168.2.0/24
$IPTABLES -A INPUT -p TCP -s $COMPANY_PRIVATE1	--dport 22 -m state --state NEW -j ACCEPT

#################################################################################################
# SSH(22) / HTTP(80) / RSYNC(873) / MySQL(3306) / Nagios-Nrpe (5666) / SNMP (161)		#
#################################################################################################
# SSH
$IPTABLES -A INPUT -p TCP -s $COMPANY_MGT1	--dport 22 -m state --state NEW -j ACCEPT
$IPTABLES -A INPUT -p TCP -s $COMPANY_MGT2	--dport 22 -m state --state NEW -j ACCEPT
$IPTABLES -A INPUT -p TCP -s $COMPANY_MGT3	--dport 22 -m state --state NEW -j ACCEPT
#################################################################################################
# RSync
$IPTABLES -A INPUT -p TCP -s $COMPANY_MGT1	--dport 873 -m state --state NEW -j ACCEPT
$IPTABLES -A INPUT -p TCP -s $COMPANY_MGT2	--dport 873 -m state --state NEW -j ACCEPT
$IPTABLES -A INPUT -p TCP -s $COMPANY_MGT3	--dport 873 -m state --state NEW -j ACCEPT
#################################################################################################

$IPTABLES -A INPUT -p TCP -s $COMPANY_OFFICE1	--dport 873 -m state --state NEW -j ACCEPT

#################################################################################################
$IPTABLES -A INPUT -p TCP -s $COMPANY_PRIVATE1   --dport 873 -m state --state NEW -j ACCEPT

#################################################################################################
# Nagios-nrpe
$IPTABLES -A INPUT -p TCP -s $COMPANY_MGT1	--dport 5666 -m state --state NEW -j ACCEPT
$IPTABLES -A INPUT -p TCP -s $COMPANY_MGT2	--dport 5666 -m state --state NEW -j ACCEPT
$IPTABLES -A INPUT -p TCP -s $COMPANY_MGT3	--dport 5666 -m state --state NEW -j ACCEPT
$IPTABLES -A INPUT -p TCP -s $COMPANY_MGT4	--dport 5666 -m state --state NEW -j ACCEPT
$IPTABLES -A INPUT -p TCP -s $COMPANY_MGT5	--dport 5666 -m state --state NEW -j ACCEPT
$IPTABLES -A INPUT -p TCP -s $COMPANY_MGT6	--dport 5666 -m state --state NEW -j ACCEPT
$IPTABLES -A INPUT -p TCP -s $COMPANY_MGT7	--dport 5666 -m state --state NEW -j ACCEPT

#################################################################################################
# MySQL - DB Port
$IPTABLES -A INPUT -p TCP -s $COMPANY_PRIVATE1	--dport 3306 -m state --state NEW -j ACCEPT


#################################################################################################
# Nagios-nrpe 
$IPTABLES -A INPUT -p TCP -s $COMPANY_PRIVATE1	--dport 5666 -m state --state NEW -j ACCEPT

#################################################################################################
# SNMP Protocol
$IPTABLES -A INPUT -p UDP -s $COMPANY_PRIVATE1	--dport 161 -m state --state NEW -j ACCEPT
$IPTABLES -A INPUT -p UDP -s $COMPANY_MGT1	--dport 161 -m state --state NEW -j ACCEPT
$IPTABLES -A INPUT -p UDP -s $COMPANY_MGT2	--dport 161 -m state --state NEW -j ACCEPT
$IPTABLES -A INPUT -p UDP -s $COMPANY_MGT3	--dport 161 -m state --state NEW -j ACCEPT

#################################################################################################
# Co-Op PORT Open
#################################################################################################
## FTP
#$IPTABLES -A INPUT -p UDP -s $COMPANY_COOP1	--dport 20 -m state --state NEW -j ACCEPT
#$IPTABLES -A INPUT -p UDP -s $COMPANY_COOP2	--dport 20 -m state --state NEW -j ACCEPT
#$IPTABLES -A INPUT -p UDP -s $COMPANY_COOP3	--dport 20 -m state --state NEW -j ACCEPT
#$IPTABLES -A INPUT -p UDP -s $COMPANY_COOP4	--dport 20 -m state --state NEW -j ACCEPT
#$IPTABLES -A INPUT -p UDP -s $COMPANY_COOP5	--dport 20 -m state --state NEW -j ACCEPT

#$IPTABLES -A INPUT -p TCP -s $COMPANY_COOP1	--dport 21 -m state --state NEW -j ACCEPT
#$IPTABLES -A INPUT -p TCP -s $COMPANY_COOP2	--dport 21 -m state --state NEW -j ACCEPT
#$IPTABLES -A INPUT -p TCP -s $COMPANY_COOP3	--dport 21 -m state --state NEW -j ACCEPT
#$IPTABLES -A INPUT -p TCP -s $COMPANY_COOP4	--dport 21 -m state --state NEW -j ACCEPT
#$IPTABLES -A INPUT -p TCP -s $COMPANY_COOP5	--dport 21 -m state --state NEW -j ACCEPT

#################################################################################################
## SSH
#$IPTABLES -A INPUT -p TCP -s $COMPANY_COOP1	--dport 22 -m state --state NEW -j ACCEPT
#$IPTABLES -A INPUT -p TCP -s $COMPANY_COOP2	--dport 22 -m state --state NEW -j ACCEPT
#$IPTABLES -A INPUT -p TCP -s $COMPANY_COOP3	--dport 22 -m state --state NEW -j ACCEPT
#$IPTABLES -A INPUT -p TCP -s $COMPANY_COOP4	--dport 22 -m state --state NEW -j ACCEPT
#$IPTABLES -A INPUT -p TCP -s $COMPANY_COOP5	--dport 22 -m state --state NEW -j ACCEPT

#################################################################################################
## HTTP
#$IPTABLES -A INPUT -p TCP -s $COMPANY_COOP1	--dport 80 -m state --state NEW -j ACCEPT
#$IPTABLES -A INPUT -p TCP -s $COMPANY_COOP2	--dport 80 -m state --state NEW -j ACCEPT
#$IPTABLES -A INPUT -p TCP -s $COMPANY_COOP3	--dport 80 -m state --state NEW -j ACCEPT
#$IPTABLES -A INPUT -p TCP -s $COMPANY_COOP4	--dport 80 -m state --state NEW -j ACCEPT
#$IPTABLES -A INPUT -p TCP -s $COMPANY_COOP5	--dport 80 -m state --state NEW -j ACCEPT

#################################################################################################
## ETC Port
#$IPTABLES -A INPUT -p TCP -s $COMPANY_COOP1	--dport 22 -m state --state NEW -j ACCEPT
#$IPTABLES -A INPUT -p TCP -s $COMPANY_COOP2	--dport 22 -m state --state NEW -j ACCEPT
#$IPTABLES -A INPUT -p TCP -s $COMPANY_COOP3	--dport 22 -m state --state NEW -j ACCEPT
#$IPTABLES -A INPUT -p TCP -s $COMPANY_COOP4	--dport 22 -m state --state NEW -j ACCEPT
#$IPTABLES -A INPUT -p TCP -s $COMPANY_COOP5	--dport 22 -m state --state NEW -j ACCEPT
#################################################################################################
#################################################################################################

#################################################################################################
#################################################################################################
$IPTABLES -A INPUT -p ICMP -j ACCEPT
$IPTABLES -A INPUT -p TCP --syn --dport 113 -j REJECT --reject-with tcp-reset
#$IPTABLES -A INPUT -i lo -j ACCEPT

# icmp packet.
$IPTABLES -A INPUT -i eth0 -p icmp --icmp-type 0 -j ACCEPT
$IPTABLES -A INPUT -i eth0 -p icmp --icmp-type 3 -j ACCEPT
$IPTABLES -A INPUT -i eth0 -p icmp --icmp-type 11 -j ACCEPT
