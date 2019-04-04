function [sens] = calculate_sensitivity(results, sub_num, delta)

sp      = [];
p0      = results.simtype.A2.all.pvectors(results.simtype.A2.best.locati(sub_num),:);
E0      =     TRIPLO_meal_CF5(p0 , ...
        results.simtype.A2.all.model_info, ...
        results.data{sub_num}.meal, ...
        [0 0 0 0 0 0], sub_num, sp, results.data_struct, [1:8]);
E0      = E0(1:end-2);

for it = 1:length(p0)
    p_plus      = p0;
    p_plus(it)  = p_plus(it) * (1+delta);
    E_plus      = TRIPLO_meal_CF5(p_plus , ...
        results.simtype.A2.all.model_info, ...
        results.data{sub_num}.meal, ...
        [0 0 0 0 0 0], sub_num, sp, results.data_struct, [1:8]);
    E_plus = E_plus(1:end-2);
    
    p_min       = p0;
    p_min(it)   = p_min(it) * (1-delta);
    E_min       = TRIPLO_meal_CF5(p_min , ...
        results.simtype.A2.all.model_info, ...
        results.data{sub_num}.meal, ...
        [0 0 0 0 0 0], sub_num, sp, results.data_struct, [1:8]);
    E_min = E_min(1:end-2);
    
    sens(it)    = (sum(E_plus - E0).^2 + sum(E_min - E0).^2) / (2*delta);
end
       