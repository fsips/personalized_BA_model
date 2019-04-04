function [mStruct] = generate_body(f, prefix, c, p, o, L, c_loc, p_loc, depen, mex)

%% A. Assignments

is_full = sum(strcmp('li', c.tissues));

if ~mex
    mStruct = [];
end

fprintf(f, ['%% A.1 States \n']);

for it_state = 1:L
    fprintf(f, [prefix,o{it_state},' = x(', num2str(it_state), ');\n']);
    if mex
        mStruct.s.(o{it_state}) = it_state;
    end
end
fprintf(f, ['\n']);

fprintf(f, ['%% A.2 Constants \n']);
fn = fieldnames(c_loc);
for it = 1:length(fn)
    if size(c_loc.(fn{it}),1) * size(c_loc.(fn{it}),2) > 1
        for it_y = 1:size(c_loc.(fn{it}),1)
            if size(c_loc.(fn{it}),2) > 1
                for it_x = 1:size(c_loc.(fn{it}),2)
                    if ~isempty((c_loc.(fn{it}){it_y, it_x}))
                        fprintf(f, [prefix,fn{it},'_', num2str(it_y),'_',num2str(it_x),'  = u(',num2str(c_loc.(fn{it}){it_y, it_x}),'); \n']);
                        if mex
                            mStruct.u.([fn{it},'_', num2str(it_y),'_',num2str(it_x)]) = c_loc.(fn{it}){it_y, it_x};
                        end
                    end
                end
            else
                fprintf(f, [prefix,fn{it},'_', num2str(it_y),'  = u(',num2str(c_loc.(fn{it}){it_y}),'); \n']);
                if mex
                    mStruct.u.([fn{it},'_', num2str(it_y)]) = c_loc.(fn{it}){it_y};
                end
            end
        end
    else
        fprintf(f, [prefix,fn{it},' = u(',num2str(c_loc.(fn{it})),'); \n']);
        if mex
            mStruct.u.(fn{it}) = c_loc.(fn{it});
        end
    end
end

fprintf(f, ['\n']);

fprintf(f, ['%% A.3 Parameters \n']);
fn = fieldnames(p_loc);
for it = 1:length(fn)
    if size(p_loc.(fn{it}),1) * size(p_loc.(fn{it}),2) > 1
        for it_y = 1:size(p_loc.(fn{it}),1)
            if size(p_loc.(fn{it}),2) > 1
                for it_x = 1:size(p_loc.(fn{it}),2)
                    fprintf(f, [prefix,fn{it},'_', num2str(it_y),'_',num2str(it_x),'  = p(',num2str(c_loc.(fn{it}){it_y, it_x}),'); \n']);
                    if mex
                        mStruct.p.([fn{it},'_', num2str(it_y),'_',num2str(it_x)]) = p_loc.(fn{it}){it_y, it_x};
                    end
                end
            else
                fprintf(f, [prefix,fn{it},'_', num2str(it_y),'  = p(',num2str(c_loc.(fn{it}){it_y}),'); \n']);
                if mex
                    mStruct.p.([fn{it},'_', num2str(it_y)]) = p_loc.(fn{it}){it_y};
                end
            end
        end
    else
        fprintf(f, [prefix,fn{it},' = p(',num2str(p_loc.(fn{it})),'); \n']);
        if mex
            mStruct.p.(fn{it}) = p_loc.(fn{it});
        end
    end
end

fprintf(f, ['\n']);

fprintf(f, ['%% A.4 Transit parameters \n']);
for it1 = 1:size(c.k_si_trans,1)
    for it2 = 1:size(c.k_si_trans,2)
        if ~strcmp(c.k_si_trans{it1,it2}, '')
            fprintf(f, [prefix,'k_si_trans_',num2str(it1),'_',num2str(it2),' = ',prefix, c.k_si_trans{it1,it2},'; \n']);
        end
    end
end
for it1 = 1:size(c.k_co_trans,1)
    for it2 = 1:size(c.k_co_trans,2)
        if ~strcmp(c.k_co_trans{it1,it2}, '')
            fprintf(f, [prefix,'k_co_trans_',num2str(it1),'_',num2str(it2),' = ',prefix, c.k_co_trans{it1,it2},'; \n']);
        end
    end
end
fprintf(f, ['\n']);

fprintf(f, ['%% A.5 Biotransformation parameters \n']);
for it1 = 1:size(c.biotr_in,1)
    for it2 = 1:size(c.biotr_in,2)
        if c.biotr_in{it1,it2}~=0
            fprintf(f, [prefix,'biotr_in_',num2str(it1),'_',num2str(it2),' = ',prefix, c.biotr_in{it1,it2},'; \n']);
        end
    end
end
for it1 = 1:size(c.biotr_li,1)
    for it2 = 1:size(c.biotr_li,2)
        if c.biotr_li{it1,it2}~=0
            fprintf(f, [prefix,'biotr_li_',num2str(it1),'_',num2str(it2),' = ',prefix, c.biotr_li{it1,it2},'; \n']);
        end
    end
end
for it1 = 1:size(c.bact,1)
    if c.bact{it1}~=0
        fprintf(f, [prefix,'bact_',num2str(it1), ' = ',prefix, c.bact{it1},'; \n']);
    end
end
fprintf(f, ['\n']);

fprintf(f, ['%% A.6 Hepatic extraction parameters \n']);
if is_full
    for it1 = 1:size(c.extra_li,2)
        if c.extra_li{it1}~=0
            % Hepatic extractions
            fprintf(f, [prefix,'hep_extr_c',c.BAs{it1},' = ',prefix, c.extra_li{it1},'; \n']);
            fprintf(f, [prefix,'hep_extr_u',c.BAs{it1},' = ',prefix,'frac_li_u * ',prefix, c.extra_li{it1},'; \n']);
            % Variables
            fprintf(f, [prefix,'k_lp_c',c.BAs{it1},' = ',prefix,'Q_L * ',prefix,'hep_extr_c',c.BAs{it1},'; \n']);
            fprintf(f, [prefix,'k_lp_u',c.BAs{it1},' = ',prefix,'Q_L * ',prefix,'hep_extr_u',c.BAs{it1},'; \n']);
            
        end
    end
    % No else - if transit model, no extraction parameters needed
end

fprintf(f, ['\n']);

fprintf(f, ['%% A.7 Dependables \n']);
if strcmp(prefix, '')
    pref_code = 'empty';
elseif strcmp(prefix, 'v.')
    pref_code = 'v';
end
for it = 1:length(depen)
    fprintf(f, depen{it}.(pref_code));
end

fprintf(f, ['\n']);



%% B. GI-reflex
fprintf(f, ['%% B.1 Postprandial status \n']);

if mex
    fprintf(f, [prefix, 'curr_GI_reflex_GB1_raw = (t - ',prefix,'tau)  / pow(',prefix,'GIr_beta_GB1,2.0) * exp(-1*pow((t - ',prefix,'tau) , 2.0)  / (2*pow(',prefix,'GIr_beta_GB1,2.0)));\n']);
    fprintf(f, [prefix, 'curr_GI_reflex_GB1_max = ',prefix,'GIr_beta_GB1 / pow(',prefix,'GIr_beta_GB1,2.0) * exp(-1*pow(',prefix,'GIr_beta_GB1,2.0) /(2*pow(',prefix,'GIr_beta_GB1,2.0)));\n']);
    
    fprintf(f, [prefix, 'curr_GI_reflex_GB2_raw = (t - ',prefix,'tau)  / pow(',prefix,'GIr_beta_GB2,2.0) * exp(-1*pow((t - ',prefix,'tau) , 2.0)  / (2*pow(',prefix,'GIr_beta_GB2,2.0)));\n']);
    fprintf(f, [prefix, 'curr_GI_reflex_GB2_max = ',prefix,'GIr_beta_GB2 / pow(',prefix,'GIr_beta_GB2,2.0) * exp(-1*pow(',prefix,'GIr_beta_GB2,2.0) /(2*pow(',prefix,'GIr_beta_GB2,2.0)));\n']);
    
    fprintf(f, [prefix, 'curr_GI_reflex_GB = 1.0 +',prefix,'GIr_delta_GB1 *  curr_GI_reflex_GB1_raw / curr_GI_reflex_GB1_max +',prefix,'GIr_delta_GB2 *  curr_GI_reflex_GB2_raw / curr_GI_reflex_GB2_max; \n']);
    
    fprintf(f, [prefix, 'curr_GI_reflex_SI_raw = (t - ',prefix,'tau)  / pow(',prefix,'GIr_beta_SI,2.0) * exp(-1*pow((t - ',prefix,'tau) , 2.0)  / (2*pow(',prefix,'GIr_beta_SI,2.0)));\n']);
    fprintf(f, [prefix, 'curr_GI_reflex_SI_max = ',prefix,'GIr_beta_SI / pow(',prefix,'GIr_beta_SI,2.0) * exp(-1*pow(',prefix,'GIr_beta_SI,2.0) /(2*pow(',prefix,'GIr_beta_SI,2.0)));\n']);
    fprintf(f, [prefix, 'curr_GI_reflex_SI = 1.0 +',prefix,'GIr_delta_SI *  curr_GI_reflex_SI_raw / curr_GI_reflex_SI_max; \n']);
    
else
    fprintf(f, [prefix,'curr_GI_reflex_GB1 = max(GI_reflex(',prefix,'GIr_beta_GB1, ',prefix,'GIr_delta_GB1, t - ',prefix,'tau), 1); \n']);
    fprintf(f, [prefix,'curr_GI_reflex_GB2 = max(GI_reflex(',prefix,'GIr_beta_GB2, ',prefix,'GIr_delta_GB2, t - ',prefix,'tau), 1); \n']);
    fprintf(f, [prefix,'curr_GI_reflex_GB  = ',prefix,'curr_GI_reflex_GB1 + ',prefix,'curr_GI_reflex_GB2 -1; \n']);
    fprintf(f, [prefix,'curr_GI_reflex_SI = max(GI_reflex(',prefix,'GIr_beta_SI, ',prefix,'GIr_delta_SI, t - ',prefix,'tau), 1); \n']);
end
fprintf(f, ['\n']);

fprintf(f, ['%% B.2 Multiply parameters that are GIr-sensitive with GIr \n']);
fprintf(f, [prefix,'k_xg       = ',prefix,'k_xg          * ',prefix,'curr_GI_reflex_GB; \n']);
for it1 = 1:size(c.k_si_trans,1)
    for it2 = 1:size(c.k_si_trans,2)
        if ~strcmp(c.k_si_trans{it1,it2}, '')
            fprintf(f, [prefix,'k_si_trans_',num2str(it1),'_',num2str(it2),' = ',prefix,'k_si_trans_',num2str(it1),'_',num2str(it2),'  * ',prefix,'curr_GI_reflex_SI; \n']);
        end
    end
end
for it1 = 1:size(c.k_co_trans,1)
    for it2 = 1:size(c.k_co_trans,2)
        if ~strcmp(c.k_co_trans{it1,it2}, '')
            fprintf(f, [prefix,'k_co_trans_',num2str(it1),'_',num2str(it2),' = ',prefix,'k_co_trans_',num2str(it1),'_',num2str(it2),'  * ',prefix,'curr_GI_reflex_SI; \n']);
        end
    end
end


%% C. Metabolic fluxes

if is_full % Only in full model
    
    fprintf(f, ['%% C.1 Liver (out) fluxes \n']);
    
    % To bile
    for curr_state = c.states
        for curr_BA = c.BAs
            fprintf(f, [prefix,'x_li_',curr_state{1}, '_',curr_BA{1}, '= ',prefix,'k_xl * ',prefix,'li_',curr_state{1}, '_',curr_BA{1},'; \n']);
        end
    end
    fprintf(f, ['\n']);
    
    % To plasma
    for curr_state = c.states
        for curr_BA = c.BAs
            fprintf(f, [prefix,'x_li_',curr_state{1}, '_',curr_BA{1}, '_toplasma = ',prefix,'k_pl * ',prefix,'li_',curr_state{1}, '_',curr_BA{1},'; \n']);
        end
    end
    fprintf(f, ['\n']);
    
    fprintf(f, ['%% C.2 Gallbladder (in) fluxes \n']);
    for curr_state = c.states
        for curr_BA = c.BAs
            fprintf(f, [prefix,'gb_li_',curr_state{1}, '_',curr_BA{1}, '= ',prefix,'frac_gb * ',prefix,'x_li_',curr_state{1}, '_',curr_BA{1}, '; \n']);
        end
    end
    fprintf(f, ['\n']);
    
    fprintf(f, ['%% C.3 Gallbladder (out) fluxes \n']);
    for curr_state = c.states
        for curr_BA = c.BAs
            fprintf(f, [prefix,'x_gb_',curr_state{1}, '_',curr_BA{1}, '= ',prefix,'k_xg * ',prefix,'gb_',curr_state{1}, '_',curr_BA{1}, '; \n']);
        end
    end
    fprintf(f, ['\n']);
    
    fprintf(f, ['%% C.4 Small intestine (in) fluxes \n']);
    fprintf(f, ['%% (directly from liver) \n']);
    for curr_state = c.states
        for curr_BA = c.BAs
            fprintf(f, [prefix,'si1_li_',curr_state{1}, '_',curr_BA{1}, '=(1.0-',prefix,'frac_gb) * ',prefix,'x_li_',curr_state{1}, '_',curr_BA{1}, ';\n']);
            for it_si = 2:c.num_si
                fprintf(f, [prefix,'si',num2str(it_si),'_li_',curr_state{1}, '_',curr_BA{1}, '= 0.0; \n']);
            end
        end
    end
    fprintf(f, ['\n']);
    fprintf(f, ['%% (from gallbladder) \n']);
    for curr_state = c.states
        for curr_BA = c.BAs
            fprintf(f, [prefix,'si1_gb_',curr_state{1}, '_',curr_BA{1}, '= ',prefix,'x_gb_',curr_state{1}, '_',curr_BA{1},'; \n']);
            for it_si = 2:c.num_si
                fprintf(f, [prefix,'si',num2str(it_si),'_gb_',curr_state{1}, '_',curr_BA{1}, '= 0.0; \n']);
            end
        end
    end
    fprintf(f, ['\n']);
    
end % End of - only in full model

fprintf(f, ['%% (transit fluxes) \n']);
for curr_state = c.states
    for curr_BA = c.BAs
        for it1 = 1:size(c.k_si_trans,1)
            for it2 = 1:size(c.k_si_trans,2)
                if c.k_si_trans{it1,it2}~= 0
                    fprintf(f, [prefix,'si_trans_in_', curr_state{1}, '_',curr_BA{1},'_',num2str(it2), ' = ',prefix,'si',num2str(it1),'_', curr_state{1}, '_',curr_BA{1},' * ',prefix,'k_si_trans_',num2str(it1),'_',num2str(it2),'; \n']);
                    fprintf(f, [prefix,'si_trans_out_', curr_state{1}, '_',curr_BA{1},'_',num2str(it1), '= ',prefix,'si',num2str(it1),'_', curr_state{1}, '_',curr_BA{1},' * ',prefix,'k_si_trans_',num2str(it1),'_',num2str(it2),'; \n']);
                end
            end
        end
    end
end
fprintf(f, ['\n']);

if is_full % Only in full model
    
    fprintf(f, ['%% (deconjugation fluxes) \n']);
    for curr_state = c.states_c
        for curr_BA = c.BAs
            for curr_si = 1:c.num_si
                % Tracer  -if present - is poorly (=not) deconjugated
                if strcmp(curr_BA{1}, 'tr')
                    fprintf(f, [prefix,'si', num2str(curr_si), '_u', curr_state{1}, '_',curr_BA{1}, '= ',prefix,'k_uc_tracer * ',prefix,'k_u',curr_state{1} '* ',prefix,'bact_',num2str(curr_si),' * ',prefix,'si', num2str(curr_si), '_' curr_state{1}, '_',curr_BA{1},'; \n']);
                else
                    fprintf(f, [prefix,'si', num2str(curr_si), '_u', curr_state{1}, '_',curr_BA{1}, '= ',prefix,'k_u',curr_state{1} '* ',prefix,'bact_',num2str(curr_si),' * ',prefix,'si', num2str(curr_si), '_' curr_state{1}, '_',curr_BA{1},'; \n']);
                end

            end
        end
    end
    fprintf(f, ['\n']);
    
    fprintf(f, ['%% C.5 Small intestine (out) fluxes \n']);
    fprintf(f, ['%% (passive uptake) \n']);
    for curr_state = c.states
        for curr_BA = c.BAs
            for curr_si = 1:c.num_si
                fprintf(f, [prefix,'si', num2str(curr_si), '_pu_', curr_state{1}, '_',curr_BA{1}, '= ',prefix,'k_xi_',curr_state{1},'p_si * ',prefix,'si', num2str(curr_si), '_', curr_state{1}, '_',curr_BA{1},'; \n']);
            end
        end
    end
    fprintf(f, ['\n']);
    
    fprintf(f, ['%% (active uptake) \n']);
    si_comp = 1:c.num_si;
    asbt_si = [];
    for it = 1:length(c.si_asbt)
        if c.si_asbt{it}
            asbt_si = [asbt_si, it];
        end
    end
    for curr_si = asbt_si
        curr_BA_conc = [];
        for curr_state = c.states
            for curr_BA = c.BAs
                curr_BA_conc = [curr_BA_conc, ' + ',prefix, 'si', num2str(curr_si), '_', curr_state{1}, '_',curr_BA{1}];
            end
        end
        fprintf(f, [prefix,'si', num2str(curr_si), '= ',curr_BA_conc, '; \n']);
    end
    fprintf(f, ['\n']);
    
    for curr_state = c.states
        for curr_BA = c.BAs
            for curr_si = asbt_si
                if strcmp(curr_BA{1}, 'LCAs')
                    fprintf(f, [prefix,'si', num2str(curr_si), '_au_', curr_state{1}, '_',curr_BA{1}, '= ',prefix,'vmax_asbt_s * ',prefix,'si', num2str(curr_si), '_', curr_state{1}, '_',curr_BA{1},' / (',prefix,'si', num2str(curr_si) ' + ',prefix,'km_asbt); \n']);
                else
                    fprintf(f, [prefix,'si', num2str(curr_si), '_au_', curr_state{1}, '_',curr_BA{1}, '= ',prefix,'vmax_asbt * ',prefix,'si', num2str(curr_si), '_', curr_state{1}, '_',curr_BA{1},' / (',prefix,'si', num2str(curr_si) ' + ',prefix,'km_asbt); \n']);
                end
            end
        end
    end
    fprintf(f, ['\n']);
    
end % End of - only in full model

fprintf(f, ['%% C.6 Colon (in) fluxes \n']);

fprintf(f, ['%% (transit fluxes) \n']);

for curr_state = c.states
    for curr_BA = c.BAs
        for it1 = 1:size(c.k_co_trans,1)
            for it2 = 1:size(c.k_co_trans,2)
                if c.k_co_trans{it1,it2}~= 0
                    fprintf(f, [prefix,'co_trans_in_', curr_state{1}, '_',curr_BA{1},'_',num2str(it2), ' = ',prefix,'co',num2str(it1),'_', curr_state{1}, '_',curr_BA{1},' * ',prefix,'k_co_trans_',num2str(it1),'_',num2str(it2),'; \n']);
                    fprintf(f, [prefix,'co_trans_out_', curr_state{1}, '_',curr_BA{1},'_',num2str(it1), '= ',prefix,'co',num2str(it1),'_', curr_state{1}, '_',curr_BA{1},' * ',prefix,'k_co_trans_',num2str(it1),'_',num2str(it2),'; \n']);
                end
            end
        end
    end
end
fprintf(f, ['\n']);

if is_full % Only in full model
    
    fprintf(f, ['%% (deconjugation fluxes) \n']);
    for curr_state = c.states_c
        for curr_BA = c.BAs
            for curr_co = 1:c.num_co
                % Tracer  -if present - is poorly (=not) deconjugated
                if strcmp(curr_BA{1}, 'tr')
                    fprintf(f, [prefix,'co', num2str(curr_co), '_u', curr_state{1}, '_',curr_BA{1}, '=',prefix,'k_uc_tracer * ',prefix,'k_u',curr_state{1} '* ',prefix,'bact_',num2str(curr_co+c.num_si),' * ',prefix,'co', num2str(curr_co), '_' curr_state{1}, '_',curr_BA{1},'; \n']);
                else
                    fprintf(f, [prefix,'co', num2str(curr_co), '_u', curr_state{1}, '_',curr_BA{1}, '=',prefix,'k_u',curr_state{1} '* ',prefix,'bact_',num2str(curr_co+c.num_si),' * ',prefix,'co', num2str(curr_co), '_' curr_state{1}, '_',curr_BA{1},'; \n']);
                end
            end
        end
    end
    fprintf(f, ['\n']);
    
    fprintf(f, ['%% C.7 Colon (out) fluxes \n']);
    fprintf(f, ['%% (passive uptake) \n']);
    for curr_state = c.states
        for curr_BA = c.BAs
            for curr_co = 1:c.num_co
                fprintf(f, [prefix,'co', num2str(curr_co), '_pu_', curr_state{1}, '_',curr_BA{1}, '= ',prefix,'k_xi_',curr_state{1},'p_co * ',prefix,'co', num2str(curr_co), '_', curr_state{1}, '_',curr_BA{1},'; \n']);
            end
        end
    end
    fprintf(f, ['\n']);
    
    fprintf(f, ['%% (biotransformations) \n']);
    
    for curr_state = {'u'}
        for curr_BA = c.BAs
            for it_co = 1:c.num_co
                fprintf(f, [prefix,'co',num2str(it_co),'_biotr_out_',curr_state{1}, '_',curr_BA{1}, '= 0.0; \n']);
                fprintf(f, [prefix,'co',num2str(it_co),'_biotr_in_',curr_state{1}, '_',curr_BA{1}, '= 0.0; \n']);
            end
        end
    end
    
    for it_from = 1:size(c.biotr_in,1)
        for it_to = 1:size(c.biotr_in,2)
            if c.biotr_in{it_from, it_to} ~=0
                for it_co = 1:c.num_co
                    fprintf(f, [prefix,'co',num2str(it_co),'_biotr_out_u_',c.BAs{it_from}, '= ',prefix,'co',num2str(it_co),'_biotr_out_u_',c.BAs{it_from}, '+ ',prefix,'bact_',num2str(c.num_si+it_co),' * ',prefix,'biotr_in_',num2str(it_from), '_', num2str(it_to), '* ',prefix,'co',num2str(it_co), '_u_', c.BAs{it_from}, '; \n']);
                    fprintf(f, [prefix,'co',num2str(it_co),'_biotr_in_u_',c.BAs{it_to}, '= ',prefix,'co',num2str(it_co),'_biotr_in_u_',c.BAs{it_to}, '+ ',prefix,'bact_',num2str(c.num_si+it_co),' * ',prefix,'biotr_in_',num2str(it_from), '_', num2str(it_to), '* ',prefix,'co',num2str(it_co), '_u_', c.BAs{it_from}, '; \n']);
                end
            end
        end
    end
    fprintf(f, ['\n']);
    
    
    fprintf(f, ['%% C.8 Faeces (in) fluxes \n']);
    
    
    fprintf(f, ['%% C.9 Plasma (in) fluxes \n']);
    
    
    fprintf(f, ['%% (from liver) \n']);
    for curr_state = c.states
        for curr_BA = c.BAs
            fprintf(f, [prefix,'pl_li_',curr_state{1}, '_',curr_BA{1}, ' = ',prefix,'k_pl * ',prefix,'li_',curr_state{1}, '_',curr_BA{1},'/ ',prefix,'V_P;\n']);
        end
    end
    fprintf(f, ['\n']);
    
    fprintf(f, ['%% (uptake from intestine) \n']);
    for curr_state = c.states
        for curr_BA = c.BAs
            passive = [];
            active  = [];
            for curr_si = 1:c.num_si-1
                if sum(asbt_si == curr_si)
                    active  = [active,  prefix,'si', num2str(curr_si), '_au_', curr_state{1}, '_',curr_BA{1}, ' + '];
                end
                passive = [passive, prefix,'si', num2str(curr_si), '_pu_', curr_state{1}, '_',curr_BA{1}, ' + '];
            end
            active  = [active,  prefix,'si', num2str(c.num_si), '_au_', curr_state{1}, '_',curr_BA{1}];
            passive = [passive, prefix,'si', num2str(c.num_si), '_pu_', curr_state{1}, '_',curr_BA{1}];
            fprintf(f, [prefix,'x_si_', curr_state{1}, '_',curr_BA{1} '= ', active, ' + ',passive,';\n']);
        end
    end
    fprintf(f, ['\n']);
    
    for curr_state = c.states
        for curr_BA = c.BAs
            if strcmp(curr_state{1}, 'u')
                fprintf(f, [prefix,'pl_si_', curr_state{1}, '_',curr_BA{1} '= (1.0-',prefix,'hep_extr_u',curr_BA{1}, ') * ',prefix,'x_si_', curr_state{1}, '_',curr_BA{1} '/ ',prefix,'V_P;\n']);
            else
                fprintf(f, [prefix,'pl_si_', curr_state{1}, '_',curr_BA{1} '= (1.0-',prefix,'hep_extr_c',curr_BA{1}, ') * ',prefix,'x_si_', curr_state{1}, '_',curr_BA{1} '/ ',prefix,'V_P;\n']);
            end
        end
    end
    fprintf(f, ['\n']);
    
    fprintf(f, ['%% (uptake from colon) \n']);
    for curr_state = c.states
        for curr_BA = c.BAs
            passive = [];
            active  = [];
            for curr_co = 1:c.num_co-1
                passive = [passive, prefix,'co', num2str(curr_co), '_pu_', curr_state{1}, '_',curr_BA{1}, ' + '];
            end
            passive = [passive, prefix,'co', num2str(c.num_co), '_pu_', curr_state{1}, '_',curr_BA{1}];
            fprintf(f, [prefix,'x_co_', curr_state{1}, '_',curr_BA{1} '= ' ,passive,';\n']);
        end
    end
    fprintf(f, ['\n']);
    
    for curr_state = c.states
        for curr_BA = c.BAs
            if strcmp(curr_state{1}, 'u')
                fprintf(f, [prefix,'pl_co_', curr_state{1}, '_',curr_BA{1} '= (1.0-',prefix,'hep_extr_u',curr_BA{1},') * ',prefix,'x_co_', curr_state{1}, '_',curr_BA{1} '/ ',prefix,'V_P;\n']);
            else
                fprintf(f, [prefix,'pl_co_', curr_state{1}, '_',curr_BA{1} '= (1.0-',prefix,'hep_extr_c',curr_BA{1},') * ',prefix,'x_co_', curr_state{1}, '_',curr_BA{1} '/ ',prefix,'V_P;\n']);
            end
            
        end
    end
    fprintf(f, ['\n']);
    
    fprintf(f, ['%% C.10 Plasma (out) fluxes \n']);
    fprintf(f, ['%% (hepatic clearance) \n']);
    for curr_state = c.states
        for curr_BA = c.BAs
            if strcmp(curr_state{1}, 'u')
                fprintf(f, [prefix,'x_pl_', curr_state{1}, '_',curr_BA{1} '= ',prefix,'k_lp_u',curr_BA{1},' * (',prefix,'pl_', curr_state{1}, '_',curr_BA{1}, ')/ ',prefix,'V_P;\n']);  % 12-10-2016 ADDED /VP
            else
                fprintf(f, [prefix,'x_pl_', curr_state{1}, '_',curr_BA{1} '= ',prefix,'k_lp_c',curr_BA{1},' * (',prefix,'pl_', curr_state{1}, '_',curr_BA{1}, ')/ ',prefix,'V_P;\n']);  % 12-10-2016 ADDED /VP
            end
        end
    end
    fprintf(f, ['\n']);
    
    fprintf(f, ['%% C.11 Liver (in) fluxes \n']);
    
    fprintf(f, ['%% (from synthesis) \n']);
    for curr_state = c.states_c
        for curr_BA = c.BAs
            fprintf(f, [prefix,'li_x_', curr_state{1}, '_',curr_BA{1} '= ',prefix,'frac_',curr_BA{1},' * ',prefix,'frac_',curr_state{1},'u * ',prefix,'k_u;\n']);
        end
    end
    fprintf(f, ['\n']);
    
    fprintf(f, ['%% (from plasma) \n']);
    for curr_state = c.states_c
        for curr_BA = c.BAs
            fprintf(f, [prefix,'li_pl_', curr_state{1}, '_',curr_BA{1} '= (',prefix,'k_lp_c',curr_BA{1},' * (',prefix,'pl_', curr_state{1}, '_',curr_BA{1}, ')  + ',prefix,'k_lp_u',curr_BA{1},' * (',prefix,'frac_',curr_state{1}, 'u * ',prefix,'pl_u_',curr_BA{1}, '));\n']); % 12-10-2016 REMOVED VP
        end
    end
    fprintf(f, ['\n']);
    
    fprintf(f, ['%% (from first pass) \n']);
    for curr_state = c.states_c
        for curr_BA = c.BAs
            fprintf(f, [prefix,'li_si_', curr_state{1}, '_',curr_BA{1} '=  ',prefix,'x_si_', curr_state{1}, '_',curr_BA{1}, ' * ',prefix,'hep_extr_c',curr_BA{1},' + ',prefix,'frac_',curr_state{1}, 'u * ',prefix,'x_si_u_',curr_BA{1}, ' * ',prefix,'hep_extr_u',curr_BA{1},' ;\n']);
        end
    end
    fprintf(f, ['\n']);
    
    for curr_state = c.states_c
        for curr_BA = c.BAs
            fprintf(f, [prefix,'li_co_', curr_state{1}, '_',curr_BA{1} '=  ',prefix,'x_co_', curr_state{1}, '_',curr_BA{1}, ' * ',prefix,'hep_extr_c',curr_BA{1},' + ',prefix,'frac_',curr_state{1}, 'u * ',prefix,'x_co_u_',curr_BA{1}, ' * ',prefix,'hep_extr_u',curr_BA{1},' ;\n']);
        end
    end
    fprintf(f, ['\n']);
    
    fprintf(f, ['%% (biotransformations) \n']);
    
    for curr_state = c.states_c
        for curr_BA = c.BAs
            fprintf(f, [prefix,'li_biotr_out_',curr_state{1}, '_',curr_BA{1}, '= 0.0; \n']);
            fprintf(f, [prefix,'li_biotr_in_',curr_state{1}, '_',curr_BA{1}, '= 0.0; \n']);
        end
    end
    
    for it_from = 1:size(c.biotr_li,1)
        for it_to = 1:size(c.biotr_li,2)
            if c.biotr_li{it_from, it_to} ~=0
                for curr_state = c.states_c
                    fprintf(f, [prefix,'li_biotr_out_',curr_state{1},'_',c.BAs{it_from}, '= ',prefix,'li_biotr_out_',curr_state{1},'_',c.BAs{it_from}, '+ ',prefix,'biotr_li_',num2str(it_from), '_', num2str(it_to), '* ',prefix,'li_',curr_state{1},'_', c.BAs{it_from}, '; \n']);
                    fprintf(f, [prefix,'li_biotr_in_',curr_state{1},'_',c.BAs{it_to}, '= ',prefix,'li_biotr_in_',curr_state{1},'_',c.BAs{it_to}, '+ ',prefix,'biotr_li_',num2str(it_from), '_', num2str(it_to), '* ',prefix,'li_',curr_state{1},'_', c.BAs{it_from}, '; \n']);
                end
            end
        end
    end

    fprintf(f, ['\n']);

end % End of - only in full model