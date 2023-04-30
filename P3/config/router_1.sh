# !/bin/bash

#CRÉATION DE LA VLAN ID 10 AVEC 1 MACHINES
ip link add br0 type bridge
ip link set dev br0 up
ip link add vxlan10 type vxlan id 10 dstport 4789
ip link set dev vxlan10 up

brctl addif br0 vxlan10
brctl addif br0 eth1

#CRÉATION DE LA VLAN ID 11 AVEC DEUX MACHINES
ip link add br1 type bridge
ip link set dev br1 up
ip link add vxlan11 type vxlan id 11 dstport 4789
ip link set dev vxlan11 up

brctl addif br1 vxlan11
brctl addif br1 eth2

brctl addif br1 eth3

# Set up des address eth sur le backbone 0 pour le routing protocol underlay
# Set up des address loopback pour la communication ibgp entre leaf (VxLAN)

# Ajout du routeur reflector dans la table de routage

# Autorisation de communication avec le RR via sa loopback pour le peering process BGP

# Placement du routeur dans l'adress family mode l2vpn : 
# 1) Met le switch dans le VXLAN segment type layer 2
# note : VXLAN tunnel—Logical point-to-point tunnels between VTEPs over the transport network. 
# Each VXLAN tunnel can trunk multiple VXLANs.

# activate : autorise la communication BGP avec le RR 

# Applique les regle de routing pour toute les VxLANs set up sur le switch
vtysh << STOP
conf t
hostname router_hrazanam-2
no ipv6 forwarding
!
interface  eth0
ip address 10.1.1.2/30
ip ospf area 0
!
interface lo
ip address 1.1.1.2/32
ip ospf area 0
!
router bgp 1
neighbor 1.1.1.1 remote-as 1
neighbor 1.1.1.1 update-source lo
!
address-family l2vpn evpn
neighbor 1.1.1.1 activate
advertise-all-vni
exit-address-family
!
router ospf
!
STOP

