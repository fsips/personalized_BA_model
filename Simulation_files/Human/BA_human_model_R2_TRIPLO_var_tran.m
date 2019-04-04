function [v] = BA_human_model_R2_TRIPLO_var_tran(t, x, p, u)

% A.1 States 
v.si1_u_tr = x(1);
v.si2_u_tr = x(2);
v.si3_u_tr = x(3);
v.si4_u_tr = x(4);
v.si5_u_tr = x(5);
v.si6_u_tr = x(6);
v.si7_u_tr = x(7);
v.si8_u_tr = x(8);
v.si9_u_tr = x(9);
v.si10_u_tr = x(10);
v.co1_u_tr = x(11);
v.co2_u_tr = x(12);
v.co3_u_tr = x(13);
v.co4_u_tr = x(14);
v.co5_u_tr = x(15);
v.fa_u_tr = x(16);

% A.2 Constants 
v.tau = u(1); 
v.k_xl = u(2); 
v.k_xi_tp_si = u(3); 
v.k_xi_tp_co = u(4); 
v.k_xi_gp_si = u(5); 
v.k_xi_gp_co = u(6); 
v.k_xi_cp_si = u(7); 
v.k_xi_cp_co = u(8); 
v.k_xi_up_co = u(9); 
v.vmax_asbt_s = u(10); 
v.km_asbt = u(11); 
v.frac_li_u = u(12); 
v.frac_li_c_1 = u(13); 
v.frac_li_c_2 = u(14); 
v.frac_li_c_3 = u(15); 
v.frac_li_s = u(16); 
v.V_P = u(17); 
v.Q_L = u(18); 
v.Q_P = u(19); 
v.weight = u(20); 
v.frac_cu = u(21); 
v.k_uc = u(22); 
v.k_bact_psi = u(23); 
v.k_bact_co = u(24); 
v.num_si = u(25); 
v.num_co = u(26); 
v.frac_MCAa = u(27); 
v.frac_MCAb = u(28); 
v.frac_DCA = u(29); 
v.frac_HCA = u(30); 
v.frac_HDCA = u(31); 
v.frac_MDCA = u(32); 
v.frac_UDCA = u(33); 
v.frac_LCA = u(34); 
v.frac_LCAs = u(35); 
v.frac_LCAg = u(36); 
v.frac_MCAo = u(37); 
v.frac_MCAg = u(38); 
v.frac_o = u(39); 
v.frac_tr = u(40); 
v.k_tr_5 = u(41); 
v.k_tr_6 = u(42); 
v.k_pl = u(43); 
v.k_uc_tracer = u(44); 
v.si_asbt_1  = u(45); 
v.si_asbt_2  = u(46); 
v.si_asbt_3  = u(47); 
v.si_asbt_4  = u(48); 
v.si_asbt_5  = u(49); 
v.si_asbt_6  = u(50); 
v.si_asbt_7  = u(51); 
v.si_asbt_8  = u(52); 
v.si_asbt_9  = u(53); 
v.si_asbt_10  = u(54); 
v.biotr_in_1_1  = u(55); 
v.biotr_in_1_2  = u(56); 
v.biotr_in_1_4  = u(57); 
v.biotr_in_1_5  = u(58); 
v.biotr_in_2_1  = u(59); 
v.biotr_in_2_2  = u(60); 
v.biotr_in_2_3  = u(61); 
v.biotr_in_3_1  = u(62); 
v.biotr_in_3_2  = u(63); 
v.biotr_in_3_3  = u(64); 
v.biotr_in_3_4  = u(65); 
v.biotr_in_3_5  = u(66); 
v.biotr_in_4_1  = u(67); 
v.biotr_in_4_2  = u(68); 
v.biotr_in_4_3  = u(69); 
v.biotr_in_4_4  = u(70); 
v.biotr_in_5_1  = u(71); 
v.biotr_in_5_2  = u(72); 
v.biotr_in_5_3  = u(73); 
v.biotr_in_5_4  = u(74); 
v.biotr_in_5_5  = u(75); 
v.biotr_in_6_1  = u(76); 
v.biotr_in_6_2  = u(77); 
v.biotr_in_6_3  = u(78); 
v.biotr_in_6_4  = u(79); 
v.biotr_in_6_5  = u(80); 
v.biotr_in_6_6  = u(81); 
v.biotr_li_1_1  = u(82); 
v.biotr_li_1_2  = u(83); 
v.biotr_li_1_3  = u(84); 
v.biotr_li_1_4  = u(85); 
v.biotr_li_1_5  = u(86); 
v.biotr_li_1_6  = u(87); 
v.biotr_li_2_1  = u(88); 
v.biotr_li_2_2  = u(89); 
v.biotr_li_2_3  = u(90); 
v.biotr_li_2_4  = u(91); 
v.biotr_li_2_5  = u(92); 
v.biotr_li_2_6  = u(93); 
v.biotr_li_3_1  = u(94); 
v.biotr_li_3_2  = u(95); 
v.biotr_li_3_3  = u(96); 
v.biotr_li_3_4  = u(97); 
v.biotr_li_3_5  = u(98); 
v.biotr_li_3_6  = u(99); 
v.biotr_li_4_1  = u(100); 
v.biotr_li_4_2  = u(101); 
v.biotr_li_4_3  = u(102); 
v.biotr_li_4_4  = u(103); 
v.biotr_li_4_5  = u(104); 
v.biotr_li_4_6  = u(105); 
v.biotr_li_5_1  = u(106); 
v.biotr_li_5_2  = u(107); 
v.biotr_li_5_3  = u(108); 
v.biotr_li_5_4  = u(109); 
v.biotr_li_5_5  = u(110); 
v.biotr_li_5_6  = u(111); 
v.biotr_li_6_1  = u(112); 
v.biotr_li_6_2  = u(113); 
v.biotr_li_6_3  = u(114); 
v.biotr_li_6_4  = u(115); 
v.biotr_li_6_5  = u(116); 
v.biotr_li_6_6  = u(117); 

% A.3 Parameters 
v.GIr_beta_GB1 = p(1); 
v.GIr_beta_GB2 = p(2); 
v.GIr_beta_SI = p(3); 
v.GIr_delta_GB1 = p(4); 
v.GIr_delta_GB2 = p(5); 
v.GIr_delta_SI = p(6); 
v.frac_gb = p(7); 
v.k_xg = p(8); 
v.k_xi_up_si = p(9); 
v.vmax_asbt = p(10); 
v.frac_tu = p(11); 
v.k_ut = p(12); 
v.k_ug = p(13); 
v.k_bact_dsi = p(14); 
v.k_si_1 = p(15); 
v.k_si_2 = p(16); 
v.k_co_1 = p(17); 
v.k_u = p(18); 
v.frac_CA = p(19); 
v.k_tr_1 = p(20); 
v.k_tr_2 = p(21); 
v.k_tr_3 = p(22); 
v.k_tr_4 = p(23); 
v.k_tr_7 = p(24); 

% A.4 Transit parameters 
v.k_si_trans_1_2 = v.k_si_1; 
v.k_si_trans_2_3 = v.k_si_1; 
v.k_si_trans_3_4 = v.k_si_1; 
v.k_si_trans_4_5 = v.k_si_1; 
v.k_si_trans_5_6 = v.k_si_1; 
v.k_si_trans_6_7 = v.k_si_1; 
v.k_si_trans_7_8 = v.k_si_1; 
v.k_si_trans_8_9 = v.k_si_1; 
v.k_si_trans_9_10 = v.k_si_2; 
v.k_si_trans_10_11 = v.k_si_2; 
v.k_co_trans_1_2 = v.k_co_1; 
v.k_co_trans_2_3 = v.k_co_1; 
v.k_co_trans_3_4 = v.k_co_1; 
v.k_co_trans_4_5 = v.k_co_1; 
v.k_co_trans_5_6 = v.k_co_1; 

% A.5 Biotransformation parameters 
v.biotr_in_1_3 = v.k_tr_1; 
v.biotr_in_1_6 = v.k_tr_7; 
v.biotr_in_2_4 = v.k_tr_2; 
v.biotr_in_2_5 = v.k_tr_3; 
v.biotr_in_2_6 = v.k_tr_7; 
v.biotr_in_3_6 = v.k_tr_7; 
v.biotr_in_4_5 = v.k_tr_4; 
v.biotr_in_4_6 = v.k_tr_7; 
v.biotr_in_5_6 = v.k_tr_7; 
v.bact_1 = v.k_bact_psi; 
v.bact_2 = v.k_bact_psi; 
v.bact_3 = v.k_bact_psi; 
v.bact_4 = v.k_bact_psi; 
v.bact_5 = v.k_bact_psi; 
v.bact_6 = v.k_bact_dsi; 
v.bact_7 = v.k_bact_dsi; 
v.bact_8 = v.k_bact_dsi; 
v.bact_9 = v.k_bact_dsi; 
v.bact_10 = v.k_bact_dsi; 
v.bact_11 = v.k_bact_co; 
v.bact_12 = v.k_bact_co; 
v.bact_13 = v.k_bact_co; 
v.bact_14 = v.k_bact_co; 
v.bact_15 = v.k_bact_co; 

% A.6 Hepatic extraction parameters 

% A.7 Dependables 
v.frac_gu = 1-v.frac_tu; 
v.frac_CDCA = 1 - ( + v.frac_CA + v.frac_DCA + v.frac_UDCA + v.frac_LCA + v.frac_o); 

% B.1 Postprandial status 
v.curr_GI_reflex_GB1 = max(GI_reflex(v.GIr_beta_GB1, v.GIr_delta_GB1, t - v.tau), 1); 
v.curr_GI_reflex_GB2 = max(GI_reflex(v.GIr_beta_GB2, v.GIr_delta_GB2, t - v.tau), 1); 
v.curr_GI_reflex_GB  = v.curr_GI_reflex_GB1 + v.curr_GI_reflex_GB2 -1; 
v.curr_GI_reflex_SI = max(GI_reflex(v.GIr_beta_SI, v.GIr_delta_SI, t - v.tau), 1); 

% B.2 Multiply parameters that are GIr-sensitive with GIr 
v.k_xg       = v.k_xg          * v.curr_GI_reflex_GB; 
v.k_si_trans_1_2 = v.k_si_trans_1_2  * v.curr_GI_reflex_SI; 
v.k_si_trans_2_3 = v.k_si_trans_2_3  * v.curr_GI_reflex_SI; 
v.k_si_trans_3_4 = v.k_si_trans_3_4  * v.curr_GI_reflex_SI; 
v.k_si_trans_4_5 = v.k_si_trans_4_5  * v.curr_GI_reflex_SI; 
v.k_si_trans_5_6 = v.k_si_trans_5_6  * v.curr_GI_reflex_SI; 
v.k_si_trans_6_7 = v.k_si_trans_6_7  * v.curr_GI_reflex_SI; 
v.k_si_trans_7_8 = v.k_si_trans_7_8  * v.curr_GI_reflex_SI; 
v.k_si_trans_8_9 = v.k_si_trans_8_9  * v.curr_GI_reflex_SI; 
v.k_si_trans_9_10 = v.k_si_trans_9_10  * v.curr_GI_reflex_SI; 
v.k_si_trans_10_11 = v.k_si_trans_10_11  * v.curr_GI_reflex_SI; 
v.k_co_trans_1_2 = v.k_co_trans_1_2  * v.curr_GI_reflex_SI; 
v.k_co_trans_2_3 = v.k_co_trans_2_3  * v.curr_GI_reflex_SI; 
v.k_co_trans_3_4 = v.k_co_trans_3_4  * v.curr_GI_reflex_SI; 
v.k_co_trans_4_5 = v.k_co_trans_4_5  * v.curr_GI_reflex_SI; 
v.k_co_trans_5_6 = v.k_co_trans_5_6  * v.curr_GI_reflex_SI; 
% (transit fluxes) 
v.si_trans_in_u_tr_2 = v.si1_u_tr * v.k_si_trans_1_2; 
v.si_trans_out_u_tr_1= v.si1_u_tr * v.k_si_trans_1_2; 
v.si_trans_in_u_tr_3 = v.si2_u_tr * v.k_si_trans_2_3; 
v.si_trans_out_u_tr_2= v.si2_u_tr * v.k_si_trans_2_3; 
v.si_trans_in_u_tr_4 = v.si3_u_tr * v.k_si_trans_3_4; 
v.si_trans_out_u_tr_3= v.si3_u_tr * v.k_si_trans_3_4; 
v.si_trans_in_u_tr_5 = v.si4_u_tr * v.k_si_trans_4_5; 
v.si_trans_out_u_tr_4= v.si4_u_tr * v.k_si_trans_4_5; 
v.si_trans_in_u_tr_6 = v.si5_u_tr * v.k_si_trans_5_6; 
v.si_trans_out_u_tr_5= v.si5_u_tr * v.k_si_trans_5_6; 
v.si_trans_in_u_tr_7 = v.si6_u_tr * v.k_si_trans_6_7; 
v.si_trans_out_u_tr_6= v.si6_u_tr * v.k_si_trans_6_7; 
v.si_trans_in_u_tr_8 = v.si7_u_tr * v.k_si_trans_7_8; 
v.si_trans_out_u_tr_7= v.si7_u_tr * v.k_si_trans_7_8; 
v.si_trans_in_u_tr_9 = v.si8_u_tr * v.k_si_trans_8_9; 
v.si_trans_out_u_tr_8= v.si8_u_tr * v.k_si_trans_8_9; 
v.si_trans_in_u_tr_10 = v.si9_u_tr * v.k_si_trans_9_10; 
v.si_trans_out_u_tr_9= v.si9_u_tr * v.k_si_trans_9_10; 
v.si_trans_in_u_tr_11 = v.si10_u_tr * v.k_si_trans_10_11; 
v.si_trans_out_u_tr_10= v.si10_u_tr * v.k_si_trans_10_11; 

% C.6 Colon (in) fluxes 
% (transit fluxes) 
v.co_trans_in_u_tr_2 = v.co1_u_tr * v.k_co_trans_1_2; 
v.co_trans_out_u_tr_1= v.co1_u_tr * v.k_co_trans_1_2; 
v.co_trans_in_u_tr_3 = v.co2_u_tr * v.k_co_trans_2_3; 
v.co_trans_out_u_tr_2= v.co2_u_tr * v.k_co_trans_2_3; 
v.co_trans_in_u_tr_4 = v.co3_u_tr * v.k_co_trans_3_4; 
v.co_trans_out_u_tr_3= v.co3_u_tr * v.k_co_trans_3_4; 
v.co_trans_in_u_tr_5 = v.co4_u_tr * v.k_co_trans_4_5; 
v.co_trans_out_u_tr_4= v.co4_u_tr * v.k_co_trans_4_5; 
v.co_trans_in_u_tr_6 = v.co5_u_tr * v.k_co_trans_5_6; 
v.co_trans_out_u_tr_5= v.co5_u_tr * v.k_co_trans_5_6; 

% E.1  Diagnostic variables 

% Passive and active uptake 
% Pool 
v.pool = 0; 
v.pool_state_u = 0; 
v.plco_state_u = 0; 
v.pool_tissue_si1 = 0; 
v.pool_tissue_si2 = 0; 
v.pool_tissue_si3 = 0; 
v.pool_tissue_si4 = 0; 
v.pool_tissue_si5 = 0; 
v.pool_tissue_si6 = 0; 
v.pool_tissue_si7 = 0; 
v.pool_tissue_si8 = 0; 
v.pool_tissue_si9 = 0; 
v.pool_tissue_si10 = 0; 
v.pool_tissue_co1 = 0; 
v.pool_tissue_co2 = 0; 
v.pool_tissue_co3 = 0; 
v.pool_tissue_co4 = 0; 
v.pool_tissue_co5 = 0; 
v.pool_tissue_fa = 0; 
v.pool_BA_tr = 0; 
v.plco_BA_tr = 0; 
v.pool_si_tr = 0; 
v.pool_co_tr = 0; 
v.pool_si = 0; 
v.pool_co = 0; 
v.pool = v.pool + v.si1_u_tr;
v.pool_state_u = v.pool_state_u + v.si1_u_tr;
v.pool_tissue_si1 = v.pool_tissue_si1 + v.si1_u_tr;
v.pool_BA_tr = v.pool_BA_tr + v.si1_u_tr;
v.pool_si_tr = v.pool_si_tr + v.si1_u_tr;
v.pool_si = v.pool_si + v.si1_u_tr;
v.pool = v.pool + v.si2_u_tr;
v.pool_state_u = v.pool_state_u + v.si2_u_tr;
v.pool_tissue_si2 = v.pool_tissue_si2 + v.si2_u_tr;
v.pool_BA_tr = v.pool_BA_tr + v.si2_u_tr;
v.pool_si_tr = v.pool_si_tr + v.si2_u_tr;
v.pool_si = v.pool_si + v.si2_u_tr;
v.pool = v.pool + v.si3_u_tr;
v.pool_state_u = v.pool_state_u + v.si3_u_tr;
v.pool_tissue_si3 = v.pool_tissue_si3 + v.si3_u_tr;
v.pool_BA_tr = v.pool_BA_tr + v.si3_u_tr;
v.pool_si_tr = v.pool_si_tr + v.si3_u_tr;
v.pool_si = v.pool_si + v.si3_u_tr;
v.pool = v.pool + v.si4_u_tr;
v.pool_state_u = v.pool_state_u + v.si4_u_tr;
v.pool_tissue_si4 = v.pool_tissue_si4 + v.si4_u_tr;
v.pool_BA_tr = v.pool_BA_tr + v.si4_u_tr;
v.pool_si_tr = v.pool_si_tr + v.si4_u_tr;
v.pool_si = v.pool_si + v.si4_u_tr;
v.pool = v.pool + v.si5_u_tr;
v.pool_state_u = v.pool_state_u + v.si5_u_tr;
v.pool_tissue_si5 = v.pool_tissue_si5 + v.si5_u_tr;
v.pool_BA_tr = v.pool_BA_tr + v.si5_u_tr;
v.pool_si_tr = v.pool_si_tr + v.si5_u_tr;
v.pool_si = v.pool_si + v.si5_u_tr;
v.pool = v.pool + v.si6_u_tr;
v.pool_state_u = v.pool_state_u + v.si6_u_tr;
v.pool_tissue_si6 = v.pool_tissue_si6 + v.si6_u_tr;
v.pool_BA_tr = v.pool_BA_tr + v.si6_u_tr;
v.pool_si_tr = v.pool_si_tr + v.si6_u_tr;
v.pool_si = v.pool_si + v.si6_u_tr;
v.pool = v.pool + v.si7_u_tr;
v.pool_state_u = v.pool_state_u + v.si7_u_tr;
v.pool_tissue_si7 = v.pool_tissue_si7 + v.si7_u_tr;
v.pool_BA_tr = v.pool_BA_tr + v.si7_u_tr;
v.pool_si_tr = v.pool_si_tr + v.si7_u_tr;
v.pool_si = v.pool_si + v.si7_u_tr;
v.pool = v.pool + v.si8_u_tr;
v.pool_state_u = v.pool_state_u + v.si8_u_tr;
v.pool_tissue_si8 = v.pool_tissue_si8 + v.si8_u_tr;
v.pool_BA_tr = v.pool_BA_tr + v.si8_u_tr;
v.pool_si_tr = v.pool_si_tr + v.si8_u_tr;
v.pool_si = v.pool_si + v.si8_u_tr;
v.pool = v.pool + v.si9_u_tr;
v.pool_state_u = v.pool_state_u + v.si9_u_tr;
v.pool_tissue_si9 = v.pool_tissue_si9 + v.si9_u_tr;
v.pool_BA_tr = v.pool_BA_tr + v.si9_u_tr;
v.pool_si_tr = v.pool_si_tr + v.si9_u_tr;
v.pool_si = v.pool_si + v.si9_u_tr;
v.pool = v.pool + v.si10_u_tr;
v.pool_state_u = v.pool_state_u + v.si10_u_tr;
v.pool_tissue_si10 = v.pool_tissue_si10 + v.si10_u_tr;
v.pool_BA_tr = v.pool_BA_tr + v.si10_u_tr;
v.pool_si_tr = v.pool_si_tr + v.si10_u_tr;
v.pool_si = v.pool_si + v.si10_u_tr;
v.pool = v.pool + v.co1_u_tr;
v.pool_state_u = v.pool_state_u + v.co1_u_tr;
v.pool_tissue_co1 = v.pool_tissue_co1 + v.co1_u_tr;
v.pool_BA_tr = v.pool_BA_tr + v.co1_u_tr;
v.pool_co_tr = v.pool_co_tr + v.co1_u_tr;
v.pool_co = v.pool_co + v.co1_u_tr;
v.pool = v.pool + v.co2_u_tr;
v.pool_state_u = v.pool_state_u + v.co2_u_tr;
v.pool_tissue_co2 = v.pool_tissue_co2 + v.co2_u_tr;
v.pool_BA_tr = v.pool_BA_tr + v.co2_u_tr;
v.pool_co_tr = v.pool_co_tr + v.co2_u_tr;
v.pool_co = v.pool_co + v.co2_u_tr;
v.pool = v.pool + v.co3_u_tr;
v.pool_state_u = v.pool_state_u + v.co3_u_tr;
v.pool_tissue_co3 = v.pool_tissue_co3 + v.co3_u_tr;
v.pool_BA_tr = v.pool_BA_tr + v.co3_u_tr;
v.pool_co_tr = v.pool_co_tr + v.co3_u_tr;
v.pool_co = v.pool_co + v.co3_u_tr;
v.pool = v.pool + v.co4_u_tr;
v.pool_state_u = v.pool_state_u + v.co4_u_tr;
v.pool_tissue_co4 = v.pool_tissue_co4 + v.co4_u_tr;
v.pool_BA_tr = v.pool_BA_tr + v.co4_u_tr;
v.pool_co_tr = v.pool_co_tr + v.co4_u_tr;
v.pool_co = v.pool_co + v.co4_u_tr;
v.pool = v.pool + v.co5_u_tr;
v.pool_state_u = v.pool_state_u + v.co5_u_tr;
v.pool_tissue_co5 = v.pool_tissue_co5 + v.co5_u_tr;
v.pool_BA_tr = v.pool_BA_tr + v.co5_u_tr;
v.pool_co_tr = v.pool_co_tr + v.co5_u_tr;
v.pool_co = v.pool_co + v.co5_u_tr;
