if ($leaseBound=1) do={

    # Verifica se a variavel "oldMacValue" existe;
    :local identity [/system identity get name]
    :global oldMacValue
    :global sentMac

    :if ([ :typeof $oldMacValue ] = "nothing") do={
    
        :set $oldMacValue "$leaseActMAC"
        :log warning "$identity CachedMAC: $oldMacValue"
        
    }

    # Verifica o valor da variavel "oldMacValue"

    if ($oldMacValue != $leaseActMAC) do={
        
        :set $oldMacValue "$leaseActMAC"
        #:log warning "$identity NewMAC: $leaseActMAC"

        :if ([ :typeof $sentMac ] = "nothing") do={
            :set $sentMac "$oldMacValue"

           :local message "$identity Primeiro Aviso: NewMAC: $leaseActMAC"

            log warning $message

                    /system script run T01-CallTelegramFunction
                    {
                            :global TelegramSend
                            $TelegramSend $message
                    }
                    
                    delay 5s
                    /system script environment remove [find name="TelegramSend"]
        }

        if ($sentMac != $leaseActMAC) do={

            foreach h in=[/ip hotspot ip-binding find] do={
                :global mac [/ip hotspot ip-binding get $h mac-address]

                if ($mac = $leaseActMAC) do={
                    
                    :global authorized [/ip hotspot ip-binding get [/ip hotspot ip-binding find mac-address=$leaseActMAC] comment]

                    :local message "$identity > Authorized: $authorized IP: $leaseActIP MAC: $leaseActMAC"

                    log warning $message

                    /system script run T01-CallTelegramFunction
                        {
                            :global TelegramSend
                            $TelegramSend $message
                        }

                    delay 10s
                    
                    /system script environment remove [find name="TelegramSend"]
                    
                    /system script environment remove [find name="mac"]
                    
                    /system script environment remove [find name="authorized"]

                } 
            }

        } else {
            log warning "outro caso"
        }
        :set $sentMac "$leaseActMAC"
    }
}