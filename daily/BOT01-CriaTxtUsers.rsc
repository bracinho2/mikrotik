#:log warning "Creating Users Profiles"

:global identidade [/system identity get name]

foreach h in=[/ip hotspot user find] do={
global user [/ip hotspot user get $h name];

################################
:if ([:len [/file find name="flash/a-hotspot/usuarios/$user.cadastro.txt"]] < 1) do={
################################

global pass [/ip hotspot user get [/ip hotspot user find name="$user"] password]
global profile [/ip hotspot user get [/ip hotspot user find name="$user"] profile]
global mac01 [/ip hotspot user get [/ip hotspot user find name="$user"] mac-address]
global comment [/ip hotspot user get [/ip hotspot user find name="$user"] comment]
global email [/ip hotspot user get [/ip hotspot user find name="$user"] email]

/file print file="flash/a-hotspot/usuarios/$user.cadastro.txt"

#:log warning "Creating *$user* Profile"

:delay 3s

/file set "flash/a-hotspot/usuarios/$user.cadastro.txt" contents="var local=\"$identidade\";
var usuario=\"$user\";
var senha=\"$pass\";
var profile=\"$profile\";
var valor=\"20,00\";
var vencimento=\"10\";
var aviso=\"11\";
var bloqueio=\"13\";
var fim=\"fim!\";
";

:log warning "Profile *$user* Sucessfull Created!"

#:log warning "$user CRIADO!"

}

}

:log warning "FIM de tudo!"