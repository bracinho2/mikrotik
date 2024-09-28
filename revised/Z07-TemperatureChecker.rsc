:local TempThreshold 35;

:local CurrentTemp [/system health get temperature];

 :if ($CurrentTemp > $TempThreshold) do={

    log warning "### MIKROTIK TEMPERATURE ###"

    :local AlertMessage "High Temperature: $CurrentTemp Celsius";
    :log error $AlertMessage;
}

