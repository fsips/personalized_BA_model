function [curr_term] = eval_term(results, tag_fasting, curr_type, curr_tissue, curr_state, equation)

if equation
    if strcmp(curr_tissue{1}, 'pl')
        curr_term       = [' + ', tag_fasting, curr_tissue{1}, '_', curr_state,'_', curr_type, ' * ', tag_fasting, 'V_P' ];
    elseif strcmp(curr_tissue{1}, 'po')
        
        if strcmp(curr_state, 't') || strcmp(curr_state, 'g')
            modified_state = 'c';
        else
            modified_state = curr_state;
        end
        
        curr_term       = [' + ', tag_fasting, 'pl_', curr_state,'_', curr_type, ' + (',tag_fasting,'hep_extr_',modified_state, curr_type,' * (', tag_fasting, 'x_si_',curr_state,'_', curr_type,' + ', tag_fasting, 'x_co_',curr_state,'_', curr_type,')/ ', tag_fasting, 'Q_P)' ];
    else
        curr_term       = [' + ', tag_fasting, curr_tissue{1}, '_', curr_state,'_', curr_type];
    end
else
    if strcmp(curr_tissue{1}, 'pl')
        curr_term        = eval([tag_fasting, curr_tissue{1}, '_', curr_state,'_', curr_type]) * eval([tag_fasting, 'V_P']);
        
    elseif strcmp(curr_tissue{1}, 'po')
        
        if strcmp(curr_state, 't') || strcmp(curr_state, 'g')
            modified_state = 'c';
        else
            modified_state = curr_state;
        end
        
        curr_term        = eval([tag_fasting, 'pl_', curr_state,'_', curr_type]) + eval([tag_fasting, 'hep_extr_',modified_state, curr_type]) * (eval([tag_fasting, 'x_si_',curr_state,'_', curr_type]) + eval([tag_fasting, 'x_co_',curr_state,'_', curr_type]))/ eval([tag_fasting, 'Q_P']);
        
    else
        curr_term        = eval([tag_fasting, curr_tissue{1}, '_', curr_state,'_', curr_type]);
    end
end