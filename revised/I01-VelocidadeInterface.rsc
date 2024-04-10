log warning "*DAILY CABLE CHECK*"

:foreach i in=[ /interface ethernet find] do={
    :local intname [ / interface ethernet get $i name ];
    :local intComment [/interface ethernet get $i comment];

        :if ([/interface ethernet get $intname running]=true) do={   
            :log warning ($intComment . " on " . $intname . " ONLINE");
        } else={
            :log warning ($intComment . " on " . $intname . " OFFLINE");
        }
};

:local interfaceStatus

    :foreach i in=[ /interface ethernet find running] do={
        :local intname [ / interface ethernet get $i name ];

        /interface ethernet monitor $intname once do={ :set interfaceStatus $rate }

             :if ($interfaceStatus = "10Mbps") do={

                :local identity [/system identity get name]
                :local message "$identity -> CABO QUEBRADO NA $intname!"

                    :log error $message
                        
                    /tool fetch url="https://api.telegram.org/bot6263388304:AAE_avJz2oJgnmqo-ziEw7iRtLITm3gcGW8/sendMessage?chat_id=-979295434&text=$message" keep-result=no

             } 
    }

:log warning "*DAILY CABLE CHECK*"