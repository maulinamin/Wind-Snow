%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% In this step I plot the PPPs for the Interarrival data above 70 KMPH
%
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
folder='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Trenton';
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
%Calculate the time interval between the data
A = timetable2table(A);
for k = 2:numel(A.Date_Time)
A.Time_Interval(k) = daysact(A.Date_Time(k-1), A.Date_Time(k));
end
toDelete = A.Time_Interval < 8;
A(toDelete,:) = [];
%Shift the Inter-arrival data
for k = 1:numel(A.Time_Interval)
    A.Time_Interval(k) = A.Time_Interval(k) - 7;
end
A = table2timetable(A);
WindData = A;
PPTH60 = WindData(:,5);
PPTH60 = sortrows(PPTH60,1,'ascend');
PPTH60.Properties.VariableNames{'Time_Interval'} = 'TI';

%calculations for PPP
z = numel(PPTH60);
for k = 1:z
    PPTH60.Ln_TI(k) = log(PPTH60.TI(k));
end
toDelete = PPTH60.Ln_TI == 0;
PPTH60(toDelete,:) = [];
z = numel(PPTH60.Ln_TI);
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

%PLOT THE LOGNORMAL PPP
p = polyfit(PPTH60.InvPi,PPTH60.Ln_TI,1); 
f = polyval(p,PPTH60.InvPi);
figure;
subplot(2,2,1)
plot(PPTH60.InvPi,PPTH60.Ln_TI,'.',PPTH60.InvPi,f,'-') 
grid on;
legend('data','linear fit')
dim = [0.2 0.5 0.3 0.3];
mdl = fitlm(PPTH60.InvPi,PPTH60.Ln_TI);
ylabel('Ln(Xi)'); xlabel('Standard Normal Percentile');
X = sprintf('LogNormal');
legend('data','linear fit','Location','southeast')
title(X);
%set(gca,'Ylim',[30 160]) % Adjust Y limits of "current axes"
set(gca,'FontName','Times');

%PLOT THE Exponential PPP
p = polyfitB(PPTH60.ExpPi,PPTH60.TI,1,0); 
f = polyval(p,PPTH60.ExpPi); 
subplot(2,2,2)
plot(PPTH60.ExpPi,PPTH60.TI,'.',PPTH60.ExpPi,f,'-')
grid on;
legend('data','linear fit')
dim = [0.2 0.5 0.3 0.3];
mdl = fitlm(PPTH60.ExpPi,PPTH60.TI);
ylabel('Data(Xi)'); xlabel('-Ln(1-Pi)');
X = sprintf('Exponential');
legend('data','linear fit','Location','southeast')
title(X);
%set(gca,'Ylim',[30 160]) % Adjust Y limits of "current axes"
set(gca,'FontName','Times');

%====================
%PLOT THE WEIBULL PPP
p = polyfit(PPTH60.WeibPi,PPTH60.Ln_TI,1); 
f = polyval(p,PPTH60.WeibPi); 
subplot(2,2,3)
plot(PPTH60.WeibPi,PPTH60.Ln_TI,'.',PPTH60.WeibPi,f,'-') 
grid on;
legend('data','linear fit')
dim = [0.2 0.5 0.3 0.3];
mdl = fitlm(PPTH60.WeibPi,PPTH60.Ln_TI);
ylabel('Ln(Xi)'); xlabel('Ln(-Ln(1-Pi))');
X = sprintf('Weibull');
legend('data','linear fit','Location','southeast')
title(X);
%set(gca,'Ylim',[30 160]) % Adjust Y limits of "current axes"
set(gca,'FontName','Times');

%PLOT THE Gumbel PPP
p = polyfit(PPTH60.GumbPi,PPTH60.TI,1); 
f = polyval(p,PPTH60.GumbPi);
subplot(2,2,4)
plot(PPTH60.GumbPi,PPTH60.TI,'.',PPTH60.GumbPi,f,'-')
grid on;
legend('data','linear fit')
dim = [0.2 0.5 0.3 0.3];
mdl = fitlm(PPTH60.GumbPi,PPTH60.TI);
ylabel('Data(Xi)'); xlabel('(-Ln(-Ln(Pi)))');
X = sprintf('Gumbel');
legend('data','linear fit','Location','southeast')
title(X);
%set(gca,'Ylim',[30 160]) % Adjust Y limits of "current axes"
set(gca,'FontName','Times');
set(gcf,'Units','inches') % Set figure size units of "current figure"
set(gcf,'Color','white');
set(gcf,'Position',[0,0,7.5,5.5]) % Set figure width (6 in.) and height (4 in.)
print -deps2c 306-307-308-309.eps % Save as PDF
movefile('306-307-308-309.eps','C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Thesis\Latex\plots');

%
%
%
%PLOT THE Exponential PPP
p = polyfitB(PPTH60.ExpPi,PPTH60.TI,1,0); 
f = polyval(p,PPTH60.ExpPi); 
figure;
%subplot(2,2,1)
plot(PPTH60.ExpPi,PPTH60.TI,'.',PPTH60.ExpPi,f,'-')
grid on;
legend('data','linear fit')
dim = [0.2 0.5 0.3 0.3];
mdl = fitlm(PPTH60.ExpPi,PPTH60.TI);
ylabel('Data(Xi)'); xlabel('-Ln(1-Pi)');
X = sprintf('Exponential PPP: %f X + %f and R-squared = %f',p(1),p(2),mdl.Rsquared.Ordinary);
legend('data','linear fit','Location','southeast')
title(X);
%set(gca,'Ylim',[30 160]) % Adjust Y limits of "current axes"
set(gca,'FontName','Times');
set(gcf,'Units','inches') % Set figure size units of "current figure"
set(gcf,'Color','white');
set(gcf,'Position',[0,0,6,4]) % Set figure width (6 in.) and height (4 in.)
print -deps2c 306.eps % Save as PDF
movefile('306.eps','C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Thesis\Latex\plots');


%PLOT THE LOGNORMAL PPP
p = polyfit(PPTH60.InvPi,PPTH60.Ln_TI,1); 
f = polyval(p,PPTH60.InvPi);
figure;
%subplot(2,2,2)
plot(PPTH60.InvPi,PPTH60.Ln_TI,'.',PPTH60.InvPi,f,'-') 
grid on;
legend('data','linear fit')
dim = [0.2 0.5 0.3 0.3];
mdl = fitlm(PPTH60.InvPi,PPTH60.Ln_TI);
ylabel('Ln(Xi)'); xlabel('Standard Normal Percentile');
X = sprintf('LogNormal PPP: %f X + %f and R-squared = %f',p(1),p(2),mdl.Rsquared.Ordinary);
legend('data','linear fit','Location','southeast')
title(X);
%set(gca,'Ylim',[30 160]) % Adjust Y limits of "current axes"
set(gca,'FontName','Times');
set(gcf,'Units','inches') % Set figure size units of "current figure"
set(gcf,'Color','white');
set(gcf,'Position',[0,0,6,4]) % Set figure width (6 in.) and height (4 in.)
print -deps2c 307.eps % Save as PDF
movefile('307.eps','C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Thesis\Latex\plots');


%====================
%PLOT THE WEIBULL PPP
p = polyfit(PPTH60.WeibPi,PPTH60.Ln_TI,1); 
f = polyval(p,PPTH60.WeibPi); 
figure;
%subplot(2,2,3)
plot(PPTH60.WeibPi,PPTH60.Ln_TI,'.',PPTH60.WeibPi,f,'-') 
grid on;
legend('data','linear fit')
dim = [0.2 0.5 0.3 0.3];
mdl = fitlm(PPTH60.WeibPi,PPTH60.Ln_TI);
ylabel('Ln(Xi)'); xlabel('Ln(-Ln(1-Pi))');
X = sprintf('Weibull PPP: %f X + %f and R-squared = %f',p(1),p(2),mdl.Rsquared.Ordinary);
legend('data','linear fit','Location','southeast')
title(X);
%set(gca,'Ylim',[30 160]) % Adjust Y limits of "current axes"
set(gca,'FontName','Times');
set(gcf,'Units','inches') % Set figure size units of "current figure"
set(gcf,'Color','white');
set(gcf,'Position',[0,0,6,4]) % Set figure width (6 in.) and height (4 in.)
print -deps2c 308.eps % Save as PDF
movefile('308.eps','C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Thesis\Latex\plots');

%PLOT THE Gumbel PPP
p = polyfit(PPTH60.GumbPi,PPTH60.TI,1); 
f = polyval(p,PPTH60.GumbPi);
figure;
%subplot(2,2,4)
plot(PPTH60.GumbPi,PPTH60.TI,'.',PPTH60.GumbPi,f,'-')
grid on;
legend('data','linear fit')
dim = [0.2 0.5 0.3 0.3];
mdl = fitlm(PPTH60.GumbPi,PPTH60.TI);
ylabel('Data(Xi)'); xlabel('(-Ln(-Ln(Pi)))');
X = sprintf('Gumbel PPP: %f X + %f and R-squared = %f',p(1),p(2),mdl.Rsquared.Ordinary);
legend('data','linear fit','Location','southeast')
title(X);
%set(gca,'Ylim',[30 160]) % Adjust Y limits of "current axes"
set(gca,'FontName','Times');
set(gcf,'Units','inches') % Set figure size units of "current figure"
set(gcf,'Color','white');
set(gcf,'Position',[0,0,6,4]) % Set figure width (6 in.) and height (4 in.)
print -deps2c 309.eps % Save as PDF
movefile('309.eps','C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Thesis\Latex\plots');


File = 'C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&Snow\Step6.xlsx';
% ===================================
% CLEAR THE EXCEL FILE BEFORE RUNNING THE PROGRAM
% ===================================
for SheetNum=1:1
     [N, T, Raw]=xlsread(File, SheetNum);
     [Raw{:, :}]=deal(NaN);
     xlswrite(File, Raw, SheetNum);
end
% ===================================
% WRITE THE DATA ON EXCEL FILE 
% ===================================
PPTH60 = timetable2table(PPTH60);
writetable(PPTH60,File,'Sheet','PPPs 60IAT');