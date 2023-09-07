foreach h in=[/ip hotspot ip-binding find] do={

global bindingmac [/ip hotspot ip-binding get $h mac-address]   

global bindingcomment [/ip hotspot ip-binding get $h comment]

/ip dhcp-server lease make-static [/ip dhcp-server lease find mac-address="$bindingmac"]

/ip dhcp-server lease set comment="$bindingcomment" [/ip dhcp-server lease find mac-address="$bindingmac"]

log warning "Fixando $bindingcomment"

}

log warning "FIM"