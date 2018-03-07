clc;    % Clear the command window.
workspace;  % Make sure the workspace panel is showing.
format longg;
format compact;
fontSize = 20;
% Define equation.
x = -2:20;
y = (x-2).^2;
% Plot it
plot(x,y, 'bo-', 'LineWidth', 3);
grid on;
title('y = (x-2).^2', 'FontSize', fontSize);
xlabel('X', 'FontSize', fontSize);
ylabel('Y', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% Give a name to the title bar.
set(gcf,'name','Demo by ImageAnalyst','numbertitle','off') 
% Fit the range fro 10 to 20 with a line.
limitedRange = 10:20;
coeffs = polyfit(x(limitedRange), y(limitedRange), 1)
% Define the range where we want the line
xFitting = 0:19; % Or wherever...
yFitted = polyval(coeffs, xFitting);
% Plot the fitted line over the specified range.
hold on; % Don't blow away prior plot
plot(xFitting, yFitted, 'ro-', 'LineWidth', 2);
legend('Original Data', 'Line Fit');