### USER DHCP-CLIENT ENTRY CHECK ###

:local identity [/system identity get name]
:global sentMAC

if ($leaseBound=1) do={

    :if ([ :typeof $sentMAC ] = "nothing") do={
    
        :set $sentMAC "$leaseActMAC"
        
        foreach h in=[/ip hotspot ip-binding find] do={
                :local mac [/ip hotspot ip-binding get $h mac-address]

                if ($mac = $sentMAC) do={
                    
                    :local authorized [/ip hotspot ip-binding get [/ip hotspot ip-binding find mac-address=$leaseActMAC] comment]

                    :local message "$identity > Authorized: $authorized IP: $leaseActIP MAC: $leaseActMAC"

                    log warning $message

                     /tool fetch url="https://api.telegram.org/bot6263388304:AAE_avJz2oJgnmqo-ziEw7iRtLITm3gcGW8/sendMessage?chat_id=-979295434&text=$message" keep-result=no

                } 
            }

    } else {

        if ($sentMAC != $leaseActMAC) do={

            :set $sentMAC "$leaseActMAC"
            
            foreach h in=[/ip hotspot ip-binding find] do={
                :local mac [/ip hotspot ip-binding get $h mac-address]

                if ($mac = $sentMAC) do={
                    
                    :local authorized [/ip hotspot ip-binding get [/ip hotspot ip-binding find mac-address=$leaseActMAC] comment]

                    :local message "$identity > Authorized: $authorized IP: $leaseActIP MAC: $leaseActMAC"

                    log warning $message

                     /tool fetch url="https://api.telegram.org/bot6263388304:AAE_avJz2oJgnmqo-ziEw7iRtLITm3gcGW8/sendMessage?chat_id=-979295434&text=$message" keep-result=no

                } 
            }
        }
    }
}

### USER DHCP-CLIENT ENTRY CHECK ###

if ($leaseBound=1) do={
        foreach h in=[/ip hotspot ip-binding find] do={
            :local mac [/ip hotspot ip-binding get $h mac-address]

            if ($mac != $leaseActMAC) do={
                    
                :local authorized [/ip hotspot ip-binding get [/ip hotspot ip-binding find mac-address=$leaseActMAC] comment]

                :local message "$identity > ODD: IP: $leaseActIP MAC: $leaseActMAC"

                log warning $message

                /tool fetch url="https://api.telegram.org/bot6263388304:AAE_avJz2oJgnmqo-ziEw7iRtLITm3gcGW8/sendMessage?chat_id=-979295434&text=$message" keep-result=no

            } 
        }

}