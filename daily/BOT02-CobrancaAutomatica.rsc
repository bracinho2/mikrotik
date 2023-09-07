:log warning "*COBRANCA AUTOMATICA*"
:log warning "Verifing Remote Config..."

if ($billing = 1) do={
   :log warning "Enabled!"

    global data [/system clock get date] 
    global dia [ :pick $data 4 6 ]
    #global dia "12"

    :log error "Hoje eh $dia"

    :foreach h in=[/ip hotspot user find] do={

        :global user [/ip hotspot user get $h name]
        :global comment [/ip hotspot user get [/ip hotspot user find name=$user] comment]

    :if ([:len [/file find name="flash/a-hotspot/usuarios/$user.cadastro.txt"]] > 0) do={

        #:log warning "Lendo Cadastro de $user..."

        :global inicio
        :global local
        :global usuario
        :global senha
        :global plano
        :global valor
        :global vencimento
        :global atraso
        :global bloqueio
        :global fim


        :local content [/file get [/file find name="flash/a-hotspot/usuarios/$user.cadastro.txt"] contents] ;

        :local pos00 [:find $content "var local="]
        :local pos01 [:find $content "var usuario="]
        :local pos02 [:find $content "var senha="]
        :local pos03 [:find $content "var profile="]
        :local pos04 [:find $content "var valor="]
        :local pos05 [:find $content "var vencimento="]
        :local pos06 [:find $content "var aviso="]
        :local pos07 [:find $content "var bloqueio="]
        :local pos08 [:find $content "var fim="]

        :set inicio [:pick $content ($pos00 + 11) ($pos01 - 4)]
        :set local [:pick $content ($pos00 + 11) ($pos01 - 4)]
        :set usuario [:pick $content ($pos01 + 13) ($pos02 - 4)]
        :set senha [:pick $content ($pos02 + 11) ($pos03 - 4)]
        :set plano [:pick $content ($pos03 + 13) ($pos04 - 4)]
        :set valor [:pick $content ($pos04 + 11) ($pos05 - 4)]
        :set vencimento [:pick $content ($pos05 + 16) ($pos06 - 4)]
        :set atraso [:pick $content ($pos06 + 11) ($pos07 - 4)]
        :set bloqueio [:pick $content ($pos07 + 14) ($pos08 - 4)]


        #log error "Verifica bloqueio: $user y $comment y $plano"

        log error "Hoje eh dia $dia | Dia de bloqueio de $user eh $bloqueio"

if ($comment = "Deve") do={

    global servidor  [/system identity get name]

    #/tool e-mail send to=bracinho2@hotmail.com subject="$servidor | $user -> BOLETO" body="Usuario: $user\r\n*Enviar o Boleto.\r\n**Nao Esquecer de pedir comprovante.\r\n***Nao esquecer de informar o pagamento no sistema.\r\n"

    log error "Hoje eh dia $dia | Dia de bloqueio de $user eh $bloqueio"

if ($dia = $bloqueio) do={

    /ip hotspot user set "$user" profile=bloqueio

    /ip hotspot ip-binding set [/ip hotspot ip-binding find comment="$user.pc"] disable=yes
    /ip hotspot ip-binding set [/ip hotspot ip-binding find comment="$user.cell"] disable=yes
    /ip hotspot ip-binding set [/ip hotspot ip-binding find comment="$user.tv"] disable=yes

    log error "$usuario foi comunicado (a) de BLOQUEIO!"

    delay 2s

    /ip hotspot user set [/ip hotspot user find profile=bloqueio] comment="Bloqueado"

}

}

}
}


log error "Amem ==)"

} else {
    :log warning "Disabled!"
}

