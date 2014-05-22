
ilist = [];
jlist = [];
for i = 1:48
    for j=1:8
        temp = sim{i}.time{j}.EC_val;
        if temp == -10
            ilist = [ilist i];
            jlist = [jlist j];
        end
    end
end


loop1vals = [-0.04 -0.08 -0.12 -0.16 -0.20 -0.24];  % We absolute value these later ...just incase
loop2vals = [0 2 3 4 5 6 8 10];                   % We absolute value these later ...just incase



ilist = [];
jlist = [];
badloop1vals=[];
badloop2vals=[];
badtime = [];
i = 0;
for loop1 = loop1range
    for loop2 = loop2range
        i = i + 1;
        for j = 1:8
            temp = sim{i}.time{j}.EC_val;
            if temp == -10
                ilist = [ilist i];
                jlist = [jlist j];
                badloop1vals = [badloop1vals loop1vals(loop1)];
                badloop2vals = [badloop2vals loop2vals(loop2)];
                badtime = [badtime j];
            end
        end
    end
end

badloops = [ilist(:) badloop1vals(:) badloop2vals(:) badtime(:)];