:log warning "Creating Users Profiles"

:local identidade [/system identity get name]

foreach h in=[/ip hotspot user find] do={
:local user [/ip hotspot user get $h name];

################################
:if ([:len [/file find name="flash/hotspot/usuarios/$user.cadastro.txt"]] < 1) do={
################################

:local pass [/ip hotspot user get [/ip hotspot user find name="$user"] password]
:local profile [/ip hotspot user get [/ip hotspot user find name="$user"] profile]
:local mac01 [/ip hotspot user get [/ip hotspot user find name="$user"] mac-address]
:local comment [/ip hotspot user get [/ip hotspot user find name="$user"] comment]
:local email [/ip hotspot user get [/ip hotspot user find name="$user"] email]

/file print file="flash/hotspot/usuarios/$user.cadastro.txt"

#:log warning "Creating *$user* Profile"

:delay 3s

/file set "flash/hotspot/usuarios/$user.cadastro.txt" contents="var local=\"$identidade\";
var usuario=\"$user\";
var senha=\"$pass\";
var profile=\"$profile\";
var valor=\"50,00\";
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