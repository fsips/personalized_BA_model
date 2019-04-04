function [p_vec] = BA_human_model_R2_TRIPLO_par(p)

p_vec(1) = p.GIr_beta_GB1;
p_vec(2) = p.GIr_beta_GB2;
p_vec(3) = p.GIr_beta_SI;
p_vec(4) = p.GIr_delta_GB1;
p_vec(5) = p.GIr_delta_GB2;
p_vec(6) = p.GIr_delta_SI;
p_vec(7) = p.frac_gb;
p_vec(8) = p.k_xg;
p_vec(9) = p.k_xi_up_si;
p_vec(10) = p.vmax_asbt;
p_vec(11) = p.frac_tu;
p_vec(12) = p.k_ut;
p_vec(13) = p.k_ug;
p_vec(14) = p.k_bact_dsi;
p_vec(15) = p.k_si_1;
p_vec(16) = p.k_si_2;
p_vec(17) = p.k_co_1;
p_vec(18) = p.k_u;
p_vec(19) = p.frac_CA;
p_vec(20) = p.k_tr_1;
p_vec(21) = p.k_tr_2;
p_vec(22) = p.k_tr_3;
p_vec(23) = p.k_tr_4;
p_vec(24) = p.k_tr_7;

end