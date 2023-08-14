#!/bin/bash
for i in {1..2000}
do
    echo "Collecting data turn $i"
    # extract essential data from raw data
    sudo ovs-ofctl -O OpenFlow13 dump-flows s1 > data/raw.txt #for mininet
    #sudo ovs-ofctl dump-flows tcp:10.0.1.1:6633 > data/raw.txt #for real network
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


