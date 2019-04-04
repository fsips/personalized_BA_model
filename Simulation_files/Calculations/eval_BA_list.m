function [BA_list]  = eval_BA_list(BAs) 

% Create lists of what is in the total pool
if length(BAs) == 1
    if strcmp(BAs{1}, 'all')
        BA_list = {{'CA'}, {'CDCA'}, {'DCA'}, {'UDCA'}, {'LCA'}, {'o'}};
    elseif strcmp(BAs{1}, 'primary')
        BA_list = {{'CA'}, {'CDCA'}};
    elseif strcmp(BAs{1}, 'secondary')
        BA_list = {{'DCA'}, {'UDCA'}, {'LCA'}, {'o'}};
    else
        BA_list = BAs;
    end
else
    BA_list = BAs;
end
