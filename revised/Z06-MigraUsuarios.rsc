### SEND EMAIL WITH USER DATA ###

:local data [/system clock get date]
:local hora [/system clock get time]
:local identidade [/system identity get name]

log error "### SEND EMAIL WITH USER DATA \n"

log warning "1 > EXPORT FILES"

/ip hotspot ip-binding export file="$identidade.ListaBranca"

/ip hotspot user export file="$identidade.UsuarioSenha"

delay 5s

log warning "2 > SEND WHITE LIST"

tool e-mail send to=bracinho2@hotmail.com subject="$identidade $data $hora" file="$identidade.ListaBranca.rsc" start-tls=yes

delay 5s

log warning "3 > SEND USER DATA \n"

tool e-mail send to=bracinho2@hotmail.com subject="$identidade $data $hora" file="$identidade.UsuarioSenha.rsc" start-tls=yes

delay 10s

log warning "SEND EMAIL WITH USER DATA SUCCESSFULLY FINISHED \n"

/file remove "$identidade.ListaBranca.rsc"
/file remove "$identidade.UsuarioSenha.rsc"

log error "### SEND EMAIL WITH USER DATA \n"
### SEND EMAIL WITH USER DATA ###