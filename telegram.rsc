
https://api.telegram.org/bot6263388304:AAE_avJz2oJgnmqo-ziEw7iRtLITm3gcGW8/sendMessage?chat_id=-979295434&text=MensagemTeste"



#Script Telegram 01
#T01-CallTelegramFunction

:global TelegramSend do={
  :local tgBotToken "6263388304:AAE_avJz2oJgnmqo-ziEw7iRtLITm3gcGW8"
  :local tgGroupId "-979295434"
  :local tgMessage "$1"
  :local tgUrl ("https://api.telegram.org/bot".$tgBotToken."/sendMessage\?chat_id=".$tgGroupId."&text=".$tgMessage)
  /tool fetch url="$tgUrl" keep-result=no
}

#T02-SendTelegramMessage

/system script run T01-CallTelegramFunction
 {
  :global TelegramSend
  :local message "My Message =)"
  $TelegramSend $message
}
 


if ($leaseBound=1) do={
   :local message "IP:$leaseActIP MAC: $leaseActMAC"
   :foreach h in=[/ip hotspot active find] do={
        :local address [/ ip hotspot active get $h address];
        :local user [/ip hotspot active get $h user];
        :local mac [/ip hotspot active get $h mac-address];
        /ip hotspot user set $user;
        log error "$user $mac"

        if ($mac = $leaseActMAC) do={
          log error "$user"
          log error "achou"

        } else {
          log error "nao deu certo"
        }
      }
}


#DHCP > envia ip e mac de quem loga no bot EXAMPLE
if ($leaseBound=1) do={

:local identity [/system identity get name]

log error "$identity > USER: $user IP: $leaseActIP MAC: $leaseActMAC"

  /system script run T01-CallTelegramFunction
    {
      :global TelegramSend
        :local message "$identity > USER: $user IP: $leaseActIP MAC: $leaseActMAC"
        $TelegramSend  $message
    }
}

#DHCP Lease > Lease Script!
if ($leaseBound=1) do={
   :local identity [/system identity get name]

   :foreach h in=[/ip hotspot active find] do={
        :local address [/ ip hotspot active get $h address];
        :local user [/ip hotspot active get $h user];
        :local mac [/ip hotspot active get $h mac-address];
        /ip hotspot user set $user;

        if ($mac = $leaseActMAC) do={
        :local message "$identity > LoggedIn: $user IP: $leaseActIP MAC: $leaseActMAC"

        #prompt
        log warning $message
        #Telegram
        /tool fetch url="https://api.telegram.org/bot6263388304:AAE_avJz2oJgnmqo-ziEw7iRtLITm3gcGW8/sendMessage?chat_id=-979295434&text=oioi" keep-result=no

        } else {
       :local authorized [/ip hotspot ip-binding get [/ip hotspot ip-binding find mac-address=$leaseActMAC] comment]
       :local message "$identity > Authorized: $authorized IP: $leaseActIP MAC: $leaseActMAC"

        #prompt
        log warning $message
        #Telegram
         /tool fetch url="https://api.telegram.org/bot6263388304:AAE_avJz2oJgnmqo-ziEw7iRtLITm3gcGW8/sendMessage?chat_id=-979295434&text=$message" keep-result=no
        }
    }
}


 /ip hotspot ip-binding set [/ip hotspot ip-binding find mac-address=CC:32:E5:AC:B7:05] disabled=yes

 :global comment [/ip hotspot ip-binding get [/ip hotspot ip-binding find mac-address=$leaseActMAC] comment]


if ($leaseBound=1) do={

  delay 60s

  :local identity [/system identity get name]

  :foreach h in=[/ip hotspot active find] do={
    :local address [/ ip hotspot active get $h address];
    :local user [/ip hotspot active get $h user];
    :local mac [/ip hotspot active get $h mac-address];

      if ($leaseActMAC = $mac) do={
       
        :local message "$identity > LoggedIn: $user IP: $address MAC: $mac"

        log error $message

        /tool fetch url="https://api.telegram.org/bot6263388304:AAE_avJz2oJgnmqo-ziEw7iRtLITm3gcGW8/sendMessage?chat_id=-979295434&text=$message" keep-result=no

      } else {
        :local authorized [/ip hotspot ip-binding get [/ip hotspot ip-binding find mac-address=$leaseActMAC] comment]
       
        :local message "$identity > Authorized: $authorized IP: $leaseActIP MAC: $leaseActMAC"

        #prompt
        log warning $message
        
        #Telegram
         /tool fetch url="https://api.telegram.org/bot6263388304:AAE_avJz2oJgnmqo-ziEw7iRtLITm3gcGW8/sendMessage?chat_id=-979295434&text=$message" keep-result=no
      }
  }
}

if ($leaseBound=0) do={

  :local identity [/system identity get name]
   :local message "$identity > IP: $leaseActIP MAC: $leaseActMAC LOGGOUT"
  
  log error "alguem foi embora =)"
}