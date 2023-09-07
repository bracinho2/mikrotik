:global data [/system clock get date]
:global hora [/system clock get time]
:global identidade [/system identity get name]

log warning "Exportar Lista Branca..."

/ip hotspot ip-binding export file="$identidade.ListaBranca"

delay 5s

log warning "Exportar Usuarios + Senhas..."

/ip hotspot user export file="$identidade.UsuarioSenha"

delay 5s

log warning "Enviando email..."

tool e-mail send to=bracinho2@hotmail.com subject="$identidade - ListaBranca - $data $hora" file="$identidade.ListaBranca.rsc" start-tls=yes

delay 5s 

tool e-mail send to=bracinho2@hotmail.com subject="$identidade - Usuario&Senha - $data $hora" file="$identidade.UsuarioSenha.rsc" start-tls=yes

delay 5s

log error "ENVIO DE LISTA BRANCA + USUARIOS E SENHAS REALIZADO."

log warning "Email enviado!"

delay 5s

/file remove "$identidade.ListaBranca.rsc"
/file remove "$identidade.UsuarioSenha.rsc"