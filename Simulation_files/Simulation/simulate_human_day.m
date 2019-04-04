function [static, days, day, meal, fasting] = simulate_human_day(p_vec, ss_days, meal_days, x0, model_info, mex, is_full)


%% Static simulation - to induce a state in which many BA are present
t_begin             = 0;
t_end               = ss_days*60*24;
t_step              = (t_end - t_begin)/model_info.steps;

if ss_days > 0
    if mex
        if is_full
            [t_t,x_t]       = odeC_full([t_begin t_step t_end], x0, p_vec, model_info.c_vec, model_info.mex_settings); t = t_t'; x = x_t';
        else
            [t_t,x_t]       = odeC_tran([t_begin t_step t_end], x0, p_vec, model_info.c_vec, model_info.mex_settings); t = t_t'; x = x_t';
        end
    else
        if is_full
            options = odeset('RelTol', 1e-6, 'AbsTol', 1e-9);
            [t,x]           = ode15s(model_info.h_ode_full, [t_begin t_step t_end], x0, options, p_vec, model_info.c_vec);
        else
            options = odeset('RelTol', 1e-6, 'AbsTol', 1e-9);
            [t,x]           = ode15s(model_info.h_ode_tran, [t_begin t_step t_end], x0, options, p_vec, model_info.c_vec);
        end
    end
else
    t               = [0];
    x               = [x0'];
end

current_start       = t_end;
tau_vector          = [ones(size(t))*t_begin];

% Save info in static
static.t            = t;
static.x            = x;

%% Meal simulations - to arrange proper time in the intestines

% Make vector of time gaps
gaps = [];
for it_day = 1:meal_days
    for it_meal = 1:length(model_info.gap)
        gaps = [gaps model_info.gap(it_meal)];
    end
end

% Iterative simulations
for it = 1:length(gaps)
    
    steps = model_info.steps;
    
    % Update 
    current_end                 = current_start + gaps(it)*60;
    if it == length(gaps)
        current_step = 10;
    else
        current_step                = (current_end - current_start)/steps;
    end
    
    model_info.c_vec(model_info.c_loc.tau) = current_start;
    
    if mex
        if is_full
            [t_t_new,x_t_new]       = odeC_full([current_start:current_step:current_end], x(end,:), p_vec, model_info.c_vec, [model_info.mex_settings]); t_new = t_t_new'; x_new = x_t_new';
        else
            [t_t_new,x_t_new]       = odeC_tran([current_start:current_step:current_end], x(end,:), p_vec, model_info.c_vec, [model_info.mex_settings]); t_new = t_t_new'; x_new = x_t_new';
        end
    else
        if is_full
            [t_new,x_new]           = ode15s(model_info.h_ode_full, [current_start:current_step:current_end], x(end,:), options, p_vec, model_info.c_vec);
        else
            [t_new,x_new]           = ode15s(model_info.h_ode_tran, [current_start:current_step:current_end], x(end,:), options, p_vec, model_info.c_vec);
        end
    end  
    
    % Add simulation results to results vectors
    t                           = [t;t_new(2:end)];
    x                           = [x;x_new(2:end,:)];
    tau_vector                  = [tau_vector; ones(size(t_new(2:end)))*current_start];
    current_start               = current_end;
end

%% Calculate states and variables for all /  the last 24 h period
if meal_days == 0
    for it = 1:length(t)
        model_info.c_vec(model_info.c_loc.tau)  = tau_vector(it);
        if is_full
            v(it)                                   = model_info.h_var_full(t(it), x(it,:), p_vec, model_info.c_vec);
        else
            v(it)                                   = model_info.h_var_tran(t(it), x(it,:), p_vec, model_info.c_vec);
        end
    end
    static.v        = v;
else
    v = [];
end


index2              = 1;
for index = find(t == current_end-24*60, 1, 'last'):length(t)
    t24(index2)     = t(index);
    x24(index2,:)   = x(index, :);
    model_info.c_vec(model_info.c_loc.tau) = tau_vector(index);
    if is_full
        v24(index2)     = model_info.h_var_full(t24(index2), x24(index2,:), p_vec, model_info.c_vec);
    else
        v24(index2)     = model_info.h_var_tran(t24(index2), x24(index2,:), p_vec, model_info.c_vec);
    end
    index2          = index2+1;
end

% Save info in days / day
days.t              = t;
days.x              = x;
days.tau_vector     = tau_vector;

day.t               = t24;
day.x               = x24;
day.v               = v24;

end_of_meal1        = find(t24 == (current_end-24*60+gaps(1)*60), 1, 'last');
meal.t              = t24(1:end_of_meal1);
meal.x              = x24(1:end_of_meal1,:);
meal.v              = v24(1:end_of_meal1);

%% Fasting variables
fasting.v           = v24(1);
v_to_be_corrected   = {'fa' 'cum'};
v_all_fieldnames    = fieldnames(fasting.v);
for it = 1:length(v_all_fieldnames)
    for it2 = 1:length(v_to_be_corrected)
        if strncmp(v_to_be_corrected{it2}, v_all_fieldnames{it}, length(v_to_be_corrected{it2}))
            fasting.v.(v_all_fieldnames{it}) = v24(end).(v_all_fieldnames{it}) - v24(1).(v_all_fieldnames{it});
        end
    end
end

%% Steady state check
if is_full

    ind_beg_of_day          = find(t == current_end-24*60, 1, 'last');
    ind_end_of_day          = length(t);

    x_beg                   = x(ind_beg_of_day, (model_info.ss>0));
    x_end                   = x(ind_end_of_day, (model_info.ss>0));

    % Clear out the lowest values so that relative changes do not explode
    % for low values
    x_beg(x_beg<1e-8)       = 0;
    x_beg(x_end<1e-8)       = 0;

    % Steady state evaluation
    days.SS                 = sum((x_beg - x_end).^2);
end

%% Meal outputs

if is_full
    [meal.y.max_all, meal.y.tom_all, meal.y.m30_all]                            = find_characteristics(meal.t, [meal.v.plco_state_g]+[meal.v.plco_state_t]+[meal.v.plco_state_u]);
    [meal.y.max_conjugated, meal.y.tom_conjugated, meal.y.m30_conjugated]       = find_characteristics(meal.t, [meal.v.plco_state_g]+[meal.v.plco_state_t]);
    [meal.y.max_unconjugated, meal.y.tom_unconjugated, meal.y.m30_unconjugated] = find_characteristics(meal.t, [meal.v.plco_state_u]);
end
