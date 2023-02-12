
# renomear as interfaces;
/interface set "ether1" name="ether1-gateway"
/interface set "ether2" name="ether2-gateway"
/interface set "ether5" name="ether5"

#Configurar IPs dos gateways;
:global primaryGateway 192.168.1.1
:global secundaryGateway 192.168.0.1

# configurar os clientes dhcp;
/ip dhcp-client
add add-default-route=no dhcp-options=hostname,clientid disabled=no interface=ether1-gateway use-peer-dns=no use-peer-ntp=no
add add-default-route=no dhcp-options=hostname,clientid disabled=no interface=ether2-gateway use-peer-dns=no use-peer-ntp=no

# atribuir ip na interface LAN;
/ip address
add address=192.168.88.1/24 interface=ether5 network=192.168.88.0

# mascara dos gateways no firewal
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1-gateway comment="GATEWAY 01 - MASK"
add action=masquerade chain=srcnat out-interface=ether2-gateway comment="GATEWAY 02 - MASK"

# configuraçao das regras do balance no FIREWALL > MANGLE
/ip firewall mangle
add action=mark-connection chain=prerouting comment="LOADBALANCE - GATEWAY 01" connection-state=new in-interface=ether1-gateway new-connection-mark=ether1_conn
add action=mark-connection chain=prerouting comment="LOADBALANCE - GATEWAY 02" connection-state=new in-interface=ether2-gateway new-connection-mark=ether2_conn
add action=mark-routing chain=output connection-mark=ether1_conn new-routing-mark=to_ether1
add action=mark-routing chain=output connection-mark=ether2_conn new-routing-mark=to_ether2
add action=mark-connection chain=prerouting connection-state=new dst-address-type=!local in-interface=ether5 new-connection-mark=ether1_conn per-connection-classifier=both-ports:2/0
add action=mark-connection chain=prerouting connection-state=new dst-address-type=!local in-interface=ether5 new-connection-mark=ether2_conn per-connection-classifier=both-ports:2/1
add action=mark-routing chain=prerouting connection-mark=ether1_conn in-interface=ether5 new-routing-mark=to_ether1
add action=mark-routing chain=prerouting connection-mark=ether2_conn in-interface=ether5 new-routing-mark=to_ether2

# configuraçao de rotas no IP > ROUTES;
/ip route
add check-gateway=ping comment="Ether1-Wan routing gateway" distance=1 gateway=$primaryGateway routing-mark=to_ether1
add check-gateway=ping comment="Ether2-Wan routing gateway" distance=1 gateway=$secundaryGateway routing-mark=to_ether2
add comment=Ether1-Wan distance=1 gateway=$primaryGateway
add comment=Ether2-Wan distance=2 gateway=$secundaryGateway

# configurar script de monitoramento dos links;
:global newgw1 [/ip dhcp-client get [find interface="ether1-gateway" ] gateway ]
:global activegw1 [/ip route get [/ip route find comment="Ether1-Wan"] gateway ]
:if ($newgw1 != $activegw1) do={
/ip route set [find comment="Ether1-Wan"] gateway=$newgw
/ip route set [find comment="Ether1-Wan routing gateway"] gateway=$newgw
}


:global newgw2 [/ip dhcp-client get [find interface="ether2-gateway" ] gateway ]
:global activegw2 [/ip route get [/ip route find comment="Ether2-Wan"] gateway ]
:if ($newgw2 != $activegw2) do={
/ip route set [find comment="Ether2-Wan"] gateway=$newgw
/ip route set [find comment="Ether2-Wan routing gateway"] gateway=$newgw
}

# agendar script para controle;
# Script name => ChangeGateways