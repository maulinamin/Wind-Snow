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
folder='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Wiarton';
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

n = numel(A.CumTI);
sum_CumTI = A.CumTI;
sum_CumTI([n],:) = [];
Ti = sum(sum_CumTI);
% tn = A.CumTI;
% tn([1:n-1],:) = [];
tn=numel(wind_data.Day)
L = ( (Ti/(n)) - (tn/2) )/( tn/( sqrt( 12*(n) ) ) );
%A = table2timetable(A);

GOF = A;
for k = 1:numel(GOF.Date_Time)
    GOF.i(k) = k;
end
GOF.t = GOF.CumTI;
loop = numel(GOF.Date_Time);
for k = 1:loop
GOF.tnt(k) = log(tn/GOF.t(k));
end
SUMtnt = sum(GOF.tnt);
B_cap = n/SUMtnt;
B_bar = ( ((n-1)/(n)) *B_cap );


%Ratio power transformation
for k = 1:loop
GOF.Ri(k) = ( GOF.t(k)/tn )^B_bar;
end
for k = 1:loop
    GOF.i2i(k) = ( ( 2*GOF.i(k) - 1 ) / ( 2*n ) );
end

for k = 1:loop
GOF.Ri_i2i(k) = (GOF.Ri(k) - GOF.i2i(k))^2;
end
SUMRi_i2i = sum(GOF.Ri_i2i);

Cr = ( 1 / (12*n) ) + SUMRi_i2i
[H,P,CvMSTAT,CV] = cmtest(GOF.CumTI)
Trans = GOF.CumTI.';
normalitytest(Trans)
scatter(GOF.Ri,GOF.i2i,'.')
grid on;
refline
ylabel({'$E(R_{i})$'},'Interpreter','latex'); xlabel({'$\hat{R_{i}}$'},'Interpreter','latex');
set(gca,'FontName','Times');
set(gcf,'Units','inches') % Set figure size units of "current figure"
set(gcf,'Color','white');
set(gcf,'Position',[0,0,3.5,3.5]) % Set figure width (6 in.) and height (4 in.)
print -deps2c 414.eps % Save as PDF
movefile('414.eps','C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Thesis\Latex\plots');
