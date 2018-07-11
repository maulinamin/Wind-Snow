function [pd1,pd2,pd3] = createFit(Wind_Data)
%CREATEFIT    Create plot of datasets and fits
%   [PD1,PD2,PD3] = CREATEFIT(WIND_DATA)
%   Creates a plot, similar to the plot in the main distribution fitter
%   window, using the data that you provide as input.  You can
%   apply this function to the same data you used with dfittool
%   or with different data.  You may want to edit the function to
%   customize the code and this help message.
%
%   Number of datasets:  1
%   Number of fits:  3
%
%   See also FITDIST.

% This function was automatically generated on 20-Jun-2018 23:57:31

% Output fitted probablility distributions: PD1,PD2,PD3

% Data from dataset "Wind_Data data":
%    Y = Wind_Data

% Force all inputs to be column vectors
Wind_Data = Wind_Data(:);

% Prepare figure
clf;
hold on;
LegHandles = []; LegText = {};


% --- Plot data originally in dataset "Wind_Data data"
[CdfF,CdfX] = ecdf(Wind_Data,'Function','cdf');  % compute empirical cdf
BinInfo.rule = 1;
[~,BinEdge] = internal.stats.histbins(Wind_Data,[],[],BinInfo,CdfF,CdfX);
[BinHeight,BinCenter] = ecdfhist(CdfF,CdfX,'edges',BinEdge);
hLine = bar(BinCenter,BinHeight,'hist');
set(hLine,'FaceColor','none','EdgeColor',[0.333333 0.666667 0],...
    'LineStyle','-', 'LineWidth',1);
xlabel('Data');
ylabel('Density')
LegHandles(end+1) = hLine;
LegText{end+1} = 'Wind Speed';

% Create grid where function will be computed
XLim = get(gca,'XLim');
XLim = XLim + [-1 1] * 0.01 * diff(XLim);
XGrid = linspace(XLim(1),XLim(2),100);


% --- Create fit "Log Normal"

% Fit this distribution to get parameter values
% To use parameter estimates from the original fit:
%     pd1 = ProbDistUnivParam('lognormal',[ 2.873464532133, 0.7408929063036])
pd1 = fitdist(Wind_Data, 'lognormal');
YPlot = pdf(pd1,XGrid);
hLine = plot(XGrid,YPlot,'Color',[1 0 0],...
    'LineStyle','-', 'LineWidth',2,...
    'Marker','none', 'MarkerSize',6);
LegHandles(end+1) = hLine;
LegText{end+1} = 'Log Normal';

% --- Create fit "Exponential"

% Fit this distribution to get parameter values
% To use parameter estimates from the original fit:
%     pd2 = ProbDistUnivParam('exponential',[ 24.58483754513])
pd2 = fitdist(Wind_Data, 'exponential');
YPlot = pdf(pd2,XGrid);
hLine = plot(XGrid,YPlot,'Color',[0 0 1],...
    'LineStyle','-', 'LineWidth',2,...
    'Marker','none', 'MarkerSize',6);
LegHandles(end+1) = hLine;
LegText{end+1} = 'Exponential';

% --- Create fit "Weibull"

% Fit this distribution to get parameter values
% To use parameter estimates from the original fit:
%     pd3 = ProbDistUnivParam('weibull',[ 26.31087572751, 1.179014560148])
pd3 = fitdist(Wind_Data, 'weibull');
YPlot = pdf(pd3,XGrid);
hLine = plot(XGrid,YPlot,'Color',[0.666667 0.333333 0],...
    'LineStyle','-', 'LineWidth',2,...
    'Marker','none', 'MarkerSize',6);
LegHandles(end+1) = hLine;
LegText{end+1} = 'Weibull';

% Adjust figure
box on;
hold off;

% Create legend from accumulated handles and labels
hLegend = legend(LegHandles,LegText,'Orientation', 'vertical', 'FontSize', 9, 'Location', 'northeast');
set(hLegend,'Interpreter','none');
set(gca,'FontName','Times');
set(gcf,'Units','inches') % Set figure size units of "current figure"
set(gcf,'Color','white');
set(gcf,'Position',[0,0,6,3.5]) % Set figure width (6 in.) and height (4 in.)
