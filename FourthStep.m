%this program is the function of Extracting the data above the threshold
%Use this to verify the program
clear; % Clear Memory
clc; %Clear Command Window
%Define the folder location of CSV files
folder='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Trenton';
i=1; %Set i=1 so that it does not give error for data{0} which is impossible
%use the Datastore function to read all the CSV files in the folder
ds = tabularTextDatastore(folder,'FileExtensions','.csv','SelectedVariableNames',{'Date_Time','SpdOfMaxGust_km_h_'});
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%Copy it to the output variable
WindData{1} = A;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Delete all the data below 70kmph
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
%Copy it to the output variable
WindData{2} = A;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PPTH60 = WindData{1}(:,2);
% PPTH60 = sortrows(PPTH60,1,'ascend');
% PPTH60.Properties.VariableNames{'SpdOfMaxGust_km_h_'} = 'Kmph';
% z = numel(PPTH60);
% for k = 1:z
%     PPTH60.Ln_Kmph(k) = log(PPTH60.Kmph(k));
% end
% for k = 1:z
%     PPTH60.Rank(k) = k;
% end
% for k = 1:z
%     PPTH60.Pi(k) = k/(z+1);
% end
% for k = 1:z
%     PPTH60.InvPi(k) = norminv(PPTH60.Pi(k));
% end
% for k = 1:z
%     PPTH60.WeibPi(k) = log(-log(1-PPTH60.Pi(k)));
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PPTH70 = WindData{2}(:,2);
PPTH70 = sortrows(PPTH70,1,'ascend');
PPTH70.Properties.VariableNames{'SpdOfMaxGust_km_h_'} = 'Kmph';
z = numel(PPTH70);
for k = 1:z
    PPTH70.Ln_Kmph(k) = log(PPTH70.Kmph(k));
end
a = 60;
for k = 1:z
    PPTH70.Rank(k) = a;
    a = a+1;
end
for k = 1:z
    PPTH70.Pi(k) = k/(z+1);
end
for k = 1:z
    PPTH70.InvPi(k) = norminv(PPTH70.Pi(k));
end
for k = 1:z
    PPTH70.WeibPi(k) = log(-log(1-PPTH70.Pi(k)));
end
p = polyfit(PPTH70.InvPi,PPTH70.Kmph,1); 
f = polyval(p,PPTH70.InvPi); 
plot(PPTH70.InvPi,PPTH70.Kmph,'.',PPTH70.InvPi,f,'-') 
legend('data','linear fit')
dim = [0.2 0.5 0.3 0.3];
mdl = fitlm(PPTH70.InvPi,PPTH70.Kmph);
X = sprintf('%f X + %f and R-squared = %f',p(1),p(2),mdl.Rsquared.Ordinary);
annotation('textbox',dim,'String',X,'FitBoxToText','on');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PPTI70 = WindData{2}(:,3);
% PPTI70 = sortrows(PPTI70,1,'ascend');
% z = numel(PPTI70);
% for k = 1:z
%     PPTI70.Ln_TI(k) = log(PPTI70.Time_Interval(k));
% end
% for k = 1:z
%     PPTI70.Rank(k) = k;
% end
% for k = 1:z
%     PPTI70.Pi(k) = k/(z+1);
% end
% for k = 1:z
%     PPTI70.InvPi(k) = norminv(PPTI70.Pi(k));
% end
% for k = 1:z
%     PPTI70.WeibPi(k) = log(-log(1-PPTI70.Pi(k)));
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PPTI60 = WindData{1}(:,3);
% PPTI60 = sortrows(PPTI60,1,'ascend');
% z = numel(PPTI60);
% for k = 1:z
%     PPTI60.Ln_TI(k) = log(PPTI60.Time_Interval(k));
% end
% for k = 1:z
%     PPTI60.Rank(k) = k;
% end
% for k = 1:z
%     PPTI60.Pi(k) = k/(z+1);
% end
% for k = 1:z
%     PPTI60.InvPi(k) = norminv(PPTI60.Pi(k));
% end
% for k = 1:z
%     PPTI60.WeibPi(k) = log(-log(1-PPTI60.Pi(k)));
% end
% 
% File = 'C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&Snow\Step4.xlsx';
% writetable(PPTH60,File,'Sheet','PPP < 60kmph');
% writetable(PPTH70,File,'Sheet','PPP < 70kmph');
% writetable(PPTI60,File,'Sheet','PPP 60 interarrival');
% writetable(PPTI70,File,'Sheet','PPP 70 interarrival');