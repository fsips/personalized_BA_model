function [states_list]  = eval_states_list(states) 

for it = 1:length(states)
    if strcmp(states{it}, 'all')
        states_list     = {{'u'}, {'g'}, {'t'}};
    elseif strcmp(states{it}, 'conjugated')
        states_list{it} = {'g', 't'};
    elseif strcmp(states{it}, 'unconjugated')
        states_list{it} = {'u'};
    else
        states_list{it} = states{it};
    end
end