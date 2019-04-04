function [mx, tom, m30] = find_characteristics(t, x)

% Maximal fold change and time
index                   = find( x == max(x));
tom                     = t(index) - t(1);
mx                      = max(x) / x(1);

% 30 minute fold change
m30                     = interp1(t-t(1), x, 30) / x(1);


