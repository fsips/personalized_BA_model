function [filename] = generate_var(tag, folder, c, p, o, L, c_loc, p_loc, depen)

% File is divided into following sections:
% A. Retrieve parameters, concentrations needed for calculations
% B. Calculate GI-reflex variables
% C. Calculate metabolic fluxes
% D. Calculate additional variables

is_full = sum(strcmp('li', c.tissues));

%% File preparation and header
if is_full
    filename        = [tag, '_var_full'];
else
    filename        = [tag, '_var_tran'];
end
f               = fopen([folder, filename, '.m'], 'w');
prefix          = 'v.';

fprintf(f, ['function [v] = ', filename, '(t, x, p, u)\n']);
fprintf(f, ['\n']);

generate_body(f, prefix, c, p, o, L, c_loc, p_loc, depen, 0);

fprintf(f, ['%% E.1  Diagnostic variables \n']);
fprintf(f, ['\n']);

fprintf(f, ['%% Passive and active uptake \n']);

if is_full % Only in full model
    fprintf(f, ['v.pu = 0; \n']);
    for curr_state = c.states
        for curr_BA = c.BAs
            for curr_si = 1:c.num_si
                fprintf(f, ['v.pu = v.pu + v.si', num2str(curr_si), '_pu_', curr_state{1}, '_',curr_BA{1}, ';\n']);
            end
        end
    end
    
    fprintf(f, ['v.asbt = 0; \n']);
    si_comp = 1:c.num_si;
    si_asbt = cell2mat(c.si_asbt);
    asbt_si = si_comp(si_asbt==1);
    for curr_state = c.states
        for curr_BA = c.BAs
            for curr_si = asbt_si
                fprintf(f, ['v.asbt = v.asbt + v.si', num2str(curr_si), '_au_', curr_state{1}, '_',curr_BA{1}, ';\n']);
            end
        end
    end
    
end % End of - only in full model

fprintf(f, ['%% Pool \n']);

fprintf(f, ['v.pool = 0; \n']);

for curr_state = c.states
    fprintf(f, ['v.pool_state_',curr_state{1},' = 0; \n']);
    fprintf(f, ['v.plco_state_',curr_state{1},' = 0; \n']);
end

for curr_tissue = c.tissues
    fprintf(f, ['v.pool_tissue_',curr_tissue{1},' = 0; \n']);
end

for curr_BA = c.BAs
    fprintf(f, ['v.pool_BA_',curr_BA{1},' = 0; \n']);
    fprintf(f, ['v.plco_BA_',curr_BA{1},' = 0; \n']);
    
    fprintf(f, ['v.pool_si_',curr_BA{1},' = 0; \n']);
    fprintf(f, ['v.pool_co_',curr_BA{1},' = 0; \n']);
end

fprintf(f, ['v.pool_si = 0; \n']);
fprintf(f, ['v.pool_co = 0; \n']);

for curr_state = c.states
    for curr_BA = c.BAs
        for curr_tissue = c.tissues
            if ~strcmp(curr_tissue{1}, 'fa')
                if strcmp(curr_tissue{1}, 'pl')
                    fprintf(f, ['v.pool = v.pool + v.', curr_tissue{1}, '_', curr_state{1}, '_',curr_BA{1}, ' * v.V_P;\n']);
                    fprintf(f, ['v.pool_state_',curr_state{1},  ' = v.pool_state_' ,curr_state{1},  ' + v.', curr_tissue{1}, '_', curr_state{1}, '_',curr_BA{1}, ' * v.V_P;\n']);
                    fprintf(f, ['v.pool_tissue_',curr_tissue{1},' = v.pool_tissue_',curr_tissue{1}, ' + v.', curr_tissue{1}, '_', curr_state{1}, '_',curr_BA{1}, ' * v.V_P;\n']);
                    fprintf(f, ['v.pool_BA_',curr_BA{1},        ' = v.pool_BA_',curr_BA{1},         ' + v.', curr_tissue{1}, '_', curr_state{1}, '_',curr_BA{1}, ' * v.V_P;\n']);
                    
                    fprintf(f, ['v.plco_BA_',curr_BA{1},        ' = v.plco_BA_',curr_BA{1},         ' + v.', curr_tissue{1}, '_', curr_state{1}, '_',curr_BA{1}, ';\n']);
                    fprintf(f, ['v.plco_state_',curr_state{1},  ' = v.plco_state_',curr_state{1},         ' + v.', curr_tissue{1}, '_', curr_state{1}, '_',curr_BA{1}, ';\n']);
                else
                    fprintf(f, ['v.pool = v.pool + v.', curr_tissue{1}, '_', curr_state{1}, '_',curr_BA{1}, ';\n']);
                    fprintf(f, ['v.pool_state_',curr_state{1},  ' = v.pool_state_' ,curr_state{1},  ' + v.', curr_tissue{1}, '_', curr_state{1}, '_',curr_BA{1}, ';\n']);
                    fprintf(f, ['v.pool_tissue_',curr_tissue{1},' = v.pool_tissue_',curr_tissue{1}, ' + v.', curr_tissue{1}, '_', curr_state{1}, '_',curr_BA{1}, ';\n']);
                    fprintf(f, ['v.pool_BA_',curr_BA{1},        ' = v.pool_BA_',curr_BA{1},         ' + v.', curr_tissue{1}, '_', curr_state{1}, '_',curr_BA{1}, ';\n']);
                end
                
                if strcmp(curr_tissue{1}(1:2), 'si')
                    fprintf(f, ['v.pool_si_',curr_BA{1},        ' = v.pool_si_',curr_BA{1},        ' + v.', curr_tissue{1}, '_', curr_state{1}, '_',curr_BA{1}, ';\n']);
                    fprintf(f, ['v.pool_si = v.pool_si + v.', curr_tissue{1}, '_', curr_state{1}, '_',curr_BA{1}, ';\n']);
                end
                
                if strcmp(curr_tissue{1}(1:2), 'co')
                    fprintf(f, ['v.pool_co_',curr_BA{1},        ' = v.pool_co_',curr_BA{1},        ' + v.', curr_tissue{1}, '_', curr_state{1}, '_',curr_BA{1}, ';\n']);
                    fprintf(f, ['v.pool_co = v.pool_co + v.', curr_tissue{1}, '_', curr_state{1}, '_',curr_BA{1}, ';\n']);
                end
            end
        end
    end
end

fclose(f);

