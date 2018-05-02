%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% In this step I plot WindSpeed vs Time
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%==================================
% Basic Initialization instructions
%==================================
clear; % Clear Memory
clc; %Clear Command Window

%Define the folder location of CSV files
folder='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Trenton';
i=1; %Set i=1 so that it does not give error for data{0} which is impossible
%use the Datastore function to read all the CSV files in the folder
ds = tabularTextDatastore(folder,'FileExtensions','.csv','SelectedVariableNames',{'Date_Time','Year','Month','Day','TotalPrecip_mm_'});
%a while loop divides the Datastore variable data into years
precipi_data = readall(ds);
% %Make a second set of data. Here we just replace <31 with 30.5 in the data
% t = cell2table(precipi_data.TotalPrecip_mm_); %extract just the data column for modifications
% y = table2array(t); %prepare to make modifications
% y = strrep(y,'<31','30.5'); %make modifications
% precipi_data.SpdOfMaxGust_km_h_ = y;
%remove the rows with missing entries
precipi_data = rmmissing(precipi_data);
%Covert to DatTime
temp_Date_Time = datetime(precipi_data.Date_Time,'InputFormat','yyyy-MM-dd'); %Array that converts 'string date' to datetime format
precipi_data.Date_Time = temp_Date_Time;
%Convert Wind data from String to Number
Precipi = cell2table(precipi_data.TotalPrecip_mm_);
Precipi = table2array(Precipi);
Precipi = str2double(Precipi);
precipi_data.TotalPrecip_mm_ = (Precipi);
%Convert Year data from String to Number
Precipi_Year = cell2table(precipi_data.Year);
Precipi_Year = table2array(Precipi_Year);
Precipi_Year = str2double(Precipi_Year);
precipi_data.Year = (Precipi_Year);
%Convert Month data from String to Number
Precipi_Month = cell2table(precipi_data.Month);
Precipi_Month = table2array(Precipi_Month);
Precipi_Month = str2double(Precipi_Month);
precipi_data.Month = (Precipi_Month);
%Convert Day data from String to Number
Precipi_Day = cell2table(precipi_data.Day);
Precipi_Day = table2array(Precipi_Day);
Precipi_Day = str2double(Precipi_Day);
precipi_data.Day = (Precipi_Day);

% f = figure;
% p = uipanel('Parent',f,'BorderType','none'); 
% p.Title = 'My Super Title'; 
% p.TitlePosition = 'centertop'; 
% p.FontSize = 12;
% p.FontWeight = 'bold';

plot_precipivstime = precipi_data;
for k = 1:numel(plot_precipivstime.Date_Time)
    plot_precipivstime.constant(k) = 20;
end
% toDelete = plot_windvstime.Month ~= 1;
% plot_windvstime(toDelete,:) = [];
subplot(2,1,1)
plot(plot_precipivstime.Date_Time,plot_precipivstime.TotalPrecip_mm_)
hold on
plot(plot_precipivstime.Date_Time,plot_precipivstime.constant,'LineWidth',2.1)
hold off
xlabel('Time (Years)'); ylabel('Precipitation (mm)');
title('Precipitation vs Time');
set(gca,'Ylim',[0 110]) % Adjust Y limits of "current axes"
set(gca,'FontName','Times');
set(gcf,'Units','inches') % Set figure size units of "current figure"
set(gcf,'Color','white');
set(gcf,'Position',[0,0,6,4]) % Set figure width (6 in.) and height (4 in.)

%reduced number of years
rplot_precipivstime = precipi_data;
for k = 1:numel(rplot_precipivstime.Date_Time)
    rplot_precipivstime.constant(k) = 10;
end
toDelete = rplot_precipivstime.Year < 2005;
rplot_precipivstime(toDelete,:) = [];
toDelete = rplot_precipivstime.Year > 2011;
rplot_precipivstime(toDelete,:) = [];
subplot(2,1,2)
plot(rplot_precipivstime.Date_Time,rplot_precipivstime.TotalPrecip_mm_)
hold on
plot(rplot_precipivstime.Date_Time,rplot_precipivstime.constant,'LineWidth',2.1)
hold off
xlabel('Time (Years)'); ylabel('Precipitation (mm)');
title('Precipitation vs Time with reduced number of years');
set(gca,'Ylim',[0 110]) % Adjust Y limits of "current axes"
set(gca,'FontName','Times');
set(gcf,'Units','inches') % Set figure size units of "current figure"
set(gcf,'Color','white');
set(gcf,'Position',[0,0,6,4]) % Set figure width (6 in.) and height (4 in.)
print -deps2c 2.eps % Save as PDF

% File = 'C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&Snow\Step5.xlsx';
% %===================================
% %CLEAR THE EXCEL FILE BEFORE RUNNING THE PROGRAM
% %===================================
% for SheetNum=1:1
%      [N, T, Raw]=xlsread(File, SheetNum);
%      [Raw{:, :}]=deal(NaN);
%      xlswrite(File, Raw, SheetNum);
% end
% %===================================
% %WRITE THE DATA ON EXCEL FILE 
% %===================================
% writetable(plot_windvstime,File,'Sheet','TimevsSpeed');