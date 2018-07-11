%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% In this step I plot the PPPs for the data above 60 KMPH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%==================================
% Basic Initialization instructions
%==================================
clear; % Clear Memory
clc; %Clear Command Window
%===================================
% Basic Data Extraction instructions
%===================================
%Define the folder location of CSV files
folder='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Toronto_Island';
i=1; %Set i=1 so that it does not give error for data{0} which is impossible
%use the Datastore function to read all the CSV files in the folder
ds = tabularTextDatastore(folder,'FileExtensions','.csv','SelectedVariableNames',{'Date_Time','Year','Month','Day','SpdOfMaxGust_km_h_'});
%a while loop divides the Datastore variable data into years
wind_data = readall(ds);
%===================================
% Getting the extracted data ready for analysis
%===================================
%Make a second set of data. Here we just replace <31 with 30.5 in the data
t = cell2table(wind_data.SpdOfMaxGust_km_h_); %extract just the data column for modifications
y = table2array(t); %prepare to make modifications
y = strrep(y,'<31','30.5'); %make modifications
wind_data.SpdOfMaxGust_km_h_ = y;
%remove the rows with missing entries
wind_data = rmmissing(wind_data);
%Covert to DatTime
temp_Date_Time = datetime(wind_data.Date_Time,'InputFormat','yyyy-MM-dd'); %Array that converts 'string date' to datetime format
wind_data.Date_Time = temp_Date_Time;
%Convert Wind data from String to Number
Wind_Gust = cell2table(wind_data.SpdOfMaxGust_km_h_);
Wind_Gust = table2array(Wind_Gust);
Wind_Gust = str2double(Wind_Gust);
wind_data.SpdOfMaxGust_km_h_ = (Wind_Gust);
%Convert Year data from String to Number
Wind_Year = cell2table(wind_data.Year);
Wind_Year = table2array(Wind_Year);
Wind_Year = str2double(Wind_Year);
wind_data.Year = (Wind_Year);
%Convert Month data from String to Number
Wind_Month = cell2table(wind_data.Month);
Wind_Month = table2array(Wind_Month);
Wind_Month = str2double(Wind_Month);
wind_data.Month = (Wind_Month);
%Convert Day data from String to Number
Wind_Day = cell2table(wind_data.Day);
Wind_Day = table2array(Wind_Day);
Wind_Day = str2double(Wind_Day);
wind_data.Day = (Wind_Day);
%===================================
% Modifying the data further for analysis
%===================================
%Delete all the data below 60kmph
A = wind_data;
A = table2timetable(A);
toDelete = A.SpdOfMaxGust_km_h_ < 61;
A(toDelete,:) = [];
%Shift the kmph data
for k = 1:numel(A.SpdOfMaxGust_km_h_)
    A.SpdOfMaxGust_km_h_(k) = A.SpdOfMaxGust_km_h_(k) - 60;
end
WindData = A;
PPTH60 = WindData(:,4);
PPTH60 = sortrows(PPTH60,1,'ascend');
PPTH60.Properties.VariableNames{'SpdOfMaxGust_km_h_'} = 'Kmph';

%calculations for PPP
z = numel(PPTH60);
for k = 1:z
    PPTH60.Ln_Kmph(k) = log(PPTH60.Kmph(k));
end
toDelete = PPTH60.Ln_Kmph == 0;
PPTH60(toDelete,:) = [];
z = numel(PPTH60.Ln_Kmph);
for k = 1:z
    PPTH60.Rank(k) = k;
end
for k = 1:z
    PPTH60.Pi(k) = k/(z+1);
end
for k = 1:z
    PPTH60.InvPi(k) = norminv(PPTH60.Pi(k));
end
for k = 1:z
    PPTH60.ExpPi(k) = -log(1-PPTH60.Pi(k));
end
for k = 1:z
    PPTH60.WeibPi(k) = log(-log(1-PPTH60.Pi(k)));
end
for k = 1:z
    PPTH60.GumbPi(k) = -log(-log(PPTH60.Pi(k)));
end

%==============================================================================
%==============================================================================
%==============================================================================
% %PLOT THE LOGNORMAL PPP
% p = polyfit(PPTH60.InvPi,PPTH60.Ln_Kmph,1); 
% f = polyval(p,PPTH60.InvPi); 
% figure;
% subplot(2,2,1)
% plot(PPTH60.InvPi,PPTH60.Ln_Kmph,'.',PPTH60.InvPi,f,'-') 
% grid on;
% legend('data','linear fit')
% dim = [0.2 0.5 0.3 0.3];
% mdl = fitlm(PPTH60.InvPi,PPTH60.Ln_Kmph);
% ylabel('Ln(Xi)'); xlabel('Standard Normal Percentile');
% X = sprintf('LogNormal');
% legend('data','linear fit','Location','southeast')
% title(X);
% set(gca,'FontName','Times');
% set(gcf,'Units','inches') % Set figure size units of "current figure"
% 
% %PLOT THE Exponential PPP
% p = polyfitB(PPTH60.ExpPi,PPTH60.Kmph,1,0); 
% f = polyval(p,PPTH60.ExpPi); 
% subplot(2,2,2)
% plot(PPTH60.ExpPi,PPTH60.Kmph,'.',PPTH60.ExpPi,f,'-')
% title('PPP Gumbel for >60 kmph');
% grid on;
% legend('data','linear fit')
% dim = [0.2 0.5 0.3 0.3];
% mdl = fitlm(PPTH60.ExpPi,PPTH60.Kmph);
% ylabel('Data(Xi)'); xlabel('-Ln(1-Pi)');
% X = sprintf('Exponential');
% legend('data','linear fit','Location','southeast')
% title(X);
% set(gca,'FontName','Times');
% set(gcf,'Units','inches') % Set figure size units of "current figure"
% 
% %====================
% %PLOT THE WEIBULL PPP
% p = polyfit(PPTH60.WeibPi,PPTH60.Ln_Kmph,1); 
% f = polyval(p,PPTH60.WeibPi);
% subplot(2,2,3)
% plot(PPTH60.WeibPi,PPTH60.Ln_Kmph,'.',PPTH60.WeibPi,f,'-') 
% grid on;
% legend('data','linear fit')
% dim = [0.2 0.5 0.3 0.3];
% mdl = fitlm(PPTH60.WeibPi,PPTH60.Ln_Kmph);
% ylabel('Ln(Xi)'); xlabel('Ln(-Ln(1-Pi))');
% X = sprintf('Weibull');
% legend('data','linear fit','Location','southeast')
% title(X);
% set(gca,'FontName','Times');
% set(gcf,'Units','inches') % Set figure size units of "current figure"
% 
% %PLOT THE Gumbel PPP
% p = polyfit(PPTH60.GumbPi,PPTH60.Kmph,1); 
% f = polyval(p,PPTH60.GumbPi); 
% subplot(2,2,4)
% plot(PPTH60.GumbPi,PPTH60.Kmph,'.',PPTH60.GumbPi,f,'-')
% grid on;
% legend('data','linear fit')
% dim = [0.2 0.5 0.3 0.3];
% mdl = fitlm(PPTH60.GumbPi,PPTH60.Kmph);
% ylabel('Data(Xi)'); xlabel('(-Ln(-Ln(Pi)))');
% X = sprintf('Gumbel');
% legend('data','linear fit','Location','southeast')
% title(X);
% %set(gca,'Ylim',[30 160]) % Adjust Y limits of "current axes"
% set(gca,'FontName','Times');
% set(gcf,'Units','inches') % Set figure size units of "current figure"
% set(gcf,'Color','white');
% set(gcf,'Position',[0,0,7.5,5.5]) % Set figure width (6 in.) and height (4 in.)
% 
% print -deps2c 318-319-320-321.eps % Save as PDF
% movefile('318-319-320-321.eps','C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Thesis\Latex\plots');

%===
%===Individual DISTRIBUTION figures
%===
%PLOT THE Exponential PPP
p = polyfitB(PPTH60.ExpPi,PPTH60.Kmph,1,0); 
f = polyval(p,PPTH60.ExpPi); 
figure;
% subplot(2,2,1)
plot(PPTH60.ExpPi,PPTH60.Kmph,'.',PPTH60.ExpPi,f,'-')
title('PPP Gumbel for >60 kmph');
grid on;
legend('data','linear fit')
dim = [0.2 0.5 0.3 0.3];
mdl = fitlm(PPTH60.ExpPi,PPTH60.Kmph);
ylabel('Data(Xi)'); xlabel('-Ln(1-Pi)');
X = sprintf('%f X + %f & R^2 = %f',p(1),p(2),mdl.Rsquared.Ordinary);
legend('data','linear fit','Location','southeast')
title(X);
%set(gca,'Ylim',[30 160]) % Adjust Y limits of "current axes"
set(gca,'FontName','Times');
set(gcf,'Units','inches') % Set figure size units of "current figure"
set(gcf,'Color','white');
set(gcf,'Position',[0,0,3.2,2.5]) % Set figure width (6 in.) and height (4 in.)
print -deps2c 366.eps % Save as PDF
movefile('366.eps','C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Thesis\Latex\plots');

%PLOT THE LOGNORMAL PPP
p = polyfit(PPTH60.InvPi,PPTH60.Ln_Kmph,1); 
f = polyval(p,PPTH60.InvPi); 
figure;
% subplot(2,2,2)
plot(PPTH60.InvPi,PPTH60.Ln_Kmph,'.',PPTH60.InvPi,f,'-') 
title('PPP LogNormal for >60 kmph');
grid on;
legend('data','linear fit')
dim = [0.2 0.5 0.3 0.3];
mdl = fitlm(PPTH60.InvPi,PPTH60.Ln_Kmph);
ylabel('Ln(Xi)'); xlabel('Standard Normal Percentile');
X = sprintf('LogNormal PPP: %f X + %f and R-squared = %f',p(1),p(2),mdl.Rsquared.Ordinary);
legend('data','linear fit','Location','southeast')
title(X);
%(gca,'Ylim',[30 160]) % Adjust Y limits of "current axes"
set(gca,'FontName','Times');
set(gcf,'Units','inches') % Set figure size units of "current figure"
set(gcf,'Color','white');
set(gcf,'Position',[0,0,5,3]) % Set figure width (6 in.) and height (4 in.)
print -deps2c 367.eps % Save as PDF
movefile('367.eps','C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Thesis\Latex\plots');

%====================
%PLOT THE WEIBULL PPP
p = polyfit(PPTH60.WeibPi,PPTH60.Ln_Kmph,1); 
f = polyval(p,PPTH60.WeibPi);
figure;
% subplot(2,2,3)
plot(PPTH60.WeibPi,PPTH60.Ln_Kmph,'.',PPTH60.WeibPi,f,'-') 
title('PPP Weibull for >60 kmph');
grid on;
legend('data','linear fit')
dim = [0.2 0.5 0.3 0.3];
mdl = fitlm(PPTH60.WeibPi,PPTH60.Ln_Kmph);
ylabel('Ln(Xi)'); xlabel('Ln(-Ln(1-Pi))');
X = sprintf('Weibull PPP: %f X + %f and R-squared = %f',p(1),p(2),mdl.Rsquared.Ordinary);
legend('data','linear fit','Location','southeast')
title(X);
%set(gca,'Ylim',[30 160]) % Adjust Y limits of "current axes"
set(gca,'FontName','Times');
set(gcf,'Units','inches') % Set figure size units of "current figure"
set(gcf,'Color','white');
set(gcf,'Position',[0,0,6,4]) % Set figure width (6 in.) and height (4 in.)
print -deps2c 368.eps % Save as PDF
movefile('368.eps','C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Thesis\Latex\plots');

%PLOT THE Gumbel PPP
p = polyfit(PPTH60.GumbPi,PPTH60.Kmph,1); 
f = polyval(p,PPTH60.GumbPi); 
figure;
% subplot(2,2,4)
plot(PPTH60.GumbPi,PPTH60.Kmph,'.',PPTH60.GumbPi,f,'-')
title('PPP Gumbel for >60 kmph');
grid on;
legend('data','linear fit')
dim = [0.2 0.5 0.3 0.3];
mdl = fitlm(PPTH60.GumbPi,PPTH60.Kmph);
ylabel('Data(Xi)'); xlabel('(-Ln(-Ln(Pi)))');
X = sprintf('Gumbel PPP: %f X + %f and R-squared = %f',p(1),p(2),mdl.Rsquared.Ordinary);
legend('data','linear fit','Location','southeast')
title(X);
%set(gca,'Ylim',[30 160]) % Adjust Y limits of "current axes"
set(gca,'FontName','Times');
set(gcf,'Units','inches') % Set figure size units of "current figure"
set(gcf,'Color','white');
set(gcf,'Position',[0,0,6,4]) % Set figure width (6 in.) and height (4 in.)
print -deps2c 369.eps % Save as PDF
movefile('369.eps','C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Thesis\Latex\plots');

% File = 'C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&Snow\Step6.xlsx';
% % ===================================
% % CLEAR THE EXCEL FILE BEFORE RUNNING THE PROGRAM
% % ===================================
% for SheetNum=1:4
%      [N, T, Raw]=xlsread(File, SheetNum);
%      [Raw{:, :}]=deal(NaN);
%      xlswrite(File, Raw, SheetNum);
% end
% % ===================================
% % WRITE THE DATA ON EXCEL FILE 
% % ===================================
% PPTH60 = timetable2table(PPTH60);
% writetable(PPTH60,File,'Sheet','PPPs 60KMPH');