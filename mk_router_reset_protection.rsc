# Mikrotik Router Reset Protection
# Alerta sobre possivel reset do cliente ou reset por surto elétrico
# Avisa e bloqueia no IP-Bindings para evitar acesso indevido à rede

    log error "MONITOR DE RESET -> ATIVADO"

# Defina sua lista de nomes padrao dos hosts
# Utilize aspas duplas e ponto-e-virgula

:global routerList ({

    "TL-WR849N";
    "A10C";
    "Archer_C20";

});

### NAO ALTERE O CODIGO ABAIXO ###

for i from=0 to=([:len $routerList] -1) do={

    local host ([:pick $routerList $i])

    log warning "CHECK: $host"

        :foreach i in=[/ip dhcp-server lease find] do={


            local mac [/ip dhcp-server lease get $i mac-address]

            local hostname [/ip dhcp-server lease get [/ip dhcp-server lease find mac-address="$mac"] host-name]

            local ip [/ip dhcp-server lease get $i address]


                #log error "Dados do Visitante: IP: $hostname e MAC: $mac"


            :if ($hostname = $host) do={

                log error "PERIGO: $host RESETADO -> $ip & $mac"

                :local data [/system clock get date]
                :local hora [/system clock get time]
                :local identidade [/system identity get name]

                /tool e-mail send to=bracinho2@hotmail.com subject="$identidade: RESET ROTEADOR" body="Dados:\r\nLocal: $identidade\r\nData: $data\r\nHora: $hora\r\nIP: $ip\r\nMAC: $mac\r\n"

            } else={

            #log warning "ROUTER $host: NORMAL"
            
        }

    }

}

log warning "MONITOR DE RESET -> DESATIVADO"
