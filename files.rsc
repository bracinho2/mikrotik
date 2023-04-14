# Fetch Automation File;
/tool fetch url="https://raw.githubusercontent.com/bracinho2/mikrotik/master/automation.txt" mode=https

delay 5s

:if ([:len [/file find name="automation.txt"]] > 0) do={

global hotspot
global billing
global update

:global content [/file get [/file find name="automation.txt"] contents] ;

:local pos00 [:find $content "var hotspot="]
:local pos01 [:find $content "var billing="]
:local pos02 [:find $content "var update="]
:local pos03 [:find $content "var fim="]

:set hotspot [:pick $content ($pos00 + 12) ($pos01 - 1)]
:set billing [:pick $content ($pos01 + 12) ($pos02 - 1)]
:set update [:pick $content ($pos02 + 11) ($pos03 - 1)]

}