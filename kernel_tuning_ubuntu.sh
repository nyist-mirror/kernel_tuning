#!/bin/bash
echo '
# Syncookies make SYN flood attacks ineffective
net.ipv4.tcp_syncookies = 1

# Ignore bad ICMP
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1

# Disable ICMP Redirect Acceptance
net.ipv4.conf.all.accept_redirects = 0

# Enable IP spoofing protection, turn on source route verification
net.ipv4.conf.all.rp_filter = 0

# Log Spoofed Packets, Source Routed Packets, Redirect Packets
net.ipv4.conf.all.log_martians = 1

# Reply to ARPs only from correct interface (required for DSR load-balancers)
net.ipv4.conf.all.arp_announce = 2
net.ipv4.conf.all.arp_ignore = 1
fs.file-max = 1024000

net.ipv4.tcp_max_syn_backlog = 4096
net.core.netdev_max_backlog =  32768
net.core.somaxconn = 20480

net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216

net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 2

net.netfilter.nf_conntrack_tcp_timeout_time_wait=30

net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_tw_reuse = 1

net.ipv4.tcp_fin_timeout = 30
#net.ipv4.tcp_keepalive_time = 60
net.ipv4.ip_local_port_range = 1024  65535
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 30

net.netfilter.nf_conntrack_max = 250000
net.nf_conntrack_max = 250000
net.ipv4.tcp_max_tw_buckets = 1440000
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.tcp_keepalive_intvl = 5
net.ipv4.tcp_keepalive_probes = 5

net.netfilter.nf_conntrack_max = 1280000
vm.swappiness = 0
' >>/etc/sysctl.conf
sysctl -p

# tunne limits
echo '
*   soft nofile 128000
*   hard nofile 256000

root soft nofile 128000
root hard nofile 256000
' >> /etc/security/limits.conf

grep  "session required pam_limits.so" /etc/pam.d/common-session >/dev/null || {
	echo 'session required pam_limits.so' >> /etc/pam.d/common-session
}

