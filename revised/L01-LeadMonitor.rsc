:log warning "*LEAD MONITOR*"

/tool netwatch remove [find]

delay 2s

foreach h in=[/ip dhcp-server lease find] do={

    local ip [/ip dhcp-server lease get $h active-address]
    local host [/ip dhcp-server lease get $h host-name]

    /tool netwatch add host=$ip comment=$host up-script="log warning \"$host UP\"" down-script="log warning \"$host DOWN\""

    log warning ("RouterWatchDog> " . $ip . " - ". $host)

}

:log warning "*LEAD MONITOR*"

/tool netwatch remove [/tool netwatch find comment="LEAD"]

delay 2s

foreach h in=[/ip hotspot ip-binding find] do={

    local ip [/ip hotspot ip-binding get $h address]

    local comment [/ip hotspot ip-binding get $h comment]

    /tool netwatch add host=$ip comment=$comment up-script="log warning \"$host UP\"" down-script="log warning \"$host DOWN\""

    log warning ("RouterWatchDog> " . $ip . " - ". $comment)

}

 