log warning "Configurando os perfis de usuario..."

delay 3s

/ip hotspot user profile
set [ find default=yes ] name=Basic shared-users=2 keepalive-timeout=03:00:00

add keepalive-timeout=1h name=atraso shared-users=2

add advertise=yes advertise-interval=0s advertise-timeout=immediately advertise-url=/bloqueio.html keepalive-timeout=1m name=bloqueio shared-users=2 status-autorefresh=30s transparent-proxy=yes

/log warning "Perfis de usuario Basic-Atraso-Bloqueio Configurados com sucesso"