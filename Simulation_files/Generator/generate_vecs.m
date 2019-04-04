function [c_loc, filename_c, p_loc, filename_p] = generate_vecs(tag, folder, c, p)

%% Constants
filename_c      = [tag, '_con'];
f               = fopen([folder, filename_c, '.m'], 'w');

fprintf(f, ['function [c_vec] = ', filename_c, '(c)\n']);
fprintf(f, ['\n']);

fn = fieldnames(c);

curr_loc = 1;

for it = 1:length(fn)
    if ~sum(strcmp(fn{it}, {'BAs', 'tissues', 'states', 'states_c', 'transit_exp_list'}))
        if size(c.(fn{it}),1)*size(c.(fn{it}),2) > 1
            for it_y = 1:size(c.(fn{it}),1)
                for it_x = 1:size(c.(fn{it}),2)
                    if isnumeric(c.(fn{it}){it_y,it_x})
                        c_loc.(fn{it}){it_y, it_x}  =  curr_loc;
                        c_vec(curr_loc)             =  c.(fn{it}){it_y,it_x};
                        fprintf(f, ['c_vec(',num2str(curr_loc),') = c.',(fn{it}), '{', num2str(it_y), ',',num2str(it_x), '};\n']);
                        
                        curr_loc                    =  curr_loc + 1;
                    end
                end
            end
        elseif size(c.(fn{it}),1)*size(c.(fn{it}),2) == 1
            c_loc.(fn{it})                    	=  curr_loc;
            c_vec(curr_loc)                   	=  c.(fn{it});
            fprintf(f, ['c_vec(',num2str(curr_loc),') = c.',(fn{it}), ';\n']);
            
            curr_loc                           	=  curr_loc + 1;
        end
    end
end

fprintf(f, ['\n']);
fprintf(f, ['end']);
fclose(f);

%% Parameters

filename_p      = [tag, '_par'];
f               = fopen([folder, filename_p, '.m'], 'w');

fprintf(f, ['function [p_vec] = ', filename_p, '(p)\n']);
fprintf(f, ['\n']);

fn = fieldnames(p);

curr_loc = 1;

for it = 1:length(fn)
    if ~sum(strcmp(fn{it}, {'BAs', 'tissues', 'states', 'states_c'}))
        if size(p.(fn{it}),1)*size(p.(fn{it}),2) > 1
            for it_y = 1:size(p.(fn{it}),1)
                for it_x = 1:size(p.(fn{it}),2)
                    p_loc.(fn{it}){it_y, it_x}  =  curr_loc;
                    p_vec(curr_loc)             =  p.(fn{it})(it_y,it_x);                    
                    fprintf(f, ['p_vec(',num2str(curr_loc),') = p.',(fn{it}), '{', num2str(it_y), ',',num2str(it_x), '};\n']);
                    
                    curr_loc                    =  curr_loc + 1;
                end
            end
        elseif size(p.(fn{it}),1)*size(p.(fn{it}),2) == 1
            p_loc.(fn{it})                    	=  curr_loc;
            p_vec(curr_loc)                   	=  p.(fn{it});
            fprintf(f, ['p_vec(',num2str(curr_loc),') = p.',(fn{it}), ';\n']);
            
            curr_loc                           	=  curr_loc + 1;
        end
    end
end


fprintf(f, ['\n']);
fprintf(f, ['end']);
fclose(f);