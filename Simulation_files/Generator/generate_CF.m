function [filename, data_vec, data_loc] = generate_CF(tag, folder, CF_base, c)

%% File preparation and header

filename        = [tag, '_CF'];
f               = fopen([folder, filename, '.m'], 'w');
prefix          = '';

fprintf(f, ['function [E] = ', filename, '(data_vec, results)\n']);
fprintf(f, ['\n']);


%% Determine length of cost function
counter = 0;
for it1 = 1:length(CF_base)
        counter = counter + length(CF_base(it1).value);
end

fprintf(f, ['if ~isempty(results) \n \n'])

fprintf(f, ['E              = zeros(',num2str(counter),',1);\n']);
fprintf(f, ['model_vec      = zeros(',num2str(counter),',1);\n']);
fprintf(f, ['weights_vec    = zeros(',num2str(counter),',1);\n']);
fprintf(f, ['\n']); 

%% Enter individual components
counter         = 0;
data_vec        = [];
data_loc        = {};

tag_fasting     = 'results.fas.v.';
tag_meal        = 'results.mea.';      % Because we must also use t and y
tag_transit     = 'results.transit.y.';

for it = 1:length(CF_base)
        switch CF_base(it).type
            case 'Composition'
                switch CF_base(it).details{1}
                    case {'pl', 'li', 'gb', 'po', 'fa'}
                        equations               = comp_human(c, CF_base(it).details{2}, {'all'}, {CF_base(it).details{1}}, CF_base(it).details{3}, 1, tag_fasting);
                        for it3 = 1:length(CF_base(it).details{2})
                            counter             = counter+1;
                            data_vec(counter)   = CF_base(it).value(it3);
                            data_loc{counter}   = {it, it3};
                            fprintf(f, ['model_vec(',num2str(counter),') =  ', equations{it3}, ';\n']);
                            fprintf(f, ['weights_vec(',num2str(counter),') =  ', num2str(length(CF_base(it).details{2})), ';\n']);
                        end 
                    case 'sy'
                        for it3 = 1:length(CF_base(it).details{2})
                            counter             = counter+1;
                            data_vec(counter)   = CF_base(it).value(it3);
                            data_loc{counter}   = {it, it3};
                            fprintf(f, ['model_vec(',num2str(counter),') = ', tag_fasting, 'frac_', CF_base(it).details{2}{it3}{1},' * 100;\n']);
                            fprintf(f, ['weights_vec(',num2str(counter),') =  ', num2str(length(CF_base(it).details{2})), ';\n']);
                        end
                end
                
            case 'Conjugation'
                equations                       = conj_human(c, {'all'}, CF_base(it).details{2}, {CF_base(it).details{1}}, 1, 1, tag_fasting);
                for it3 = 1:length(CF_base(it).value)
                    counter                     = counter+1;
                    data_vec(counter)           = CF_base(it).value(it3); 
                    data_loc{counter}           = {it, it3};
                    fprintf(f, ['model_vec(',num2str(counter),') = ', equations{it3}, ';\n']);
                    fprintf(f, ['weights_vec(',num2str(counter),') =  ', num2str(length(CF_base(it).value)), ';\n']);
                end
                
            case 'Sulfation' 
                equations                       = sulf_human(c, {'all'}, {'all'}, {CF_base(it).details{1}}, 1, tag_fasting);
                for it3 = 1:length(CF_base(it).value)
                    counter                     = counter+1;
                    data_vec(counter)           = CF_base(it).value(it3);
                    data_loc{counter}           = {it,  it3};
                    if strcmp(CF_base(it).details{2}(it3), 'all')
                        fprintf(f, ['model_vec(',num2str(counter),') = ', equations{1}, ';\n']);
                    elseif strcmp(CF_base(it).details{2}(it3), 'LCA')
                        fprintf(f, ['model_vec(',num2str(counter),') = ', equations{2}, ';\n']);
                    end
                    fprintf(f, ['weights_vec(',num2str(counter),') =  ', num2str(length(CF_base(it).value)), ';\n']);
                end
                
            case 'Concentration'
                equations                       = conc_human(c, {'all'}, {'all'}, {CF_base(it).details{1}}, 1, 1, tag_fasting);
                counter                         = counter+1;
                data_vec(counter)               = CF_base(it).value; 
                data_loc{counter}               = {it, []};
                fprintf(f, ['model_vec(',num2str(counter),') = ', equations{1},';\n']);
                fprintf(f, ['weights_vec(',num2str(counter),') =  1;\n']);
                
            case 'Pool'
                for it3 = 1:length(CF_base(it).value)
                    equations                  	= pool_human(c, CF_base(it).details{2}(it3), {'all'}, {CF_base(it).details{1}}, CF_base(it).details{3}, 1, tag_fasting);
                    counter                    	= counter+1;
                    data_loc{counter}          	= {it, it3};
                    data_vec(counter)          	= CF_base(it).value(it3);
                    
                    if strcmp(CF_base(it).units{it3}, '\mumol')
                        fprintf(f, ['model_vec(',num2str(counter),') =',   equations{1}, ';\n']);
                    elseif strcmp(CF_base(it).units{it3}, 'mmol')
                        fprintf(f, ['model_vec(',num2str(counter),') = (', equations{1},')/1000;\n']);
                    elseif strcmp(CF_base(it).units{it3}, '% of total')
                        % Divide pool by total pool
                        equations2                  = pool_human(c, CF_base(it).details{2}(it3), {'all'}, {'all'}, CF_base(it).details{3}, 1, tag_fasting);
                        fprintf(f, ['model_vec(',num2str(counter),') = (', equations{1}, ') / (',equations2{1},') * 100;\n']);
                    end
                    fprintf(f, ['weights_vec(',num2str(counter),') =  ', num2str(length(CF_base(it).value)), ';\n']);
                end
                
                
            case 'Flux'
                switch CF_base(it).details{1}
                    case {'sy'}
                        
                        counter                 = counter+1;
                        data_vec(counter)       = CF_base(it).value; 
                        data_loc{counter}       = {it,  []};
                        
                        fprintf(f, ['model_vec(',num2str(counter),') = ', tag_fasting, 'k_u * 60*24/1000;\n']);
                    case {'bo'}
                        for it3 = 1:length(CF_base(it).value)
                            
                            counter             = counter+1;
                            data_vec(counter)   = CF_base(it).value(it3);
                            data_loc{counter}   = {it, it3};
                            
                            if strcmp(CF_base(it).units{it3}, 'mmol / (kg . day)')
                                fprintf(f, ['model_vec(',num2str(counter),') = ', tag_fasting, 'cum_secreted_BA / ', tag_fasting, 'weight;\n']);
                            elseif strcmp(CF_base(it).units{it3}, 'mmol / (kg . hr)')
                                equation    = '';
                                prefix      = tag_fasting;
                                for curr_state = c.states
                                    for curr_BA = c.BAs
                                        equation = [equation, '+ ',prefix,'si',num2str(1),'_li_',curr_state{1}, '_',curr_BA{1}                    ,  ...  % Input from li
                                            '+ ',prefix,'si',num2str(1),'_gb_',curr_state{1}, '_',curr_BA{1}                                      ,  ...  % Input from gb
                                            ];
                                    end
                                end
                                fprintf(f, ['model_vec(',num2str(counter),') = (',equation,') * 60 / ', tag_fasting, 'weight;\n']);
                            end
                        end
                    case {'fcr'}
                        for it3 = 1:length(CF_base(it).value)
                            counter           	= counter+1;
                            data_vec(counter)  	= CF_base(it).value(it3); 
                            data_loc{counter}  	= {it, it3};
                            equation            = pool_human(c, CF_base(it).details{2}(it3), {'all'}, {'all'}, 1, 1, tag_fasting);
                            fprintf(f, ['model_vec(',num2str(counter),') = ', tag_fasting, 'k_u * ', tag_fasting, 'frac_',CF_base(it).details{2}{it3}{1},' * 60*24/1000 / ((', equation{1}, ')/1000);\n']);
                        end
                            
                end
                fprintf(f, ['weights_vec(',num2str(counter),') =  1;\n']);
                
            case 'Postprandial'
                for it3 = 1:length(CF_base(it).value)
                    counter                     = counter+1;
                    data_vec(counter)          	= CF_base(it).value(it3);
                    data_loc{counter}           = {it, it3};
                    equation                   	= post_human(c, CF_base(it).details{1} , {CF_base(it).details{2}{it3}}, 1, tag_meal);
                    fprintf(f, ['model_vec(',num2str(counter),') = ',equation,';\n']);
                    fprintf(f, ['weights_vec(',num2str(counter),') =  1;\n']);
                end
                
            case 'Transit'
                counter                      	= counter+1;
                data_vec(counter)            	= CF_base(it).value;
                data_loc{counter}               = {it, []};
                fprintf(f, ['model_vec(',num2str(counter),') = ', tag_transit,'trans_',CF_base(it).details{1},';\n']);
                fprintf(f, ['weights_vec(',num2str(counter),') =  1;\n']);
        end
end

fprintf(f, ['\n']);
fprintf(f, ['E = ((data_vec - model_vec)./data_vec)./weights_vec;\n']);

fprintf(f, ['else\n \n'])

fprintf(f, ['E              = ones(',num2str(counter),',1) * 1e2;\n']);

fprintf(f, ['end \n \n'])

fclose(f);  

    
