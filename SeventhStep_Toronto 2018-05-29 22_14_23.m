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

A = table2timetable(A);

%PLOT THE NHPP
p = polyfit(A.Ln_CumTI,A.Ln_Cum_Nt,1); 
f = polyval(p,A.Ln_CumTI); 
subplot(2,1,1)
plot(A.Ln_CumTI,A.Ln_Cum_Nt,'.',A.Ln_CumTI,f,'-')
grid on;
legend('data','linear fit','Location','southeast')

dim = [0.2 0.5 0.3 0.3];
mdl = fitlm(A.Ln_CumTI,A.Ln_Cum_Nt);
ylabel('Ln(Cum N(t))'); xlabel('Ln(Time)');
X = sprintf('NHPP for wind speed >60kmph: %f X + %f and R-squared = %f',p(1),p(2),mdl.Rsquared.Ordinary);
title(X);
%set(gca,'Ylim',[30 160]) % Adjust Y limits of "current axes"
set(gca,'FontName','Times');
set(gcf,'Units','inches') % Set figure size units of "current figure"
set(gcf,'Color','white');


File = 'C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&Snow\Step7_Toronto.xlsx';
%===================================
%CLEAR THE EXCEL FILE BEFORE RUNNING THE PROGRAM
%===================================
for SheetNum=1
     [N, T, Raw]=xlsread(File, SheetNum);
     [Raw{:, :}]=deal(NaN);
     xlswrite(File, Raw, SheetNum);
end
%===================================
%WRITE THE DATA ON EXCEL FILE 
%===================================
A = timetable2table(A);
writetable(A,File,'Sheet','NHPP for "> 60KMPH"');

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
toDelete = A.SpdOfMaxGust_km_h_ < 70;
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

A = table2timetable(A);

%PLOT THE NHPP
p = polyfit(A.Ln_CumTI,A.Ln_Cum_Nt,1); 
f = polyval(p,A.Ln_CumTI); 
subplot(2,1,2)
plot(A.Ln_CumTI,A.Ln_Cum_Nt,'.',A.Ln_CumTI,f,'-')
grid on;
legend('data','linear fit','Location','southeast')

dim = [0.2 0.5 0.3 0.3];
mdl = fitlm(A.Ln_CumTI,A.Ln_Cum_Nt);
ylabel('Ln(Cum N(t))'); xlabel('Ln(Time)');
X = sprintf('NHPP for wind speed >70kmph: %f X + %f and R-squared = %f',p(1),p(2),mdl.Rsquared.Ordinary);
title(X);
%set(gca,'Ylim',[30 160]) % Adjust Y limits of "current axes"
set(gca,'FontName','Times');
set(gcf,'Units','inches') % Set figure size units of "current figure"
set(gcf,'Color','white');
set(gcf,'Position',[0,0,7.5,5.5]) % Set figure width (6 in.) and height (4 in.)
print -deps2c NHPP_Toronto.eps % Save as PDF
movefile('NHPP_Toronto.eps','C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Thesis\Latex\plots');

File = 'C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&Snow\Step7_Toronto.xlsx';
%===================================
%CLEAR THE EXCEL FILE BEFORE RUNNING THE PROGRAM
%===================================
for SheetNum=2
     [N, T, Raw]=xlsread(File, SheetNum);
     [Raw{:, :}]=deal(NaN);
     xlswrite(File, Raw, SheetNum);
end
%===================================
%WRITE THE DATA ON EXCEL FILE 
%===================================
A = timetable2table(A);
writetable(A,File,'Sheet','NHPP for "> 70KMPH"');