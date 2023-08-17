#!/bin/bash
for i in {1..2000}
do
# cookie=0x0, duration=0.668s, table=0, n_packets=0, n_bytes=0, idle_timeout=10, hard_timeout=30, idle_age=0, priority=65535,icmp,in_port=1,dl_vlan=2,dl_vlan_pcp=0,dl_src=38:60:77:89:f5:e4,dl_dst=38:60:77:8a:50:c2,nw_src=10.10.0.1,nw_dst=10.10.0.4,nw_tos=0,icmp_type=0,icmp_code=0 actions=output:4
#  cookie=0x0, duration=7.703s, table=0, n_packets=0, n_bytes=0, idle_timeout=10, hard_timeout=30, idle_age=7, priority=65535,icmp,in_port=4,dl_vlan=2,dl_vlan_pcp=0,dl_src=38:60:77:8a:50:c2,dl_dst=38:60:77:89:f5:e4,nw_src=10.10.0.4,nw_dst=10.10.0.1,nw_tos=0,icmp_type=8,icmp_code=0 actions=output:1
#  cookie=0x0, duration=3.791s, table=0, n_packets=0, n_bytes=0, idle_timeout=10, hard_timeout=30, idle_age=3, priority=65535,icmp,in_port=2,dl_vlan=2,dl_vlan_pcp=0,dl_src=38:60:77:89:f5:3e,dl_dst=38:60:77:89:f5:e4,nw_src=10.10.0.2,nw_dst=10.10.0.1,nw_tos=0,icmp_type=8,icmp_code=0 actions=output:1
#  cookie=0x0, duration=6.529s, table=0, n_packets=0, n_bytes=0, idle_timeout=10, hard_timeout=30, idle_age=6, priority=65535,icmp,in_port=1,dl_vlan=2,dl_vlan_pcp=0,dl_src=38:60:77:89:f5:e4,dl_dst=38:60:77:8a:50:c2,nw_src=10.10.0.1,nw_dst=10.10.0.4,nw_tos=0,icmp_type=8,icmp_code=0 actions=output:4
#  cookie=0x0, duration=8.680s, table=0, n_packets=0, n_bytes=0, idle_timeout=10, hard_timeout=30, idle_age=8, priority=65535,icmp,in_port=1,dl_vlan=2,dl_vlan_pcp=0,dl_src=38:60:77:89:f5:e4,dl_dst=38:60:77:89:f5:3e,nw_src=10.10.0.1,nw_dst=10.10.0.2,nw_tos=0,icmp_type=0,icmp_code=0 actions=output:2
#  cookie=0x0, duration=0.492s, table=0, n_packets=0, n_bytes=0, idle_timeout=10, hard_timeout=30, idle_age=0, priority=65535,icmp,in_port=4,dl_vlan=2,dl_vlan_pcp=0,dl_src=38:60:77:8a:50:c2,dl_dst=38:60:77:89:f5:e4,nw_src=10.10.0.4,nw_dst=10.10.0.1,nw_tos=0,icmp_type=0,icmp_code=0 actions=output:1
#  cookie=0x0, duration=2.709s, table=2, n_packets=2, n_bytes=128, idle_timeout=10, hard_timeout=30, idle_age=1, priority=65535,arp,in_port=4,dl_vlan=2,dl_vlan_pcp=0,dl_src=38:60:77:8a:50:c2,dl_dst=38:60:77:89:f5:e4,arp_spa=10.10.0.4,arp_tpa=10.10.0.1,arp_op=1 actions=output:1
#  cookie=0x0, duration=1.739s, table=2, n_packets=1, n_bytes=64, idle_timeout=10, hard_timeout=30, idle_age=1, priority=65535,arp,in_port=1,dl_vlan=2,dl_vlan_pcp=0,dl_src=38:60:77:89:f5:e4,dl_dst=38:60:77:8a:50:c2,arp_spa=10.10.0.1,arp_tpa=10.10.0.4,arp_op=2 actions=output:4

    echo "Collecting data turn $i"
    # extract essential data from raw data
    #sudo ovs-ofctl -O OpenFlow13 dump-flows s1 > data/raw.txt #for mininet
    sudo ovs-ofctl dump-flows tcp:10.20.0.1:6633 > data/raw.txt #for real network
    grep "nw_src" data/raw.txt > data/flowentries.csv
    grep "arp_op=1" data/raw.txt > ARP_data/ARP_Request_flowentries.csv
    grep "arp_op=2" data/raw.txt > ARP_data/ARP_Reply_flowentries.csv




    ipsrc=$(awk -F "," '{split($14,c,"="); print c[2]","}' data/flowentries.csv)    
    ipdst=$(awk -F "," '{split($15,d,"="); print d[2]","}' data/flowentries.csv)    
    ethsrc=$(awk -F "," '{split($12,e,"="); print e[2]","}' data/flowentries.csv)   
    ethdst=$(awk -F "," '{split($13,f,"="); print f[2]","}' data/flowentries.csv)   

    eth_src_reply=$(awk -F "," '{split($12,e,"="); print e[2]","}' ARP_data/ARP_Reply_flowentries.csv)   
    ip_dst_reply=$(awk -F "," '{split($15,d,"="); print d[2]","}' ARP_data/ARP_Reply_flowentries.csv)    


    if test -z "$ipsrc" || test -z "$ipdst" || test -z "$ethsrc" || test -z "$ethdst";
    then
        state=0
    else
        echo "$ipsrc" > data/ipsrc.csv
        echo "$ipdst" > data/ipdst.csv
        echo "$ethsrc" > data/ethsrc.csv
        echo "$ethdst" > data/ethdst.csv
        echo "$eth_src_reply" > ARP_data/eth_src_reply.csv
        echo "$ip_dst_reply" > ARP_data/ip_dst_reply.csv
    fi
    python3.8 computeRealTime.py
    #truncate -s 0 ARP_Broadcast/arp_broadcast.csv
    #python3.8 inspector.py
    sleep 3
done


