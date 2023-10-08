log error "Inicializing Remote Config Automation"

/tool fetch url="https://raw.githubusercontent.com/bracinho2/mikrotik/master/automation.txt"

delay 5s

:local hotspot
:local billing
:local update

:if ([:len [/file find name="automation.txt"]] > 0) do={

:local content [/file get [/file find name="automation.txt"] contents] ;

:local pos00 [:find $content "var hotspot="]
:local pos01 [:find $content "var billing="]
:local pos02 [:find $content "var update="]
:local pos03 [:find $content "var fim="]

:set hotspot [:pick $content ($pos00 + 12) ($pos01 - 1)]
:set billing [:pick $content ($pos01 + 12) ($pos02 - 1)]
:set update [:pick $content ($pos02 + 11) ($pos03 - 1)]

}

#enable/disable hotspot
log warning "Running Hotspot Check Online/Offline..."
if ($hotspot = 1) do={
    /ip hotspot enable  "hotspot"
} else {
    /ip hotspot disable "hotspot"
}

#automatic billing
log warning "Running Billing..."
if ($billing = 1) do={
    /system script run "BOT02-CobrancaAutomatica"
}

#update
log warning "Running Update Check..."
if ($update = 1) do={
    /system script run "Z03-AutoUpgrade"
}


delay 5s
file remove "automation.txt"

log error "Remote Config Successfully Finished"