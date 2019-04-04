function [o, L, ss] = generate_states(c, add_cum)

%% Necessary information for model-building
BAs         = c.BAs;
states      = c.states;
tissues     = c.tissues;

%% Assign state numbers
state_num   = 0;

for curr_tissue = tissues 
    for curr_state = states
        for curr_BA = BAs
            state_num = state_num+1;
            o{state_num} = ([curr_tissue{1}, '_', curr_state{1}, '_',curr_BA{1}]);

            if ~strcmp(curr_tissue{1}, 'fa')
                ss(state_num) = 1;
            else
                ss(state_num) = 0;
            end
            
        end
    end
end

if add_cum
    state_num = state_num+1;
    o{state_num} = (['cum_secreted_BA']);
    ss(state_num) = 0;
    
    state_num = state_num+1;
    o{state_num} = (['cum_colon_BA']);
    ss(state_num) = 0;
    
    state_num = state_num+1;
    o{state_num} = (['cum_excreted_BA']);
    ss(state_num) = 0;
end

L = state_num;
