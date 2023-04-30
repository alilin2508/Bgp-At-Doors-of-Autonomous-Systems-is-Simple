# !/bin/bash


# Configuration des interfaces qui communiquent avec les leaf
# loopback interface du routeur (sur lequel il sera accessible en next-hop pour le routing)

# Ajoute des leaf dans la table de routage (en groupe)

# update-surce : Autorise the bgp routing process avec les voisins

# La range d'adress pour le routing process bgp

# Set les leaf en client reflector (le RR va rebondir sur chacun d'entre eux)

# Le RR doit etre dans L2VPN address family meme si il n est pas dans la topo overlay
# car il doit eter accessible a tout moment pour faire du routing bgp
# Le L2VPN est le reseaux virtuel dans lequel le RR doit etre accessible en cas de changement (ajout de machines, changement de cablage etc...)
# Mais il ne fait pas partie de la topology overlay
vtysh << STOP
conf t
hostname router_hrazanam-1
no ipv6 forwarding
!
interface eth0
ip address 10.1.1.1/30
!
interface eth1
ip address 10.1.1.5/30
!
interface eth2
ip address 10.1.1.9/30
!
interface lo
ip address 1.1.1.1/32
!
router bgp 1
neighbor ibgp peer-group
neighbor ibgp remote-as 1
neighbor ibgp update-source lo
bgp listen range 1.1.1.0/29 peer-group ibgp
!
address-family l2vpn evpn
neighbor ibgp activate
neighbor ibgp route-reflector-client
exit-address-family
!
router ospf
network 10.1.1.0/24 area 0
network 1.1.1.0/24 area 0
!
line vty
STOP
