function [tissue_list]  = eval_tissue_list(tissues) 

if length(tissues) == 1
    if strcmp(tissues{1}, 'all')
        tissue_list = {'li', 'gb', 'si1', 'si2', 'si3', 'si4', 'si5', 'si6', 'si7', 'si8', 'si9', 'si10', 'co1', 'co2', 'co3', 'co4', 'co5', 'pl'};
    elseif strcmp(tissues{1}, 'si')
        tissue_list = {'si1', 'si2', 'si3', 'si4', 'si5', 'si6', 'si7', 'si8', 'si9', 'si10'};
    elseif strcmp(tissues{1}, 'co')
        tissue_list = {'co1', 'co2', 'co3', 'co4', 'co5'};
    else
        tissue_list = tissues;
    end
else
    tissue_list = tissues;
end