%% FIGURE 5 FILE FOR THE SOFTWARE ACCOMPANYING:
%
%  Title:   "Model-based data analysis of individual human postprandial 
%           plasma bile acid responses indicates a major role for the 
%           gallbladder and intestine"
%
%  Authors: Emma C.E. Meessen, Fianne L.P. Sips, Hannah M. Eggink, 
%           Martijn Koehorst,  Johannes A. Romijn, Albert K. Groen,
%           Natal A.W. van Riel and Maarten R. Soeters.
%
%  Contact: Eindhoven University of Technology, F.L.P. Sips (f.l.p.sips@tue.nl)

%% ------------------------------------------------------------------------
%  Preparations: add all local folders to the path
%  ------------------------------------------------------------------------

% Note: run this file from the "Simulation_files" folder
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
%  Figure 5
%  ------------------------------------------------------------------------
plot_sensitivity_individual(0);
