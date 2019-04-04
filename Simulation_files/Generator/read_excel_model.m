function [c_full,c_tran,p,l,h,type,depen] = read_excel_model(filename)

%% Full model

% BA species
[~, ~, BA]      = xlsread(filename, 'BA species',        'B3:C18');
BAs             = {};
BA_loc          = [];
for it_BA = 1:size(BA,1)
    if BA{it_BA,2}
        BAs{length(BAs)+1}  = BA{it_BA,1};
        BA_loc              = [BA_loc it_BA];
    end
end
c.BAs           = BAs;

% Parameters and constants 
[~, ~, params]  = xlsread(filename, 'Overview',          'A3:L72');
depen           = {};

for it = 1:size(params,1)
    if params{it,2} == 1
        % Parameter to fit
        p.(params{it,1})    = params{it,3};
        l.(params{it,1})    = params{it,4};
        h.(params{it,1})    = params{it,5};
        type.(params{it,1}) = 'p';
        
    elseif params{it,6} == 1
        % Dependent variable
        len_depen = length(depen);
        if strcmp(params{it,1}, 'frac_gu')
            for prefix = {'empty', 'v'};
                if strcmp(prefix{1}, 'empty')
                    pr = '';
                elseif strcmp(prefix{1}, 'v')
                    pr = 'v.';
                end
                var_temp = [pr, 'frac_gu = 1-', pr, 'frac_tu; \n'];
                
                depen{len_depen+1}.(prefix{1}) = var_temp;
            end
            
        elseif strncmp(params{it,1}, 'frac', 4)
            for prefix = {'empty', 'v'};
                if strcmp(prefix{1}, 'empty')
                    pr = '';
                elseif strcmp(prefix{1}, 'v')
                    pr = 'v.';
                end
                var_temp = [pr, params{it,1},' = 1 - ('];
                for it_BA = 1:length(BAs)
                    if ~strcmp(params{it,1}(6:end), BAs{it_BA})
                        var_temp = [var_temp, ' + ', pr, 'frac_', BAs{it_BA}];
                    end
                end
                var_temp = [var_temp, '); \n'];
                depen{len_depen+1}.(prefix{1}) = var_temp;
            end
        end
        type.(params{it,1}) = 'v';
        
    elseif params{it,8} == 1
        % Constant value
        c.(params{it,1}) = params{it,9};
        type.(params{it,1}) = 'c';
        
    end
end
fit_parameters  = fieldnames(p);

% Construct a list of constants and parameters that must be set to 0 in
% transit experiments
counter = 1;
for it = 1:size(params,1)
    if params{it,12} == 1
        % Add to list of parameters/constants to set to 0
        transit_exp_list(counter).name      = (params{it,1});
        transit_exp_list(counter).type      = type.(params{it,1});
        counter = counter+1;
    end
end
c.transit_exp_list = transit_exp_list;

% States
[~, ~, states]  = xlsread(filename, 'Conjugation',       'B3:C5');
c.states        = {'u'};
c.states_c      = {};
for it = 1:size(states,1)
    if states{it,2}
        c.states{length(c.states)+1}        = states{it,1};
        c.states_c{length(c.states_c)+1}    = states{it,1};
    end
end

% Tissues : full model
tissues         = {'li', 'gb', 'si', 'co', 'fa', 'pl'};
tissues_exp = {};
for it = 1:length(tissues)
    if tissues{it} == 'si'
        for it_si = 1:c.num_si
            tissues_exp{length(tissues_exp)+1} = ['si', num2str(it_si)];
        end
    elseif tissues{it} == 'co'
        for it_co = 1:c.num_co
            tissues_exp{length(tissues_exp)+1} = ['co', num2str(it_co)];
        end
    else
        tissues_exp{length(tissues_exp)+1} = tissues{it};
    end
end
c.tissues  = tissues_exp;

% ASBT distribution
c.si_asbt       = num2cell(xlsread(filename, 'ASBT distribution', 'B3:B12'));

% Bacterial distribution
[~, ~, bact]    = xlsread(filename, 'Bacteria',                   'A3:B17');
bact_cell       = {};
for it1 = 1:size(bact,1)
    if isnan(bact{it1,2})
        bact_cell{it1} = 0;
    else
        bact_cell{it1} = bact{it1,2};
    end
end  
c.bact          = bact_cell;
c.bact          = c.bact';

% Extraction
[~, ~, extra_li]= xlsread(filename, 'Extraction',                 'A3:B18');
extra_li_num    = {};
for it1 = 1:size(extra_li,1)
    if isnan(extra_li{it1,2})
        extra_li_num{it1} = 0;
    else
        extra_li_num{it1} = extra_li{it1,2};
    end
end     
c.extra_li      = extra_li_num(BA_loc);

% Transit, SI and colon
[~,~,k_si_trans]    = xlsread(filename, 'Transport',              'T4:AD13');
[~,~,k_co_trans]    = xlsread(filename, 'Transport',              'T17:Y21');

for it1 = 1:size(k_si_trans,1)
    for it2 = 1:size(k_si_trans,2)
        if isnan(k_si_trans{it1,it2})
            c.k_si_trans{it1,it2} = 0;
        else
            c.k_si_trans{it1,it2} = k_si_trans{it1,it2}; 
        end
    end
end

for it1 = 1:size(k_co_trans,1)
    for it2 = 1:size(k_co_trans,2)
        if isnan(k_co_trans{it1,it2})
            c.k_co_trans{it1,it2} = 0;
        else
            c.k_co_trans{it1,it2} = k_co_trans{it1,it2};
        end
    end
end

% Deconjugation
% Only for exemplification

% Biotransformation, liver and intestines
[~, ~, biotr_in]= xlsread(filename, 'Transformation',            'E6:S20');
biotr_in_num    = {}; 
for it1 = 1:size(biotr_in,1)
    for it2 = 1:size(biotr_in,2)
        if isnan(biotr_in{it1,it2})
            biotr_in_num{it1,it2} = 0;
        else
            biotr_in_num{it1,it2} = biotr_in{it1,it2};
        end
    end
end   
if sum(strcmp(c.BAs, 'tr'))
    c.biotr_in      = biotr_in_num(BA_loc(1:end-1), BA_loc(1:end-1));
else
    c.biotr_in      = biotr_in_num(BA_loc, BA_loc);
end

[~, ~, biotr_li]= xlsread(filename, 'Transformation', 'E29:S43');
biotr_li_num    = {};
for it1 = 1:size(biotr_li,1)
    for it2 = 1:size(biotr_li,2)
        if isnan(biotr_li{it1,it2})
            biotr_li_num{it1,it2} = 0;
        else
            biotr_li_num{it1,it2} = biotr_li{it1,it2};
        end
    end
end     
if sum(strcmp(c.BAs, 'tr'))
    c.biotr_li      = biotr_li_num(BA_loc(1:end-1), BA_loc(1:end-1));
else
    c.biotr_li      = biotr_li_num(BA_loc, BA_loc);
end

c_full = c;

%% Transit model
c_tran          = c;

% Tissues : transit model
tissues         = {'si', 'co', 'fa'};
tissues_exp = {};
for it = 1:length(tissues)
    if tissues{it} == 'si'
        for it_si = 1:c.num_si
            tissues_exp{length(tissues_exp)+1} = ['si', num2str(it_si)];
        end
    elseif tissues{it} == 'co'
        for it_co = 1:c.num_co
            tissues_exp{length(tissues_exp)+1} = ['co', num2str(it_co)];
        end
    else
        tissues_exp{length(tissues_exp)+1} = tissues{it};
    end
end
c_tran.tissues  = tissues_exp;

% BAs and states
c_tran.BAs           = {'tr'};
c_tran.states        = {'u'};


