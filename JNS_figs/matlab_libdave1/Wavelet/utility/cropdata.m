
function dout = cropdata (din, rem1, rem2)

siz = size(din);
rem1 = rem1-1;
rem2 = rem2+1;

if siz(1) == 1
    dout = [din(1:rem1) din(rem2:siz(2))];
elseif siz(2) == 1
    dout = [din(1:rem1); din(rem2:siz(1))];
else
    dout = 0;
end

end