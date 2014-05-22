
function dt = get_dt (os, i)
    if i == 5
        dt = os.dt2;
    elseif i < 5
        dt = os.dt;
    else
        fprintf('Unknown cell number. Returning null \n');
        dt = -1;
    end
end