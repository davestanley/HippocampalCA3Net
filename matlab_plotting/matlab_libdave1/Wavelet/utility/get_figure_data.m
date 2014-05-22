

function [x y u l] = get_figure_data ()

    h = get(gca, 'Children');
    
    x={}; y={}; u={}; l={};
    for i = 1:length(h)
        temp = get(h(i));
        if isfield (temp,'XData'); x{i}=temp.XData(:); end
        if isfield (temp,'YData'); y{i}=temp.YData(:); end
        if isfield (temp,'UData'); u{i}=temp.UData(:); end
        if isfield (temp,'LData'); l{i}=temp.LData(:); end 
    end
end
