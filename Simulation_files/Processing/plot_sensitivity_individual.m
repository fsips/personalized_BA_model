function [] = plot_sensitivity_individual(hide_names)

%% Prepare
A2_ps = [2 4:22];
p_names = {'GIr_beta_SI'
    'GIr_delta_SI'
    'frac_gb'
    'k_xg'
    'k_xi_up_si'
    'vmax_asbt'
    'frac_tu'
    'k_ut'
    'k_ug'
    'k_bact_dsi'
    'k_si_1'
    'k_si_2'
    'k_co_1'
    'k_u'
    'frac_CA'
    'k_tr_1'
    'k_tr_2'
    'k_tr_3'
    'k_tr_4'
    'k_tr_7'};

%% Load previously calculated sensitivity
for it = 1:8
    load(['Global_Num',num2str(it),'.mat'])
    sens(it,:) = LPSA.sens;
end


%% Rank sensitivity
for sub = 1:8
    ranked = [[1:length(A2_ps)]', sens(sub,A2_ps)'];
    ranked = sortrows(ranked,2);
    ranked_ind{sub} = ranked(end:-1:1, :);
    sens_order(sub,:) = ranked(end:-1:1, 1);
end

%% Create plots

color_mat = [128 0 0
            230 25 75
            250 190 190
            170 110 40
            0 128 128
            240 50 230 % Magenta for 6
            255 215 180
            128 128 0
            255 225 25
            255 250 200
            170 255 195
            210 245 60 % Lime for 12
            0 0 0
            245 130 48 % Orange for 14
            70 240 240
            0 0 128
            0 130 200
            145 30 180
            230 190 255
            60 180 75 
            128 128 128] / 256;

figure();
for it = 1:8
    subplot(2,4,it)
    for it2 = 1:20
        bar(it2, ranked_ind{it}(it2,2),1,'FaceColor', color_mat(sens_order(it,it2),:)); hold on
        if ~hide_names
            ht = text(it2, ranked_ind{it}(it2,2)+0.05,p_names{sens_order(it,it2)}); hold on
            set(ht,'Rotation',45)
        end
        ylim([0 5])
    end
    ylabel('S')
    xlabel('Ranked parameters')
    text(15, 4, ['Subject ', num2str(it)])
end
        
        