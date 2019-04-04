function [] = plot_par_distributions_TRIPLO(results, type, sub_num)
% Type=1: Populatie, TRIPLO paper
% Type=2: Populatie, Proefschrift
% Type=3: Individueel

figure();
load('MODEL1_opt_result.mat');

p_list = [2 4:22];
sub_list = [1:8];

p_names = {'GIr_beta_SI'
    'GIr_delta_SI'
    'frac_gb'
    'k_xg'
    'k_xi_up_si'
    'vmax_asbt' %6
    'frac_tu'
    'k_ut'
    'k_ug'
    'k_bact_dsi'
    'k_si_1'
    'k_si_2' %12
    'k_co_1'
    'k_u'
    'frac_CA'
    'k_tr_1'
    'k_tr_2'
    'k_tr_3'
    'k_tr_4'
    'k_tr_7'};

%% Within subject parameter variability
p_list = [2 4:22];
for it_sub = sub_list
    for it_par = 1:length(p_list);
        opt_pvalues(it_sub, it_par) = results.all.pvectors(results.best.locati(it_sub), p_list(it_par));
        curr_pvalues = results.all.pvectors(find(results.all.subnum.*results.good.accepted{3}' == it_sub), p_list(it_par));
        curr_WPCV(it_sub, it_par)  = std(curr_pvalues)./mean(curr_pvalues)*100;
    end
end

%% PLOT POPULATION
if type == 1 || type == 2
for it = 1:length(p_list)
    subplot(4,5,it)
    M1_p_opt = opt_result.p_opt(opt_result.model_info.p_loc.(p_names{it}));
    plot([0 9], [M1_p_opt M1_p_opt], ':', 'Color', [0.3 0.3 0.3]); hold on
    
    adequate_WPCV1 = (curr_WPCV(:, it)<=20);
    adequate_WPCV2 = ((curr_WPCV(:, it)<=50) - adequate_WPCV1)==1;
    not_adequate   = (ones(8,1) - adequate_WPCV1 - adequate_WPCV2)==1; 
    
    plot(sub_list(adequate_WPCV1) , opt_pvalues(adequate_WPCV1, it),  'o', 'Color', [0 0.8 0], 'MarkerFaceColor', [0 0.8 0],'LineWidth', 2);
    plot(sub_list(adequate_WPCV2) , opt_pvalues(adequate_WPCV2, it),  'o', 'Color', [1 0.6 0.2], 'MarkerFaceColor', [1 0.6 0.2], 'LineWidth', 2);
    
    if type == 2
        plot([sub_list(adequate_WPCV1);sub_list(adequate_WPCV1)] ,[opt_pvalues(adequate_WPCV1, it), ones(sum(adequate_WPCV1),1)*M1_p_opt]',  '-', 'Color', [0 0.8 0], 'LineWidth', 2);
        plot([sub_list(adequate_WPCV2);sub_list(adequate_WPCV2)] ,[opt_pvalues(adequate_WPCV2, it), ones(sum(adequate_WPCV2),1)*M1_p_opt]',  '-', 'Color', [1 0.6 0.2], 'LineWidth', 2);
    end
    
    % Determine range to plot:
    vals = [M1_p_opt, opt_pvalues(adequate_WPCV1, it)', opt_pvalues(adequate_WPCV2, it)'];
    plot([sub_list(not_adequate);sub_list(not_adequate)] ,[ones(sum(not_adequate),1)*min(vals)*0.91, ones(sum(not_adequate),1)*max(vals)*1.09]',  '-', 'Color', [1 0.8 0.8], 'LineWidth', 7);
    ylim([min(vals)*0.9 max(vals)*1.1])
    xlim([0.5 8.5])
    ylabel(p_names(it))
    xlabel('Subject #')
end
elseif type == 3

%% PLOT INDIVIDUAL

for it = 1:length(p_list)
    subplot(4,5,it)
    M1_p_opt = opt_result.p_opt(opt_result.model_info.p_loc.(p_names{it}));
    plot([0 9], [M1_p_opt M1_p_opt],  ':', 'Color', [0.3 0.3 0.3]); hold on
    
    adequate_WPCV1 = (curr_WPCV(:, it)<=20);
    adequate_WPCV2 = ((curr_WPCV(:, it)<=50) - adequate_WPCV1)==1;
    not_adequate   = (ones(8,1) - adequate_WPCV1 - adequate_WPCV2)==1; 
    
    
    if sum(adequate_WPCV1)>4
        M2_color = [0.5 1 0.5];
        M2_p_opt = mean(opt_pvalues(adequate_WPCV1, it));
    elseif sum(adequate_WPCV1+adequate_WPCV2)>4
        M2_color = [1 0.8 0.2];
        M2_p_opt = mean(opt_pvalues([adequate_WPCV1+adequate_WPCV2]==1, it));
    else
        M2_color = [1 0 0];
        M2_p_opt = mean(opt_pvalues([adequate_WPCV1+adequate_WPCV2]==1, it));
    end
    plot([0 9], [M2_p_opt M2_p_opt], ':', 'Color', M2_color); hold on
        
    if adequate_WPCV1(sub_num)
        plot(sub_num , opt_pvalues(sub_num, it), 's', 'Color', [0 0.8 0], 'MarkerFaceColor', [0 0.8 0],'LineWidth', 2, 'MarkerSize', 12 );
    elseif adequate_WPCV2(sub_num)
        plot(sub_num , opt_pvalues(sub_num, it), 's', 'Color', [1 0.6 0.2], 'MarkerFaceColor', [1 0.6 0.2], 'LineWidth', 2, 'MarkerSize', 12 );
    else
%         set(gca,'Color','r')
    end

    % Determine range to plot:
    vals = [M1_p_opt, opt_pvalues(adequate_WPCV1, it)', opt_pvalues(adequate_WPCV2, it)'];
    ylim([min(vals)*0.9 max(vals)*1.1])
    xlim([0.5 8.5])
    ylabel(p_names(it))
    xlabel('Subject #')
end
end

