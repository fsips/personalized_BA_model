function [filename] = generate_ode(tag, folder, c, p, o, L, c_loc, p_loc, depen)

% File is divided into following sections:
% A. Retrieve parameters, concentrations needed for calculations
% B. Calculate GI-reflex variables
% C. Calculate metabolic fluxes
% D. Calculate additional variables

is_full         = sum(strcmp('li', c.tissues));

%% File preparation and header

if is_full
    filename        = [tag, '_full_ode'];
else
    filename        = [tag, '_transit_ode'];
end

f               = fopen([folder, filename, '.m'], 'w');
prefix          = '';

fprintf(f, ['function [dx] = ', filename, '(t, x, p, u)\n']);
fprintf(f, ['\n']);

generate_body(f, prefix, c, p, o, L, c_loc, p_loc, depen, 0);

if is_full % Only in full model
    
    fprintf(f, ['%% D.1  ODE : Liver \n']);
    for curr_state = c.states_c
        for curr_BA = c.BAs
            fprintf(f, ['dx_li_',curr_state{1}, '_',curr_BA{1}, ' = '   ,  ...  % LHS
                '+ ',prefix,'li_x_',  curr_state{1}, '_',curr_BA{1}             ,  ...  % Production
                '+ ',prefix,'li_si_', curr_state{1}, '_',curr_BA{1}             ,  ...  % Input from first pass (small intestine)
                '+ ',prefix,'li_co_', curr_state{1}, '_',curr_BA{1}             ,  ...  % Input from first pass (colon)
                '+ ',prefix,'li_pl_', curr_state{1}, '_',curr_BA{1}             ,  ...  % Input from plasma
                '- ',prefix,'x_li_',  curr_state{1}, '_',curr_BA{1}             ,  ...  % Output
                '- ',prefix,'x_li_',  curr_state{1}, '_',curr_BA{1},'_toplasma' ,  ...  % Output to plasma
                '- ',prefix,'li_biotr_out_',curr_state{1},'_',curr_BA{1}        ,  ...  % Biotransformations - out
                '+ ',prefix,'li_biotr_in_',curr_state{1},'_',curr_BA{1}         ,  ...  % Biotransformations - in
                ';\n']);
        end
    end
    for curr_state = {'u'}
        for curr_BA = c.BAs
            fprintf(f, ['dx_li_',curr_state{1}, '_',curr_BA{1}, ' = 0;\n ']);
        end
    end
    fprintf(f, ['\n']);
    
    fprintf(f, ['%% D.2  ODE : Gallbladder \n']);
    for curr_state = c.states_c
        for curr_BA = c.BAs
            fprintf(f, ['dx_gb_',curr_state{1}, '_',curr_BA{1}, ' = '   ,  ...  % LHS
                '+ ',prefix,'gb_li_',curr_state{1}, '_',curr_BA{1}              ,  ...  % Input from liver
                '- ',prefix,'x_gb_',curr_state{1}, '_',curr_BA{1}               ,  ...  % Output
                ';\n']);
        end
    end
    for curr_state = {'u'}
        for curr_BA = c.BAs
            fprintf(f, ['dx_gb_',curr_state{1}, '_',curr_BA{1}, ' = 0;\n ']);
        end
    end
    fprintf(f, ['\n']);
    
end % End of - only not in full model

fprintf(f, ['\n']);


fprintf(f, ['%% D.3  ODE : Small intestines \n']);

for it1 = 1:size(c.k_si_trans,1)
    for it2 = 1:size(c.k_si_trans,2)
        if strcmp(c.k_si_trans{it1,it2}, '')
            tr_si_temp(it1, it2) = 0;
        else
            tr_si_temp(it1, it2) = 1;
        end
    end
end

trans_in = sum(tr_si_temp);
trans_out = sum(tr_si_temp');

for curr_state = c.states
    for curr_BA = c.BAs
        for it_si = 1:c.num_si
            
            if is_full % Only in full model
                
                % Deconjugation and Biotranformation are dependent on
                % conjugation status
                if strcmp(curr_state{1}, 'u')
                    deconjugation = [];
                    for curr_state2 = c.states_c
                        deconjugation = [deconjugation, '+', '',prefix,'si', num2str(it_si), '_u', curr_state2{1}, '_',curr_BA{1}];
                    end
                    % No transformation in the small intestine
                    transformation_out = [];%['- ',prefix,'si',num2str(it_si),'_biotr_out_u_',curr_BA{1}];
                    transformation_in =  [];%['+ ',prefix,'si',num2str(it_si),'_biotr_in_u_',curr_BA{1}];
                else
                    deconjugation = ['- ',prefix,'si', num2str(it_si), '_u', curr_state{1}, '_',curr_BA{1}];
                    transformation_out = [];
                    transformation_in = [];
                end
                
                % Active uptake only if in right compartment
                active = [];
                si_asbt = cell2mat(c.si_asbt);
                if si_asbt(it_si)==1
                    active  = ['- ',prefix,'si', num2str(it_si), '_au_', curr_state{1}, '_',curr_BA{1}];
                end
                
                % Passive uptake
                passive                 = ['- ',prefix,'si', num2str(it_si), '_pu_', curr_state{1}, '_',curr_BA{1}];
                % Liver input
                liver_in                = ['+ ',prefix,'si',num2str(it_si),'_li_',curr_state{1}, '_',curr_BA{1}];
                % Gallbladder input
                gb_in                   = ['+ ',prefix,'si',num2str(it_si),'_gb_',curr_state{1}, '_',curr_BA{1}];
                
            else % From only in full model to only is not full model
                deconjugation       = [];
                transformation_out  = [];
                transformation_in   = [];
                active              = [];
                passive             = [];
                liver_in            = [];
                gb_in               = [];
            end % End of - only not in full model
            
            % Transport only if transport exists
            if trans_in(it_si)
                trans_in_curr = ['+ ',prefix,'si_trans_in_', curr_state{1}, '_',curr_BA{1}, '_',num2str(it_si)];
            else
                trans_in_curr = [] ;
            end
            
            if trans_out(it_si)
                trans_out_curr = ['- ',prefix,'si_trans_out_', curr_state{1}, '_',curr_BA{1}, '_',num2str(it_si)];
            else
                trans_out_curr = [] ;
            end
            
            
            fprintf(f, ['dx_si',num2str(it_si),'_',curr_state{1}, '_',curr_BA{1}, ' = '         ,  ...  % LHS
                liver_in                                                                        ,  ...  % Input from liver
                gb_in                                                                           ,  ...  % Input from gallbladder
                trans_out_curr                                                                  ,  ...  % Transit out
                trans_in_curr                                                                   ,  ...  % Transit in
                deconjugation                                                                   ,  ...  % Deconjugation
                transformation_out                                                              ,  ...  % Transformation out
                transformation_in                                                               ,  ...  % Transformation in
                active                                                                          ,  ...  % Active uptake
                passive                                                                         ,  ...  % Passive uptake
                ';\n']);
        end
    end
end
fprintf(f, ['\n']);

fprintf(f, ['%% D.4  ODE : Colon \n']);

for it1 = 1:size(c.k_co_trans,1)
    for it2 = 1:size(c.k_co_trans,2)
        if strcmp(c.k_co_trans{it1,it2}, '')
            tr_co_temp(it1, it2) = 0;
        else
            tr_co_temp(it1, it2) = 1;
        end
    end
end

trans_in = sum(tr_co_temp);
trans_out = sum(tr_co_temp');

for curr_state = c.states
    for curr_BA = c.BAs
        for it_co = 1:c.num_co
            
            if is_full % Only in full model
                
                % Deconjugation and Biotranformation are dependent on
                % conjugation status
                if strcmp(curr_state{1}, 'u')
                    deconjugation = [];
                    for curr_state2 = c.states_c
                        deconjugation = [deconjugation, '+', '',prefix,'co', num2str(it_co), '_u', curr_state2{1}, '_',curr_BA{1}];
                    end
                    transformation_out = ['- ',prefix,'co',num2str(it_co),'_biotr_out_u_',curr_BA{1}];
                    transformation_in =  ['+ ',prefix,'co',num2str(it_co),'_biotr_in_u_',curr_BA{1}];
                else
                    deconjugation = ['- ',prefix,'co', num2str(it_co), '_u', curr_state{1}, '_',curr_BA{1}];
                    transformation_out = [];
                    transformation_in = [];
                end
                
                % Input if input exists
                if it_co == 1
                    input = ['+ ',prefix,'si_trans_in_', curr_state{1}, '_',curr_BA{1}, '_',num2str(c.num_si+1)];
                else
                    input =  '';
                end

                % Passive uptake 
                passive = ['- ',prefix,'co', num2str(it_co), '_pu_', curr_state{1}, '_',curr_BA{1}];
                
            else % From only in full model to only is not full model
                deconjugation           = [];
                transformation_out      = [];
                transformation_in       = [];
                input                   = [];
                passive                 = [];
                
            end % End of - only not in full model
            
            % Transport only if transport exists
            if trans_in(it_co)
                trans_in_curr = ['+ ',prefix,'co_trans_in_', curr_state{1}, '_',curr_BA{1}, '_',num2str(it_co)];
            else
                trans_in_curr = '' ;
            end
            
            if trans_out(it_co)
                trans_out_curr = ['- ',prefix,'co_trans_out_', curr_state{1}, '_',curr_BA{1}, '_',num2str(it_co)];
            else
                trans_out_curr = '' ;
            end
            
            
            fprintf(f, ['dx_co',num2str(it_co),'_',curr_state{1}, '_',curr_BA{1}, ' = '         ,  ...  % LHS
                input                                                                           ,  ...  % Input from SI
                trans_out_curr                                                                  ,  ...  % Transit out
                trans_in_curr                                                                   ,  ...  % Transit in
                deconjugation                                                                   ,  ...  % Deconjugation
                transformation_out                                                              ,  ...  % Transformation out
                transformation_in                                                               ,  ...  % Transformation in
                passive                                                                         ,  ...  % Passive uptake
                ';\n']);
        end
    end
end
fprintf(f, ['\n']);

fprintf(f, ['%% D.5  ODE : Faeces \n']);
for curr_state = c.states
    for curr_BA = c.BAs
        fprintf(f, ['dx_fa_',curr_state{1}, '_',curr_BA{1}, ' = '   ,  ...  % LHS
            '+ ',prefix,'co_trans_in_', curr_state{1}, '_',curr_BA{1}, '_',num2str(c.num_co+1),  ...
            ';\n']);
    end
end
fprintf(f, ['\n']);

if is_full % Only in full model
    
    fprintf(f, ['%% D.6  ODE : Plasma \n']);
    for curr_state = c.states
        for curr_BA = c.BAs
            fprintf(f, ['dx_pl_',curr_state{1}, '_',curr_BA{1}, ' = '   ,  ...  % LHS
                '+ ',prefix,'pl_si_', curr_state{1}, '_',curr_BA{1}             ,  ...  % Input from si
                '+ ',prefix,'pl_co_', curr_state{1}, '_',curr_BA{1}             ,  ...  % Input from co
                '+ ',prefix,'pl_li_', curr_state{1}, '_',curr_BA{1}	            ,  ...  % Input from liver
                '- ',prefix,'x_pl_', curr_state{1}, '_',curr_BA{1}              ,  ...  % Output to liver
                ';\n']);
        end
    end
    fprintf(f, ['\n']);
    
    fprintf(f, ['%% D.7  ODE : Cumulative fluxes \n']);
    fprintf(f, ['dx_cum_secreted_BA = ']);  % LHS
    for curr_state = c.states
        for curr_BA = c.BAs
            fprintf(f, ['+ ',prefix,'si',num2str(1),'_li_',curr_state{1}, '_',curr_BA{1}                    ,  ...  % Input from liver
                '+ ',prefix,'si',num2str(1),'_gb_',curr_state{1}, '_',curr_BA{1}
                ]);
        end
    end
    fprintf(f, [';\n \n']);
    
    fprintf(f, ['dx_cum_colon_BA = ']);  % LHS
    for curr_state = c.states
        for curr_BA = c.BAs
            fprintf(f, [' + ', prefix,'si_trans_in_', curr_state{1}, '_',curr_BA{1}, '_',num2str(c.num_si+1)
                ]);
        end
    end
    fprintf(f, [';\n \n']);
    
    fprintf(f, ['dx_cum_excreted_BA = ']);  % LHS
    for curr_state = c.states
        for curr_BA = c.BAs
            fprintf(f, [' + ', prefix,'co_trans_in_', curr_state{1}, '_',curr_BA{1}, '_',num2str(c.num_co+1)
                ]);
        end
    end
    fprintf(f, [';\n \n']);
    
end % End of - only in full model

fprintf(f, ['%% D.8  ODE vector \n']);

for it_state = 1:L
    fprintf(f, ['dx(', num2str(it_state), ') = dx_',o{it_state}, ';\n']);
end
fprintf(f, ['dx = dx(:);\n']);
fprintf(f, ['\n']);


fclose(f);

