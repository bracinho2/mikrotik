{
  # Mikrotik failover script with dual dhcp interfaces

  # Copyright (C) 2021 Alexandre PIERRET
  #
  # This program is free software: you can redistribute it and/or modify it under
  # the terms of the GNU General Public License as published by the Free Software
  # Foundation, either version 3 of the License, or (at your option) any later
  # version.
  #
  # This program is distributed in the hope that it will be useful, but WITHOUT
  # ANY WARRANTY; without even the implied warranty of  MERCHANTABILITY or FITNESS
  # FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
  #
  # You should have received a copy of the GNU General Public License along with
  # this program.  If not, see <http://www.gnu.org/licenses/>.

  # Changelog:
  # - 2021/08/27: Initial release

  # Features:
  # - main/backup failover with 2 dhcp-client interfaces
  # - rely on multiple remote test hosts to decide if the main link is working properly
  # - automaticaly add/remove required routes to remote test hosts
  # - adjust testHosts routes if the gateway change
  # - configurable "ping success rate expected"
  # - stop pinging testHosts as soon as the expected rate is reached to avoid unnecessary traffic
  # - release DHCP lease in mainInterface on link failure to trigger a renew.
  #   (This is usefull if the provider change the subnet on its side but our DHCP lease is not expired yet)
  # - doesn't need :global variable
  # - doesn't need specific configuration other than using dhcp-client on both main/backup interfaces
  
  # Limitations:
  # - hosts in testHosts array can't be reach through backupInterface if mainInterface receive a DHCP lease
  # - mainInterface and backupInterface must be configured in dhcp-client
  # - Only work with IPv4
  
  # How to use it
  # - Set the mainInterface and the backupInterface variable (dhcp client configuration must exist)
  # - Set the testHosts you want to use as reliable remote host to test connectivity
  # - Upload the script to your router
  # - Schedule it to run every minutes

  # Original testHosts list:
  # - 189.38.95.95 => GIGA DNS
  # - 192.175.48.1 => AS112 - blackhole DNS for RFC1918
  # - 1.0.0.1 => Cloudflare DNS server
  # - 8.8.8.8 => Google DNS server #2
  # - 8.8.4.4 => Google DNS server #2

# :log error "### INICIO DE FAILOVER ###"

  ################################
  ### User variables
  ################################
  # Basic
  :local mainInterface "ether1"; # My FTTH ONU (dhcp)
  :local backupInterface "ether2"; # My LTE modem (dhcp)
  :local testHosts {
    "189.38.95.95";
    "192.175.48.1";
    "1.0.0.1";
    "8.8.8.8";
    "8.8.4.4";
  }
  :local pingPerHost 2; # How many ping per host
  :local pingRateSucessExpected 5; # Success rate expected (in percent)

  # Expert
  :local pingSuccessDelay 100ms; # ping success throttle
  :local mainPromoteRouteDistance 10; # Route distance when mainInterface is promote
  :local backupRouteDistance 20; # Backup interface route distance
  :local mainDemoteRouteDistance 30; # Route distance when mainInterface is demote
  :local routeComment "managed-by-failover-script"; # Comment link to routes added to force testHosts through mainInterface

  ################################
  ### Code
  ################################
  # Remove previously added routes that are no longer in testHosts (based on route comment)
  :foreach managedRoute in=[/ip route find where comment=$routeComment] do={
    :local lPrefix [/ip route get $managedRoute dst-address]
    :local lHost [:pick $lPrefix 0 [:find $lPrefix "/"]]; # Remove ending /32
    # if $lHost not in $testHosts
    :if ([:typeof [:find $testHosts $lHost]]="nil") do={
      /ip route remove $managedRoute;
    }
  }

  # Intenal variables
  :local currentMainRouteDistance [/ip dhcp-client get [/ip dhcp-client find where interface=$mainInterface] default-route-distance];
  :local currentBackupRouteDistance [/ip dhcp-client get [/ip dhcp-client find where interface=$backupInterface] default-route-distance];

  # If required, set the backup default route distance
  :if ($currentBackupRouteDistance != $backupRouteDistance) do={
    /ip dhcp-client set [/ip dhcp-client find where interface=$backupInterface] default-route-distance=$backupRouteDistance;
  }

  # Add/remove more-specific routes to testHosts depending of mainInterface dhcp status and lease
  # If DHCP status is bound:
  #   Remove testHosts routes from previous lease (if any)
  #   Add testHosts /32 routes if not already exist
  # Else (DHCP status not bound):
  #   Remove all testHosts /32 routes
  :local mainGatewayDhcpInfo [:pick [/ip dhcp-client print as-value detail where interface=$mainInterface] 0];
  :local mainGatewayDhcpStatus ($mainGatewayDhcpInfo->"status");
  :local mainGatewayDhcpGatewayIp ($mainGatewayDhcpInfo->"gateway");
  :if ($mainGatewayDhcpStatus = "bound") do={
    :foreach testHost in=$testHosts do={
      :local testHostIp [:tostr ("$testHost"."/32")]; # Generate x.x.x.x/32 str from x.x.x.x
      # Remove route from previous lease (if any)
      /ip route remove [/ip route find where dst-address=$testHostIp and gateway!=[:tostr $mainGatewayDhcpGatewayIp]];
      # Add route if not already exists
      :if ([:len [/ip route find dst-address=$testHostIp]] = 0) do={
        /ip route add dst-address=$testHostIp gateway=[:tostr $mainGatewayDhcpGatewayIp] comment=$routeComment;
      }
    }
  } else={
    # Remove all testHosts /32 routes
    :foreach testHost in=$testHosts do={
      :local testHostIp [:tostr ("$testHost"."/32")];
      /ip route remove [/ip route find where dst-address=[:tostr $testHostIp]];
    }
  }

  # Ping loop, can exit earlier if the sucess rate is reached
  :local pingSuccessCount 0;
  :local pingCount 1;
  :local pingRateSucess 0;
  :while (($pingCount <= $pingPerHost) and ($pingRateSucess < $pingRateSucessExpected)) do={
    :foreach tHost in=$testHosts do={
      :if ([/ping address=$tHost count=1]=1) do={
        :set pingSuccessCount ($pingSuccessCount + 1);
        :delay [:totime $pingSuccessDelay];
      }
    }
    :set pingCount ($pingCount + 1);
    :set pingRateSucess ($pingSuccessCount * 100 / ([:len $testHosts] * $pingPerHost));
  }

  
  :if ($pingRateSucess < $pingRateSucessExpected) do={
    # Demote mainInterface
    :if ($currentMainRouteDistance != $mainDemoteRouteDistance) do={
      /ip dhcp-client set [/ip dhcp-client find where interface=$mainInterface] default-route-distance=$mainDemoteRouteDistance;
      :log error "DETECTED MAIN LINK FAILURE > SWITCHING TO BACKUP LINK =("
      #>>> ADD HERE ACTIONS TO DO ON MAIN LINK FAILURE (email, http call, logging, ...)
    }
    # Release DHCP lease if bound to:
    # - allow the testHosts to be reached through the backupInterface
    # - force a DHCP renew in case of mainInterface subnet has changed on the provider side but our lease is not expired yet
    :if ($mainGatewayDhcpStatus = "bound") do={
      /ip dhcp-client release [/ip dhcp-client find interface=$mainInterface];
    }
  } else={
    # Promote mainInterface
    :if ($currentMainRouteDistance != $mainPromoteRouteDistance) do={
      /ip dhcp-client set [/ip dhcp-client find where interface=$mainInterface] default-route-distance=$mainPromoteRouteDistance;
      :log warning "MAIN LINK BACK ONLINE > SWITCHING BACK TO MAIN LINK =)"
      #>>> ADD HERE ACTIONS TO DO ON MAIN LINK BACK ONLINE (email, http call, logging, ...)
    }
  }
 # :log warning "### FIM DE FAILOVER ###"
}

