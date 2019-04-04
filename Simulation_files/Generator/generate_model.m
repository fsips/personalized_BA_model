function [model_info, data_vec, CF_base] = generate_model(file, file2, use_mex)

filename                                = [file, '.xlsx'];
filename2                               = [file2, '.xlsx'];
folder                                  = ['Human\'];

%% Read out parameters and constants
try
    [c_full,c_tran,p,l,h,typ,depen]     = read_excel_model(filename); 
catch
    load([file, '.mat']);
end

%% Generate states
[o_full,L_full, ss_full]                = generate_states(c_full, 1);  
[o_tran,L_tran, ss_tran]                = generate_states(c_tran, 0); 

%% Generate parameter vectors
[c_loc, filename_c, p_loc, filename_p]  = generate_vecs(file, folder, c_full, p);

%% Generate model files: full model

% Generate ode
[filename_full_ode]                     = generate_ode(file, folder, c_full, p, o_full, L_full, c_loc, p_loc, depen);

% Generate mex
[mStruct_full, filename_full_mex]       = generate_ode_mex(file, folder, c_full, p, o_full, L_full, c_loc, p_loc, depen);

% Generate variable calculator
[filename_full_var]                     = generate_var(file, folder, c_full, p, o_full, L_full, c_loc, p_loc, depen);

%% Generate model files: transit model

% Generate ode
[filename_tran_ode]                     = generate_ode(file, folder, c_tran, p, o_tran, L_tran, c_loc, p_loc, depen);

% Generate mex
[mStruct_tran, filename_tran_mex]       = generate_ode_mex(file, folder, c_tran, p, o_tran, L_tran, c_loc, p_loc, depen);

% Generate variable calculator
[filename_tran_var]                     = generate_var(file, folder, c_tran, p, o_tran, L_tran, c_loc, p_loc, depen);

%% Generate CF
if ~isempty(file2)
    CF_base                             = retrieve_CD(filename2);
    [filename_CF, data_vec, data_loc]   = generate_CF(file, folder, CF_base, c_full);
else
    CF_base     = [];
    filename_CF = '';
    data_vec = [];
    data_loc = [];
end

%% Create handles
h_ode_full                              = str2func(filename_full_ode);
h_var_full                              = str2func(filename_full_var);
h_ode_tran                              = str2func(filename_tran_ode);
h_var_tran                              = str2func(filename_tran_var);
h_c                                     = str2func(filename_c);
h_p                                     = str2func(filename_p);
if ~isempty(filename_CF)
    h_cf                                    = str2func(filename_CF);
else
    h_cf                                    = [];
end

%% Compile mex files
tic
if use_mex
    convertToC( mStruct_full, [filename_full_mex, '.m']);
    compileC( 'odeC_full' );
    
    convertToC( mStruct_tran, [filename_tran_mex, '.m']);
    compileC( 'odeC_tran' );
end
toc

%% Create model information

% Constants
model_info.c                            = c_full;
model_info.c_tran                       = c_tran;
model_info.c_loc                        = c_loc;

% Parameters    
model_info.p                            = p;
model_info.l                            = l;
model_info.h                            = h;
model_info.p_loc                        = p_loc;

% Length of initial state vector
model_info.L                            = L_full;
model_info.o                            = o_full;
model_info.x0                           = zeros(L_full,1);
model_info.ss                           = ss_full;

model_info.L_tran                       = L_tran;
model_info.o_tran                       = o_tran;
model_info.x0_tran                      = zeros(L_tran,1);
model_info.ss_tran                      = ss_tran;

% Files
model_info.h_ode_full                   = h_ode_full;
model_info.h_var_full                   = h_var_full;
model_info.h_ode_tran                   = h_ode_tran;
model_info.h_var_tran                   = h_var_tran;
model_info.h_c                          = h_c;
model_info.h_p                          = h_p;
model_info.h_cf                         = h_cf;

% Create vectors
model_info.c_vec                        = model_info.h_c(model_info.c);
model_info.p_vec                        = model_info.h_p(model_info.p);
model_info.l_vec                        = model_info.h_p(model_info.l);
model_info.h_vec                        = model_info.h_p(model_info.h);

% Data locations
model_info.data_loc                     = data_loc;

% Simulation setting
model_info.mex_settings                 = [ 1e-6 1e-8 10 ];
