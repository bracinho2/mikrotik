# Fetch Automation File;
/tool fetch url="https://github.com/bracinho2/mikrotik/blob/master/automation.txt" mode=http

:local content [/file get [/file find name="automation.txt"] contents] ;

:global serverStatus
:global billingStatus

:local serverStatus [:find $content "var serverStatus="]
:local pos01 [:find $content "var billingStatus="]


:set inicio [:pick $content ($pos00 + 11) ($pos01 - 4)]
:set billingStatus [:pick $content ($pos00 + 11) ($pos01 - 4)]

# Delete Automation File;
#/file remove "automation.txt"

