%% FIGURE 1 FILE FOR THE SOFTWARE ACCOMPANYING:
%
%  Title:   "Differences in intestinal bile acid handling and gallbladder 
%           contraction explain inter- and intra-individual variability of 
%           postprandial bile acid responses"
%
%  Authors: Emma C.E. Meessen, Fianne L.P. Sips, Hannah M. Eggink, 
%           Martijn Koehorst,  Johannes A. Romijn, Albert K. Groen,
%           Natal A.W. van Riel and Maarten R. Soeters.
%
%  Contact: Eindhoven University of Technology, F.L.P. Sips (f.l.p.sips@tue.nl)

%% ------------------------------------------------------------------------
%  Preparations: add all local folders to the path
%  ------------------------------------------------------------------------

% Note: run this file from the "BA_model_package" folder
addpath(genpath(pwd)) 

%% ------------------------------------------------------------------------
%  Retrieve results and TBA data
%  ------------------------------------------------------------------------

% Which subjects should be included?
loc_subs            = [1 2 3 4 5 6 7 8];
cs_simulated        = {[196 39 28]/256};

% Retrieve optimization results
load('results_TRIPLO');
load('data_TRIPLO');

%% ------------------------------------------------------------------------
%  Figure 3
%  ------------------------------------------------------------------------

plot_subs   = [5 2];
plot_meal   = [1 0];
sp{2}.h     = figure();
for it = 1:length(plot_subs)
    sub_num     = plot_subs(it);
    sp{2}.ys    = 2;
    sp{2}.xs    = 3;
    sp{2}.cs    = cs_simulated;
    sp{2}.loc   = (it-1)*3+[1 2 3];
     
    TRIPLO_meal_simulation(results_TRIPLO.all.pvectors(results_TRIPLO.best.locati(sub_num),:), ...
        results_TRIPLO.all.model_info, ...
        sub_num, ...
        data_TRIPLO, ...
        [plot_meal(it) 1], sp, 0);
end
