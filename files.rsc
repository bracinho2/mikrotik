# Fetch Automation File;
/tool fetch url="https://raw.githubusercontent.com/bracinho2/mikrotik/master/automation.txt" mode=https

:if ([:len [/file find name="automation.txt"]] > 0) do={

global serverStatus
global billingStatus

:global content [/file get [/file find name="automation.txt"] contents] ;

:local pos00 [:find $content "var serverStatus="]
:local pos01 [:find $content "var billingStatus="]


:set serverStatus [:pick $content ($pos00 + 17) ($pos01 - 2)]
#:set local [:pick $content ($pos00 + 11) ($pos01 - 4)]

}

#/file remove "automation.txt"

