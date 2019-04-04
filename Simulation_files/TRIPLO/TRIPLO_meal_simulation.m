function [E] = TRIPLO_meal_simulation(p_vec, model_info, sub_num, data, plot_now, sp, use_MEX)

%% Allocate parameters
p_basis(1) = p_vec(1);  % beta_GB1
p_basis(2) = 0.1;       % beta_GB2
p_basis(3) = p_vec(2);  % beta_SI
p_basis(4) = p_vec(3);  % delta_GB1
p_basis(5) = 0;         % delta_GB2
p_basis(6:24) = p_vec(4:22);

betas1  = p_vec(23:25);
deltas1 = p_vec(26:28);
betas2  = p_vec(29:31);
deltas2 = p_vec(32:34);

%% Simulate to "steady state"

[~, days, day_pre, ~, ~]= simulate_human_day(p_basis, model_info.doss, model_info.dors, model_info.x0, model_info, use_MEX, 1);
x0                      = days.x(end,:);
D_meal                  = zeros(3,1);


%% Simulate meals
for it_meal = 1:3
    p_curr = p_basis;
    p_curr(model_info.p_loc.GIr_delta_GB1) = deltas1(it_meal);
    p_curr(model_info.p_loc.GIr_beta_GB1)  = betas1(it_meal);
    p_curr(model_info.p_loc.GIr_delta_GB2) = deltas2(it_meal);
    p_curr(model_info.p_loc.GIr_beta_GB2)  = betas2(it_meal);
    
    [day] = simulate_meal_only(p_curr, x0, model_info, use_MEX);
    
    names   = {'pl_t_CA' 'pl_g_CA' 'pl_u_CA' 'pl_t_CDCA' 'pl_g_CDCA' 'pl_u_CDCA' 'pl_t_DCA' 'pl_g_DCA' 'pl_u_DCA' 'pl_t_UDCA' 'pl_g_UDCA' 'pl_u_UDCA' 'pl_t_LCA' 'pl_g_LCA' 'pl_u_LCA'};
    names2  = {'tCA' 'gCA' 'uCA' 'tCDCA' 'gCDCA' 'uCDCA' 'tDCA' 'gDCA' 'uDCA' 'tUDCA' 'gUDCA' 'uUDCA' 'tLCA' 'gLCA' 'uLCA'};
    tp      = [0 15 30 45 60 75 90 120 150 180 240 300];
    
    %% P1. PLOT all model vs data, individually, in 4 figures with 12 panels
    if plot_now(1) && plot_now(1) == it_meal
        
        figure('Units', 'normalized', 'Position', [0.1 0.1 0.6 0.8]);
        
        curr_pos = 1;
        for it = 1:15
            subplot(5,3,it)
            
            plco  = [day.v.(names{it})];
            
            x_vec       = [day.t];
            y_vec       = [plco];
            
            plot([day.t], [plco],'-', 'Color',sp{2}.cs{1}, 'LineWidth', 2); hold on

            xlim([-20 260])
            ylim([0 5])
            ylabel([names2{it}, ' (\mumol/L)'])
            
            curr_pos = curr_pos+length(tp);
        end
    end
    
    %% P2. PLOT model vs data as sum of all BA - one figure with 3 (meals) panels
    if plot_now(2)
        figure(sp{2}.h)
        group       = {1 4 7 10 2 5 8 11 3 6 9 12 13 14 15};
        group_names = {'BA (\mumol/L)'};
        
        subplot(sp{2}.ys, sp{2}.xs, sp{2}.loc(it_meal))

        plco    = zeros(size([day.v.(names{1})]));
        for it2 = 1:length(group)
            plco    = plco+[day.v.(names{group{it2}})];
        end
        
        D_plot  = data.meal{it_meal}.TBA(sub_num,:);

        plot([day.t],   [plco], '-', 'Color', sp{2}.cs{1}, 'LineWidth', 2); hold on
        plot([tp],      D_plot, 'sk', 'MarkerFaceColor', [0 0 0]);
        axis([-20 260 0 max([15, max(D_plot)*1.2])])
        ylabel({['Meal', num2str(it_meal)] ,group_names{1}});
    end
    
end
end

