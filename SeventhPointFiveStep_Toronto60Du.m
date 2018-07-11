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
folder='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Toronto_Airport';
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
toDelete = A.SpdOfMaxGust_km_h_ < 60;
A(toDelete,:) = [];


%Calculate the time interval between the data
A = timetable2table(A);
for k = 2:numel(A.Date_Time)
A.Time_Interval(k) = daysact(A.Date_Time(k-1), A.Date_Time(k));
end
toDelete = A.Time_Interval < 7;
A(toDelete,:) = [];

%Calculate the Cum_N(t)
for k = 1:numel(A.Date_Time)
    A.Cum_Nt(k) = k;
end

%Calculate the cumulative time interval
first = 0;
for k = 1:numel(A.Date_Time)
    second = A.Time_Interval(k);
    A.CumTI(k) = first+second;
    first = A.CumTI(k);
end
%Calculate the log of Cum_N(t)
for k = 1:numel(A.Date_Time)
    A.Ln_Cum_Nt(k) = log(A.Cum_Nt(k));
end
%Calculate the log of cumulative time interval
for k = 1:numel(A.Date_Time)
    A.Ln_CumTI(k) = log(A.CumTI(k));
end
for k=1:numel(A.Date_Time)
    A.Ln_Ntiti(k) = (log(A.Cum_Nt(k)/A.CumTI(k)));
end
for k=1:numel(A.Date_Time)
    A.LnTI(k) = (log(A.CumTI(k)));
end
figure;
plot(A.LnTI,A.Ln_Ntiti,'.');
grid on;
hold on;


%===================================
% Modifying the data further for analysis 
%===================================
%Delete all the data below 70kmph
B = wind_data;
B = table2timetable(B);
toDelete = B.SpdOfMaxGust_km_h_ < 70;
B(toDelete,:) = [];


%Calculate the time interval between the data
B = timetable2table(B);
for k = 2:numel(B.Date_Time)
B.Time_Interval(k) = daysact(B.Date_Time(k-1), B.Date_Time(k));
end
toDelete = B.Time_Interval < 7;
B(toDelete,:) = [];

%Calculate the Cum_N(t)
for k = 1:numel(B.Date_Time)
    B.Cum_Nt(k) = k;
end

%Calculate the cumulative time interval
first = 0;
for k = 1:numel(B.Date_Time)
    second = B.Time_Interval(k);
    B.CumTI(k) = first+second;
    first = B.CumTI(k);
end
%Calculate the log of Cum_N(t)
for k = 1:numel(B.Date_Time)
    B.Ln_Cum_Nt(k) = log(B.Cum_Nt(k));
end
%Calculate the log of cumulative time interval
for k = 1:numel(B.Date_Time)
    B.Ln_CumTI(k) = log(B.CumTI(k));
end
for k=1:numel(B.Date_Time)
    B.Ln_Ntiti(k) = (log(B.Cum_Nt(k)/B.CumTI(k)));
end
for k=1:numel(B.Date_Time)
    B.LnTI(k) = (log(B.CumTI(k)));
end

plot(B.LnTI,B.Ln_Ntiti,'.');
hold off;
legend('60KMPH','70KMPH','Location','northeast')
ylabel({'$ln( N(t_{i})/t_{i})$'},'Interpreter','latex'); xlabel({'$ln( t_{i} )$'},'Interpreter','latex');
set(gca,'FontName','Times');
set(gcf,'Units','inches') % Set figure size units of "current figure"
set(gcf,'Color','white');
set(gcf,'Position',[0,0,5.5,3.5]) % Set figure width (6 in.) and height (4 in.)
print -deps2c 408.eps % Save as PDF
movefile('408.eps','C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Thesis\Latex\plots');

% n = numel(A.CumTI);
% sum_CumTI = A.CumTI;
% sum_CumTI([n],:) = [];
% Ti = sum(sum_CumTI);
% tn = A.CumTI;
% tn([1:n-1],:) = [];
% L = ( (Ti/(n)) - (tn/2) )/( tn/( sqrt( 12*(n) ) ) )
% %A = table2timetable(A);

