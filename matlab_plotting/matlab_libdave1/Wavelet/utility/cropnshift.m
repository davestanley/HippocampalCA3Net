
function dout = cropnshift (din, rem1, rem2)

siz = size(din);
len = length(din);
rem1 = rem1-1;
rem2 = rem2+1;

doutp1 = din(1:rem1);
doutp2 = din(rem2:len);

avg = (din(rem1) + din(rem2)) / 2;
doutp1 = doutp1 + (avg - din(rem1));
doutp2 = doutp2 + (avg - din(rem2));

if siz(1) == 1
    dout = [doutp1 doutp2];

elseif siz(2) == 1
    dout = [doutp1; doutp2];
else
    dout = 0;
end

end