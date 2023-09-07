/tool fetch url="https://raw.githubusercontent.com/bracinho2/mikrotik/master/automation.txt"

delay 5s

:global hotspot
:global billing
:global update

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

#automatic billing
if ($billing = 1) do={
    /system script run "BOT02-CobrancaAutomatica"
}

#enable/disable hotspot
if ($hotspot = 1) do={
    /ip hotspot enable  "hotspot1"
} else {
    /ip hotspot disable "hotspot1"
}

#update
if ($update = 1) do={
    /system script run "Z03-AutoUpgrade"
}


delay 5s
file remove "automation.txt"