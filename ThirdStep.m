clear; % Clear Memory
clc; %Clear Command Window
%Location of the file
File = 'C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&Snow\Step3.xlsx';
%===================================
%CLEAR THE EXCEL FILE BEFORE RUNNING THE PROGRAM
%===================================
for SheetNum=1:9
     [N, T, Raw]=xlsread(File, SheetNum);
     [Raw{:, :}]=deal(NaN);
     xlswrite(File, Raw, SheetNum);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %=================================
% %===========================TORONTO AIRPORT
% %=================================
folder1='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Toronto_Airport';
WindData{1} = ExtractAboveThreshold(folder1);
writetable(WindData{1},File,'Sheet','TorontoAirport');

% %=================================
% %===========================TRENTON
% %=================================
folder2='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\TRENTON';
WindData{2} = ExtractAboveThreshold(folder2);
writetable(WindData{2},File,'Sheet','Trenton');

%=================================
%===========================TORONTO ISLAND
%=================================
folder3='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Toronto_Island';
WindData{3} = ExtractAboveThreshold(folder3);
writetable(WindData{3},File,'Sheet','TorontoIsland');

% %=================================
% %===========================LONDON
%=================================
folder4='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\London';
WindData{4} = ExtractAboveThreshold(folder4);
writetable(WindData{4},File,'Sheet','London');

% %=================================
% %===========================Wiarton
% %=================================
folder5='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Wiarton';
WindData{5} = ExtractAboveThreshold(folder5);
writetable(WindData{5},File,'Sheet','Wiarton');

% %=================================
% %===========================KW
% %=================================
folder6='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\KW';
WindData{6} = ExtractAboveThreshold(folder6);
writetable(WindData{6},File,'Sheet','KW');

% %=================================
% %===========================Hamilton
% %=================================
folder7='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Hamilton';
WindData{7} = ExtractAboveThreshold(folder7);
writetable(WindData{7},File,'Sheet','Hamilton');

% %=================================
% %===========================Sarnia
% %=================================
folder8='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Sarnia';
WindData{8} = ExtractAboveThreshold(folder8);
writetable(WindData{8},File,'Sheet','Sarnia');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%ORIGINAL PROGRAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %this program is the function of Extracting the data above the threshold
% %Use this to verify the program
% clear; % Clear Memory
% clc; %Clear Command Window
% %Define the folder location of CSV files
% folder='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Hamilton';
% i=1; %Set i=1 so that it does not give error for data{0} which is impossible
% %use the Datastore function to read all the CSV files in the folder
% ds = tabularTextDatastore(folder,'FileExtensions','.csv','SelectedVariableNames',{'Date_Time','SpdOfMaxGust_km_h_'});
% %a while loop divides the Datastore variable data into years
% wind_data = readall(ds);
% %Make a second set of data. Here we just replace <31 with 30.5 in the data
% t = cell2table(wind_data.SpdOfMaxGust_km_h_); %extract just the data column for modifications
% y = table2array(t); %prepare to make modifications
% y = strrep(y,'<31','30.5'); %make modifications
% wind_data.SpdOfMaxGust_km_h_ = y;
% %remove the rows with missing entries
% wind_data = rmmissing(wind_data);
% %Covert to DatTime
% temp_Date_Time = datetime(wind_data.Date_Time,'InputFormat','yyyy-MM-dd'); %Array that converts 'string date' to datetime format
% wind_data.Date_Time = temp_Date_Time;
% %Convert Wind data from String to Number
% Wind_Gust = cell2table(wind_data.SpdOfMaxGust_km_h_);
% Wind_Gust = table2array(Wind_Gust);
% Wind_Gust = str2double(Wind_Gust);
% wind_data.SpdOfMaxGust_km_h_ = (Wind_Gust);
% %Delete all the data below 60kmph
% A = wind_data;
% A = table2timetable(A);
% toDelete = A.SpdOfMaxGust_km_h_ < 60;
% A(toDelete,:) = [];
% %Calculate the time interval between the data
% A = timetable2table(A);
% for k = 2:numel(A.Date_Time)
% A.Time_Interval(k) = daysact(A.Date_Time(k-1), A.Date_Time(k));
% end
% %Copy it back to original
% wind_data = A;
