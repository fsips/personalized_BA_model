function [] = add_sens_output(results, loc, data_struct, type, include)

%% Prepare
delta = 0.0001;


%% Calculate sensitivity and ouput variables
switch type
    case 'global'        
        for it = loc
            
            if include(1)
                LPSA.sens           = calculate_sensitivity(results, it, delta);
                LPSA.delta          = delta;
                LPSA.sub            = it;
                
                save(['Results_Sensitivity\Global_Num', num2str(it)], 'LPSA')
            end
            
            if include(2)
                p_vec = results.type{3}.sub{it}.repeat(loc{3,it}).p_opt(1:22);
                
                p_basis(1) = p_vec(1);  % beta_GB1
                p_basis(2) = 0.1;       % beta_GB2
                p_basis(3) = p_vec(2);  % beta_SI
                p_basis(4) = p_vec(3);  % delta_GB1
                p_basis(5) = 0;         % delta_GB2
                p_basis(6:24) = p_vec(4:22);
                
                [~, ~, day, meal, fasting] = simulate_human_day(p_basis, ...
                    results.type{3}.sub{it}.repeat(loc{3,it}).model_info.doss, ...
                    results.type{3}.sub{it}.repeat(loc{3,it}).model_info.dors, ...
                    results.type{3}.sub{it}.repeat(loc{3,it}).model_info.x0, ...
                    results.type{3}.sub{it}.repeat(loc{3,it}).model_info, 1, 1);
                output.day          = day;
                output.meal         = meal;
                output.fasting      = fasting;
                
                [transit] = simulate_transit_exp(p_basis, ...
                    results.type{3}.sub{it}.repeat(loc{3,it}).model_info, 1, 0);
                output.transit      = transit;
                
                save(['Results_Variables\Global_Num', num2str(it)], 'output')
            end
        end
        
    case 'local'

end