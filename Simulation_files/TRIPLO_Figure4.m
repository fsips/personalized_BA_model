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
%  Figure 4
%  ------------------------------------------------------------------------

plot_par_distributions_TRIPLO(results_TRIPLO, 1, loc_subs);    
