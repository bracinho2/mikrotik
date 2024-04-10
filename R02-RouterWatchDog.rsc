:log warning "*ROUTER WATCHDOG*"

/tool netwatch remove [find]

delay 2s

foreach h in=[/ip dhcp-server lease find] do={

    local ip [/ip dhcp-server lease get $h active-address]
    local host [/ip dhcp-server lease get $h host-name]

    /tool netwatch add host=$ip comment=$host up-script="log warning \"$host UP\"" down-script="log warning \"$host DOWN\""

    log warning ("RouterWatchDog> " . $ip . " - ". $host)

}

:log warning "*ROUTER WATCHDOG*"