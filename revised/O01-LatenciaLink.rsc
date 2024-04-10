########### Altere conforme sua necessidade ################
:local iptest 1.1.1.1
:local latenciAceitavel 20
:local tempoEntrePings 2
:local NumPings 5

########### NÃO ALTERAR DAQUI PARA BAIXO ################

:local msg
:local status
:local oldstatus $status
:local somaLatencia 0
:local somaRecebidos 0 
##################################################

for i from=1 to=$NumPings do={
    /tool flood-ping $iptest size=100 count=1 do={
        :if ($received = 1) do={
            :set somaLatencia ($somaLatencia + $"avg-rtt")
        }
    
        :set somaRecebidos ($somaRecebidos + $received)
    
        }
    
        delay $tempoEntrePings
    }

#################################### AÇOES TOMADA SE HOST ESTIVER FORA DE ALCANCE #############################
:if ($somaRecebidos = 0 ) do={
    :local status "HOST $iptest FORA DE ALCANCE"
    :if ($oldstatus = $status) do={quit} else={

        :log warning $status
        :local identity [/system identity get name]

        :local message "$identity > $status"

        /tool fetch url="https://api.telegram.org/bot6263388304:AAE_avJz2oJgnmqo-ziEw7iRtLITm3gcGW8/sendMessage?chat_id=-979295434&text=$message" keep-result=no

        quit
    }
}

#################################### CALCULA LATENCIA E PERDA DE PACOTES #############################

:local media ($somaLatencia/$somaRecebidos)
:local percaPacotes (100 - (($somaRecebidos * 100) / $NumPings))

:local msg ("Média de PING para o IP $iptest foi de ".[:tostr $media]."ms e PERDA DE PACOTES foi de ". [:tostr $percaPacotes]."%. Foram ".$NumPings." PINGs enviados e ".$somaRecebidos." recebidos.")



#################################### AÇOES TOMADA SE A LATENCIA ESTIVER ABAIXO OU ACIMA DO ESPECIFICADO #############################

:if ($media < $latenciAceitavel ) do={
:local status "LINK OPERA NORMALMENTE =)"

    :local identity [/system identity get name]

    :local message "$identity > $status"

    /tool fetch url="https://api.telegram.org/bot6263388304:AAE_avJz2oJgnmqo-ziEw7iRtLITm3gcGW8/sendMessage?chat_id=-979295434&text=$message" keep-result=no

:if ($oldstatus = $status) do={quit} else={

:log warning $msg
:log warning $status
/system script run envia-email


}
} else={
:local status "HA ALGUM PROBLEMA - LATENCIA MUITO ALTA"

:if ($oldstatus = $status) do={quit} else={


:log error $msg
:log error $status

    :local identity [/system identity get name]

    :local message "$identity > Latencia ALTA no LINK"

    /tool fetch url="https://api.telegram.org/bot6263388304:AAE_avJz2oJgnmqo-ziEw7iRtLITm3gcGW8/sendMessage?chat_id=-979295434&text=$message" keep-result=no

    }

}


##################################################
##
##             Redes Brasil - Especializada em treinamentos de redes.
##
##			www.redesbrasil.com
##
##################################################


########### Altere conforme sua necessidade ################
:global iptest 1.1.1.1
:global latenciAceitavel 20
:global tempoEntrePings 2
:global NumPings 5

##################################################

:global msg
:global status
:global oldstatus $status
:global somaLatencia 0
:global somaRecebidos 0 
##################################################



for i from=1 to=$NumPings do={
/tool flood-ping $iptest size=100 count=1 do={
:if ($received = 1) do={
:set somaLatencia ($somaLatencia + $"avg-rtt")
}
:set somaRecebidos ($somaRecebidos + $received)
}
delay $tempoEntrePings
}

#################################### AÇOES TOMADA SE HOST ESTIVER FORA DE ALCANCE #############################
:if ($somaRecebidos = 0 ) do={
:global status "HOST $iptest FORA DE ALCANCE"
:if ($oldstatus = $status) do={quit} else={


:log warning $status
:global msg 
/system script run envia-email
quit
}
}

#################################### CALCULA LATENCIA E PERDA DE PACOTES #############################

:global media ($somaLatencia/$somaRecebidos)
:global percaPacotes (100 - (($somaRecebidos * 100) / $NumPings))

:global msg ("Média de PING para o IP $iptest foi de ".[:tostr $media]."ms e PERDA DE PACOTES foi de ". [:tostr $percaPacotes]."%. Foram ".$NumPings." PINGs enviados e ".$somaRecebidos." recebidos.")



#################################### AÇOES TOMADA SE A LATENCIA ESTIVER ABAIXO OU ACIMA DO ESPECIFICADO #############################
:if ($media < $latenciAceitavel ) do={
:global status "LINK OPERA NORMALMENTE"
:if ($oldstatus = $status) do={quit} else={



:log warning $msg
:log warning $status
/system script run envia-email


}
} else={
:global status "HA ALGUM PROBLEMA - LATENCIA MUITO ALTA"
:if ($oldstatus = $status) do={quit} else={


:log error $msg
:log error $status
#/system script run "O02-AvisoLatenciaAlta"

:local identity [/system identity get name]

 :local message "$identity > Latencia ALTA no LINK"

  /tool fetch url="https://api.telegram.org/bot6263388304:AAE_avJz2oJgnmqo-ziEw7iRtLITm3gcGW8/sendMessage?chat_id=-979295434&text=$message" keep-result=no

}

}
