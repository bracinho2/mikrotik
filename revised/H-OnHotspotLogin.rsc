### ON HOTSPOT LOGIN ###

    :local identity [/system identity get name]

    :local message "LOGIN on $identity User: $user IP: $address"

    log warning "$message"

    /tool fetch url="https://api.telegram.org/bot6263388304:AAE_avJz2oJgnmqo-ziEw7iRtLITm3gcGW8/sendMessage?chat_id=-979295434&text=$message" keep-result=no

### ON HOTSPOT LOGIN ###