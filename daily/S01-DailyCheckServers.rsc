log warning "Daily Check Servers ;)"

:global servers {
    "Augusto"=79.79.79.2;
    "Aqualux"=83.83.83.2;
    "Sandra"=85.85.85.2;
    "422"=88.88.88.2;
    "KitsRIO"=90.90.90.2;
    "Dinda"=92.92.92.2;
    "Yellow"=93.93.93.2;
    "Itapema"=94.94.94.2;
    "RU"=95.95.95.2;
    "Ecologica"=96.96.96.2;
    "Judite"=97.97.97.2;
    "Unimorada"=98.98.98.2;
    "Cecilia"=102.102.102.2;
    }

:global results;

:foreach s,i in=$servers do={

    :local result [/ping $i count=3]
  
    :if ($result > 0) do={

        log warning "$s is Online =)"

    } else={
        local message "$s is OFFLINE"
        log warning $message;
        
        /tool fetch url="https://api.telegram.org/bot6263388304:AAE_avJz2oJgnmqo-ziEw7iRtLITm3gcGW8/sendMessage?chat_id=-979295434&text=$message" keep-result=no
    }
}