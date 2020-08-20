function [xcf] = crosscorr(x,y)

x_m = x - mean (x);
y_m = y - mean (y);

xcf = xcorr(y_m,x_m)/(std(x_m)*std(y_m));
xcf = xcf/(length(x_m));
