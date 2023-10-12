:foreach i in=[ /interface ethernet find] do={
:local intname [ / interface ethernet get $i name ];

    :if ([/interface ethernet get $intname running]=true) do={   
        :log warning ($intname . " ONLINE");
    } else={
        :log error ($intname . " NO-LINK");
    }
};

