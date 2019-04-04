function [dx] = BA_human_model_R2_TRIPLO_transit_ode(t, x, p, u)

% A.1 States 
si1_u_tr = x(1);
si2_u_tr = x(2);
si3_u_tr = x(3);
si4_u_tr = x(4);
si5_u_tr = x(5);
si6_u_tr = x(6);
si7_u_tr = x(7);
si8_u_tr = x(8);
si9_u_tr = x(9);
si10_u_tr = x(10);
co1_u_tr = x(11);
co2_u_tr = x(12);
co3_u_tr = x(13);
co4_u_tr = x(14);
co5_u_tr = x(15);
fa_u_tr = x(16);

% A.2 Constants 
tau = u(1); 
k_xl = u(2); 
k_xi_tp_si = u(3); 
k_xi_tp_co = u(4); 
k_xi_gp_si = u(5); 
k_xi_gp_co = u(6); 
k_xi_cp_si = u(7); 
k_xi_cp_co = u(8); 
k_xi_up_co = u(9); 
vmax_asbt_s = u(10); 
km_asbt = u(11); 
frac_li_u = u(12); 
frac_li_c_1 = u(13); 
frac_li_c_2 = u(14); 
frac_li_c_3 = u(15); 
frac_li_s = u(16); 
V_P = u(17); 
Q_L = u(18); 
Q_P = u(19); 
weight = u(20); 
frac_cu = u(21); 
k_uc = u(22); 
k_bact_psi = u(23); 
k_bact_co = u(24); 
num_si = u(25); 
num_co = u(26); 
frac_MCAa = u(27); 
frac_MCAb = u(28); 
frac_DCA = u(29); 
frac_HCA = u(30); 
frac_HDCA = u(31); 
frac_MDCA = u(32); 
frac_UDCA = u(33); 
frac_LCA = u(34); 
frac_LCAs = u(35); 
frac_LCAg = u(36); 
frac_MCAo = u(37); 
frac_MCAg = u(38); 
frac_o = u(39); 
frac_tr = u(40); 
k_tr_5 = u(41); 
k_tr_6 = u(42); 
k_pl = u(43); 
k_uc_tracer = u(44); 
si_asbt_1  = u(45); 
si_asbt_2  = u(46); 
si_asbt_3  = u(47); 
si_asbt_4  = u(48); 
si_asbt_5  = u(49); 
si_asbt_6  = u(50); 
si_asbt_7  = u(51); 
si_asbt_8  = u(52); 
si_asbt_9  = u(53); 
si_asbt_10  = u(54); 
biotr_in_1_1  = u(55); 
biotr_in_1_2  = u(56); 
biotr_in_1_4  = u(57); 
biotr_in_1_5  = u(58); 
biotr_in_2_1  = u(59); 
biotr_in_2_2  = u(60); 
biotr_in_2_3  = u(61); 
biotr_in_3_1  = u(62); 
biotr_in_3_2  = u(63); 
biotr_in_3_3  = u(64); 
biotr_in_3_4  = u(65); 
biotr_in_3_5  = u(66); 
biotr_in_4_1  = u(67); 
biotr_in_4_2  = u(68); 
biotr_in_4_3  = u(69); 
biotr_in_4_4  = u(70); 
biotr_in_5_1  = u(71); 
biotr_in_5_2  = u(72); 
biotr_in_5_3  = u(73); 
biotr_in_5_4  = u(74); 
biotr_in_5_5  = u(75); 
biotr_in_6_1  = u(76); 
biotr_in_6_2  = u(77); 
biotr_in_6_3  = u(78); 
biotr_in_6_4  = u(79); 
biotr_in_6_5  = u(80); 
biotr_in_6_6  = u(81); 
biotr_li_1_1  = u(82); 
biotr_li_1_2  = u(83); 
biotr_li_1_3  = u(84); 
biotr_li_1_4  = u(85); 
biotr_li_1_5  = u(86); 
biotr_li_1_6  = u(87); 
biotr_li_2_1  = u(88); 
biotr_li_2_2  = u(89); 
biotr_li_2_3  = u(90); 
biotr_li_2_4  = u(91); 
biotr_li_2_5  = u(92); 
biotr_li_2_6  = u(93); 
biotr_li_3_1  = u(94); 
biotr_li_3_2  = u(95); 
biotr_li_3_3  = u(96); 
biotr_li_3_4  = u(97); 
biotr_li_3_5  = u(98); 
biotr_li_3_6  = u(99); 
biotr_li_4_1  = u(100); 
biotr_li_4_2  = u(101); 
biotr_li_4_3  = u(102); 
biotr_li_4_4  = u(103); 
biotr_li_4_5  = u(104); 
biotr_li_4_6  = u(105); 
biotr_li_5_1  = u(106); 
biotr_li_5_2  = u(107); 
biotr_li_5_3  = u(108); 
biotr_li_5_4  = u(109); 
biotr_li_5_5  = u(110); 
biotr_li_5_6  = u(111); 
biotr_li_6_1  = u(112); 
biotr_li_6_2  = u(113); 
biotr_li_6_3  = u(114); 
biotr_li_6_4  = u(115); 
biotr_li_6_5  = u(116); 
biotr_li_6_6  = u(117); 

% A.3 Parameters 
GIr_beta_GB1 = p(1); 
GIr_beta_GB2 = p(2); 
GIr_beta_SI = p(3); 
GIr_delta_GB1 = p(4); 
GIr_delta_GB2 = p(5); 
GIr_delta_SI = p(6); 
frac_gb = p(7); 
k_xg = p(8); 
k_xi_up_si = p(9); 
vmax_asbt = p(10); 
frac_tu = p(11); 
k_ut = p(12); 
k_ug = p(13); 
k_bact_dsi = p(14); 
k_si_1 = p(15); 
k_si_2 = p(16); 
k_co_1 = p(17); 
k_u = p(18); 
frac_CA = p(19); 
k_tr_1 = p(20); 
k_tr_2 = p(21); 
k_tr_3 = p(22); 
k_tr_4 = p(23); 
k_tr_7 = p(24); 

% A.4 Transit parameters 
k_si_trans_1_2 = k_si_1; 
k_si_trans_2_3 = k_si_1; 
k_si_trans_3_4 = k_si_1; 
k_si_trans_4_5 = k_si_1; 
k_si_trans_5_6 = k_si_1; 
k_si_trans_6_7 = k_si_1; 
k_si_trans_7_8 = k_si_1; 
k_si_trans_8_9 = k_si_1; 
k_si_trans_9_10 = k_si_2; 
k_si_trans_10_11 = k_si_2; 
k_co_trans_1_2 = k_co_1; 
k_co_trans_2_3 = k_co_1; 
k_co_trans_3_4 = k_co_1; 
k_co_trans_4_5 = k_co_1; 
k_co_trans_5_6 = k_co_1; 

% A.5 Biotransformation parameters 
biotr_in_1_3 = k_tr_1; 
biotr_in_1_6 = k_tr_7; 
biotr_in_2_4 = k_tr_2; 
biotr_in_2_5 = k_tr_3; 
biotr_in_2_6 = k_tr_7; 
biotr_in_3_6 = k_tr_7; 
biotr_in_4_5 = k_tr_4; 
biotr_in_4_6 = k_tr_7; 
biotr_in_5_6 = k_tr_7; 
bact_1 = k_bact_psi; 
bact_2 = k_bact_psi; 
bact_3 = k_bact_psi; 
bact_4 = k_bact_psi; 
bact_5 = k_bact_psi; 
bact_6 = k_bact_dsi; 
bact_7 = k_bact_dsi; 
bact_8 = k_bact_dsi; 
bact_9 = k_bact_dsi; 
bact_10 = k_bact_dsi; 
bact_11 = k_bact_co; 
bact_12 = k_bact_co; 
bact_13 = k_bact_co; 
bact_14 = k_bact_co; 
bact_15 = k_bact_co; 

% A.6 Hepatic extraction parameters 

% A.7 Dependables 
frac_gu = 1-frac_tu; 
frac_CDCA = 1 - ( + frac_CA + frac_DCA + frac_UDCA + frac_LCA + frac_o); 

% B.1 Postprandial status 
curr_GI_reflex_GB1 = max(GI_reflex(GIr_beta_GB1, GIr_delta_GB1, t - tau), 1); 
curr_GI_reflex_GB2 = max(GI_reflex(GIr_beta_GB2, GIr_delta_GB2, t - tau), 1); 
curr_GI_reflex_GB  = curr_GI_reflex_GB1 + curr_GI_reflex_GB2 -1; 
curr_GI_reflex_SI = max(GI_reflex(GIr_beta_SI, GIr_delta_SI, t - tau), 1); 

% B.2 Multiply parameters that are GIr-sensitive with GIr 
k_xg       = k_xg          * curr_GI_reflex_GB; 
k_si_trans_1_2 = k_si_trans_1_2  * curr_GI_reflex_SI; 
k_si_trans_2_3 = k_si_trans_2_3  * curr_GI_reflex_SI; 
k_si_trans_3_4 = k_si_trans_3_4  * curr_GI_reflex_SI; 
k_si_trans_4_5 = k_si_trans_4_5  * curr_GI_reflex_SI; 
k_si_trans_5_6 = k_si_trans_5_6  * curr_GI_reflex_SI; 
k_si_trans_6_7 = k_si_trans_6_7  * curr_GI_reflex_SI; 
k_si_trans_7_8 = k_si_trans_7_8  * curr_GI_reflex_SI; 
k_si_trans_8_9 = k_si_trans_8_9  * curr_GI_reflex_SI; 
k_si_trans_9_10 = k_si_trans_9_10  * curr_GI_reflex_SI; 
k_si_trans_10_11 = k_si_trans_10_11  * curr_GI_reflex_SI; 
k_co_trans_1_2 = k_co_trans_1_2  * curr_GI_reflex_SI; 
k_co_trans_2_3 = k_co_trans_2_3  * curr_GI_reflex_SI; 
k_co_trans_3_4 = k_co_trans_3_4  * curr_GI_reflex_SI; 
k_co_trans_4_5 = k_co_trans_4_5  * curr_GI_reflex_SI; 
k_co_trans_5_6 = k_co_trans_5_6  * curr_GI_reflex_SI; 
% (transit fluxes) 
si_trans_in_u_tr_2 = si1_u_tr * k_si_trans_1_2; 
si_trans_out_u_tr_1= si1_u_tr * k_si_trans_1_2; 
si_trans_in_u_tr_3 = si2_u_tr * k_si_trans_2_3; 
si_trans_out_u_tr_2= si2_u_tr * k_si_trans_2_3; 
si_trans_in_u_tr_4 = si3_u_tr * k_si_trans_3_4; 
si_trans_out_u_tr_3= si3_u_tr * k_si_trans_3_4; 
si_trans_in_u_tr_5 = si4_u_tr * k_si_trans_4_5; 
si_trans_out_u_tr_4= si4_u_tr * k_si_trans_4_5; 
si_trans_in_u_tr_6 = si5_u_tr * k_si_trans_5_6; 
si_trans_out_u_tr_5= si5_u_tr * k_si_trans_5_6; 
si_trans_in_u_tr_7 = si6_u_tr * k_si_trans_6_7; 
si_trans_out_u_tr_6= si6_u_tr * k_si_trans_6_7; 
si_trans_in_u_tr_8 = si7_u_tr * k_si_trans_7_8; 
si_trans_out_u_tr_7= si7_u_tr * k_si_trans_7_8; 
si_trans_in_u_tr_9 = si8_u_tr * k_si_trans_8_9; 
si_trans_out_u_tr_8= si8_u_tr * k_si_trans_8_9; 
si_trans_in_u_tr_10 = si9_u_tr * k_si_trans_9_10; 
si_trans_out_u_tr_9= si9_u_tr * k_si_trans_9_10; 
si_trans_in_u_tr_11 = si10_u_tr * k_si_trans_10_11; 
si_trans_out_u_tr_10= si10_u_tr * k_si_trans_10_11; 

% C.6 Colon (in) fluxes 
% (transit fluxes) 
co_trans_in_u_tr_2 = co1_u_tr * k_co_trans_1_2; 
co_trans_out_u_tr_1= co1_u_tr * k_co_trans_1_2; 
co_trans_in_u_tr_3 = co2_u_tr * k_co_trans_2_3; 
co_trans_out_u_tr_2= co2_u_tr * k_co_trans_2_3; 
co_trans_in_u_tr_4 = co3_u_tr * k_co_trans_3_4; 
co_trans_out_u_tr_3= co3_u_tr * k_co_trans_3_4; 
co_trans_in_u_tr_5 = co4_u_tr * k_co_trans_4_5; 
co_trans_out_u_tr_4= co4_u_tr * k_co_trans_4_5; 
co_trans_in_u_tr_6 = co5_u_tr * k_co_trans_5_6; 
co_trans_out_u_tr_5= co5_u_tr * k_co_trans_5_6; 


% D.3  ODE : Small intestines 
dx_si1_u_tr = - si_trans_out_u_tr_1;
dx_si2_u_tr = - si_trans_out_u_tr_2+ si_trans_in_u_tr_2;
dx_si3_u_tr = - si_trans_out_u_tr_3+ si_trans_in_u_tr_3;
dx_si4_u_tr = - si_trans_out_u_tr_4+ si_trans_in_u_tr_4;
dx_si5_u_tr = - si_trans_out_u_tr_5+ si_trans_in_u_tr_5;
dx_si6_u_tr = - si_trans_out_u_tr_6+ si_trans_in_u_tr_6;
dx_si7_u_tr = - si_trans_out_u_tr_7+ si_trans_in_u_tr_7;
dx_si8_u_tr = - si_trans_out_u_tr_8+ si_trans_in_u_tr_8;
dx_si9_u_tr = - si_trans_out_u_tr_9+ si_trans_in_u_tr_9;
dx_si10_u_tr = - si_trans_out_u_tr_10+ si_trans_in_u_tr_10;

% D.4  ODE : Colon 
dx_co1_u_tr = - co_trans_out_u_tr_1;
dx_co2_u_tr = - co_trans_out_u_tr_2+ co_trans_in_u_tr_2;
dx_co3_u_tr = - co_trans_out_u_tr_3+ co_trans_in_u_tr_3;
dx_co4_u_tr = - co_trans_out_u_tr_4+ co_trans_in_u_tr_4;
dx_co5_u_tr = - co_trans_out_u_tr_5+ co_trans_in_u_tr_5;

% D.5  ODE : Faeces 
dx_fa_u_tr = + co_trans_in_u_tr_6;

% D.8  ODE vector 
dx(1) = dx_si1_u_tr;
dx(2) = dx_si2_u_tr;
dx(3) = dx_si3_u_tr;
dx(4) = dx_si4_u_tr;
dx(5) = dx_si5_u_tr;
dx(6) = dx_si6_u_tr;
dx(7) = dx_si7_u_tr;
dx(8) = dx_si8_u_tr;
dx(9) = dx_si9_u_tr;
dx(10) = dx_si10_u_tr;
dx(11) = dx_co1_u_tr;
dx(12) = dx_co2_u_tr;
dx(13) = dx_co3_u_tr;
dx(14) = dx_co4_u_tr;
dx(15) = dx_co5_u_tr;
dx(16) = dx_fa_u_tr;
dx = dx(:);

