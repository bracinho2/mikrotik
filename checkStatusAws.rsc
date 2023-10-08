:global statusAWS

/interface pptp-client monitor [/interface pptp-client find name="aws"] once do={ :set statusAWS $status }

log warning "$statusAWS"

if ($statusAWS != "connected") do={

    /interface pptp-client set [/interface pptp-client find name="aws"] password="chamame" user="chamame"

     /interface pptp-client set [/interface pptp-client find name="aws"]
}