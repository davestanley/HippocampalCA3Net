

function cellname = cellnum_to_name(cellnum)

    if cellnum==1
        cellname='b';
    elseif cellnum==2
        cellname='msg';
    elseif cellnum==3
        cellname='olm';
    elseif cellnum==4
        cellname='psoma';
    elseif cellnum==5
        cellname='efield';
    else
        cellname='unknown';
    end

end

