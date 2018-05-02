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
ds = tabularTextDatastore(folder,'FileExtensions','.csv','SelectedVariableNames',{'Date_Time','Year','Month','Day','SpdOfMaxGust_km_h_'});
%a while loop divides the Datastore variable data into years
wind_data = readall(ds);
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

f = figure;
p = uipanel('Parent',f,'BorderType','none'); 
p.Title = 'My Super Title'; 
p.TitlePosition = 'centertop'; 
p.FontSize = 12;
p.FontWeight = 'bold';

plot_windvstime = wind_data;
for k = 1:numel(plot_windvstime.Date_Time)
    plot_windvstime.constant(k) = 75;
end
% toDelete = plot_windvstime.Month ~= 1;
% plot_windvstime(toDelete,:) = [];
subplot(2,1,1,'Parent',p)
plot(plot_windvstime.Date_Time,plot_windvstime.SpdOfMaxGust_km_h_)
hold on
plot(plot_windvstime.Date_Time,plot_windvstime.constant,'LineWidth',2.1)
hold off
xlabel('Time'); ylabel('Wind Speed KMPH');
title('Plot of Windspeed vs Time. This plot contains all the daily Wind Gust data for Trenton from 1955 to 2018.');

%reduced number of years
rplot_windvstime = wind_data;
for k = 1:numel(rplot_windvstime.Date_Time)
    rplot_windvstime.constant(k) = 60;
end
toDelete = rplot_windvstime.Year < 2005;
rplot_windvstime(toDelete,:) = [];
toDelete = rplot_windvstime.Year > 2011;
rplot_windvstime(toDelete,:) = [];
subplot(2,1,2,'Parent',p)
plot(rplot_windvstime.Date_Time,rplot_windvstime.SpdOfMaxGust_km_h_)
hold on
plot(rplot_windvstime.Date_Time,rplot_windvstime.constant,'LineWidth',2.1)
hold off
xlabel('Time'); ylabel('Wind Speed KMPH');
title('Plot of Windspeed vs Time with reduced number of years');
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