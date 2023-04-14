# Fetch Automation File;
/tool fetch url="https://raw.githubusercontent.com/bracinho2/mikrotik/master/automation.txt" mode=https

:if ([:len [/file find name="automation.txt"]] > 0) do={

global serverStatus
global billingStatus

:global content [/file get [/file find name="automation.txt"] contents] ;

:local pos00 [:find $content "var serverStatus="]
:local pos01 [:find $content "var billingStatus="]
:local pos02 [:find $content "var fim="]


:set serverStatus [:pick $content ($pos00 + 17) ($pos01 - 2)]
:set billingStatus [:pick $content ($pos01 + 18) ($pos02 - 2)]

}
if($serverStatus >= 0) do={
    /file remove "automation.txt"
}


