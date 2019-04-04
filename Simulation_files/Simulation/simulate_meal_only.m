function [day] = simulate_meal_only(p_vec, x0, model_info, mex)

% Update
current_start               = 0;
current_end                 = 6*60;
current_step                = 5;
model_info.c_vec(model_info.c_loc.tau) = 0;

if mex
    [t_t_new,x_t_new]       = odeC_full([current_start:current_step:current_end], x0, p_vec, model_info.c_vec, [model_info.mex_settings]); t_new = t_t_new'; x_new = x_t_new';
else
    options = odeset('RelTol', 1e-6, 'AbsTol', 1e-9);
    [t_new,x_new]           = ode15s(model_info.h_ode_full, [current_start:current_step:current_end], x0, options, p_vec, model_info.c_vec);
end

% Add simulation results to results vectors
t                           = t_new;
x                           = x_new;
tau_vector                  = ones(size(t_new))*current_start;


%% Calculate states and variables for all /  the last 24 h period
for index = 1:length(t)
    v(index)     = model_info.h_var_full(t(index), x(index,:), p_vec, model_info.c_vec);
end

day.t               = t;
day.x               = x;
day.v               = v;


