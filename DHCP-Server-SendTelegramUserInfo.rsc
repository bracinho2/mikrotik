
if ($leaseBound=1) do={

    foreach h in=[/ip hotspot ip-binding find] do={
        :global mac [/ip hotspot ip-binding get $h mac-address]

        if ($mac = $leaseActMAC) do={

            :local identity [/system identity get name]
            
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
        } else={
            :local identity [/system identity get name]
    
            delay 20s

            :foreach h in=[/ip hotspot active find] do={
                :local address [/ ip hotspot active get $h address];
                :local user [/ip hotspot active get $h user];
                :local mac [/ip hotspot active get $h mac-address];

                if ($mac = $leaseActMAC) do={
                    
                    :local message "$identity > LoggedIn: $user IP: $leaseActIP MAC: $leaseActMAC"

                    log warning $message

                    /system script run T01-CallTelegramFunction
                    {
                            :global TelegramSend
                            $TelegramSend $message
                    }
                    
                    delay 10s
                    /system script environment remove [find name="TelegramSend"]

                }
            }
        }
    }
    #log error "Salte Fora"
}



## Teste

:global CheckMAC do={
    :local message "$1"
    :log warning $message
}

/system script run CheckMAC
{
    :global CheckMAC
    :local message "My Message =)"
    $CheckMAC $message
}
 



:global z; 
:if ([ :typeof $z ] = "nothing") do={
    :put "hello world";}



if ($leaseBound=1) do={
    :local newMacValue

    # 1. Verifica se a variavel "oldMacValue" existe;
    :global hasOldMacValue

    foreach h in=[/system script environment find] do={
        :local variableName [/system script environment get $h name]
        log error $variableName
        
        if ($variableName != "oldMacValue") do={
            set $hasOldMacValue false
        } else={
            set $hasOldMacValue true
        }
    }
    
    # 2. Cria a variavel "oldMacValue" se ela nao existe;

    if ($hasOldMacValue = false) do={
        :global oldMacValue "meuMAC"
        log warning "Primeiro MAC $oldMacValue"
    }

    # 3. Verifica o valor da variavel "oldMacValue"

    if($oldMacValue !=leaseActMAC) do={
        log warning "Entrou um MAC diferente $leaseActMAC"
    }

    log error "Old MAC $oldMacValue > New MAC: $leaseActMAC"
}



 #se oldMacValue estiver vazio recebe o MAC que entrou;

    :if ([ :typeof $oldMacValue ] = "nothing") do={

       :global oldMacValue $leaseActMAC

        log warning "Primeiro MAC $oldMacValue"

    } else={
    
    #se oldMacValue possuir valor compara com o valor que entrou;    

        foreach h in=[/system script environment find] do={
        :local oldMacValue [/system script environment get $h value]

            if ($oldMacValue != $leaseActMAC) do={
                set $newMacValue $leaseActMAC
            } 
        }
    }