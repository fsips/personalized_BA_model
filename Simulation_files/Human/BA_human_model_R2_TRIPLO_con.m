function [c_vec] = BA_human_model_R2_TRIPLO_con(c)

c_vec(1) = c.tau;
c_vec(2) = c.k_xl;
c_vec(3) = c.k_xi_tp_si;
c_vec(4) = c.k_xi_tp_co;
c_vec(5) = c.k_xi_gp_si;
c_vec(6) = c.k_xi_gp_co;
c_vec(7) = c.k_xi_cp_si;
c_vec(8) = c.k_xi_cp_co;
c_vec(9) = c.k_xi_up_co;
c_vec(10) = c.vmax_asbt_s;
c_vec(11) = c.km_asbt;
c_vec(12) = c.frac_li_u;
c_vec(13) = c.frac_li_c_1;
c_vec(14) = c.frac_li_c_2;
c_vec(15) = c.frac_li_c_3;
c_vec(16) = c.frac_li_s;
c_vec(17) = c.V_P;
c_vec(18) = c.Q_L;
c_vec(19) = c.Q_P;
c_vec(20) = c.weight;
c_vec(21) = c.frac_cu;
c_vec(22) = c.k_uc;
c_vec(23) = c.k_bact_psi;
c_vec(24) = c.k_bact_co;
c_vec(25) = c.num_si;
c_vec(26) = c.num_co;
c_vec(27) = c.frac_MCAa;
c_vec(28) = c.frac_MCAb;
c_vec(29) = c.frac_DCA;
c_vec(30) = c.frac_HCA;
c_vec(31) = c.frac_HDCA;
c_vec(32) = c.frac_MDCA;
c_vec(33) = c.frac_UDCA;
c_vec(34) = c.frac_LCA;
c_vec(35) = c.frac_LCAs;
c_vec(36) = c.frac_LCAg;
c_vec(37) = c.frac_MCAo;
c_vec(38) = c.frac_MCAg;
c_vec(39) = c.frac_o;
c_vec(40) = c.frac_tr;
c_vec(41) = c.k_tr_5;
c_vec(42) = c.k_tr_6;
c_vec(43) = c.k_pl;
c_vec(44) = c.k_uc_tracer;
c_vec(45) = c.si_asbt{1,1};
c_vec(46) = c.si_asbt{2,1};
c_vec(47) = c.si_asbt{3,1};
c_vec(48) = c.si_asbt{4,1};
c_vec(49) = c.si_asbt{5,1};
c_vec(50) = c.si_asbt{6,1};
c_vec(51) = c.si_asbt{7,1};
c_vec(52) = c.si_asbt{8,1};
c_vec(53) = c.si_asbt{9,1};
c_vec(54) = c.si_asbt{10,1};
c_vec(55) = c.biotr_in{1,1};
c_vec(56) = c.biotr_in{1,2};
c_vec(57) = c.biotr_in{1,4};
c_vec(58) = c.biotr_in{1,5};
c_vec(59) = c.biotr_in{2,1};
c_vec(60) = c.biotr_in{2,2};
c_vec(61) = c.biotr_in{2,3};
c_vec(62) = c.biotr_in{3,1};
c_vec(63) = c.biotr_in{3,2};
c_vec(64) = c.biotr_in{3,3};
c_vec(65) = c.biotr_in{3,4};
c_vec(66) = c.biotr_in{3,5};
c_vec(67) = c.biotr_in{4,1};
c_vec(68) = c.biotr_in{4,2};
c_vec(69) = c.biotr_in{4,3};
c_vec(70) = c.biotr_in{4,4};
c_vec(71) = c.biotr_in{5,1};
c_vec(72) = c.biotr_in{5,2};
c_vec(73) = c.biotr_in{5,3};
c_vec(74) = c.biotr_in{5,4};
c_vec(75) = c.biotr_in{5,5};
c_vec(76) = c.biotr_in{6,1};
c_vec(77) = c.biotr_in{6,2};
c_vec(78) = c.biotr_in{6,3};
c_vec(79) = c.biotr_in{6,4};
c_vec(80) = c.biotr_in{6,5};
c_vec(81) = c.biotr_in{6,6};
c_vec(82) = c.biotr_li{1,1};
c_vec(83) = c.biotr_li{1,2};
c_vec(84) = c.biotr_li{1,3};
c_vec(85) = c.biotr_li{1,4};
c_vec(86) = c.biotr_li{1,5};
c_vec(87) = c.biotr_li{1,6};
c_vec(88) = c.biotr_li{2,1};
c_vec(89) = c.biotr_li{2,2};
c_vec(90) = c.biotr_li{2,3};
c_vec(91) = c.biotr_li{2,4};
c_vec(92) = c.biotr_li{2,5};
c_vec(93) = c.biotr_li{2,6};
c_vec(94) = c.biotr_li{3,1};
c_vec(95) = c.biotr_li{3,2};
c_vec(96) = c.biotr_li{3,3};
c_vec(97) = c.biotr_li{3,4};
c_vec(98) = c.biotr_li{3,5};
c_vec(99) = c.biotr_li{3,6};
c_vec(100) = c.biotr_li{4,1};
c_vec(101) = c.biotr_li{4,2};
c_vec(102) = c.biotr_li{4,3};
c_vec(103) = c.biotr_li{4,4};
c_vec(104) = c.biotr_li{4,5};
c_vec(105) = c.biotr_li{4,6};
c_vec(106) = c.biotr_li{5,1};
c_vec(107) = c.biotr_li{5,2};
c_vec(108) = c.biotr_li{5,3};
c_vec(109) = c.biotr_li{5,4};
c_vec(110) = c.biotr_li{5,5};
c_vec(111) = c.biotr_li{5,6};
c_vec(112) = c.biotr_li{6,1};
c_vec(113) = c.biotr_li{6,2};
c_vec(114) = c.biotr_li{6,3};
c_vec(115) = c.biotr_li{6,4};
c_vec(116) = c.biotr_li{6,5};
c_vec(117) = c.biotr_li{6,6};

end