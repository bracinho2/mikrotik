### Configure ###

:local tempThreshold 35;

### End ###

:local currentTemp [/system health get temperature];

:if ($currentTemp > $tempThreshold) do={

        :local identity [/system identity get name]
        
        :local message "$identity > High Temperature: $currentTemp Celsius"

        log warning $message
        
        /tool fetch url="https://api.telegram.org/bot6263388304:AAE_avJz2oJgnmqo-ziEw7iRtLITm3gcGW8/sendMessage?chat_id=-979295434&text=$message" keep-result=no

}

