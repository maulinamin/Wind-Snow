%this program is the function of CollectMaxDataPointsForAStation
%Use this to verify the program
clear; % Clear Memory
clc; %Clear Command Window    
%Define the folder location of CSV files
    folder='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Hamilton';
    i=1; %Set i=1 so that it does not give error for data{0} which is impossible
    %use the Datastore function to read all the CSV files in the folder
    ds = tabularTextDatastore(folder,'FileExtensions','.csv','SelectedVariableNames',{'Date_Time','Total_Precip_mm_'});
    %a while loop divides the Datastore variable data into years
    while hasdata(ds)
        data{i} = read(ds);
        i=i+1;
    end
    %Make a second set of data. Here we just replace <31 with 30.5 in the data
    for k = 1:numel(data)
        data2{k,1} = data{1,k}; %extract data cell by cell
        t = cell2table(data{1,k}.SpdOfMaxGust_km_h_); %extract just the data column for modifications
        y = table2array(t); %prepare to make modifications
        y = strrep(y,'<31','30.5'); %make modifications
        data2{k,1}.SpdOfMaxGust_km_h_ = y; %overwrite the modified data into its old column
    end
    %Extract maximum data points for each of the years
    u = numel(data);
for k = 1:u
    A = (data2{k,1});
    temp_A_Date_Time = datetime(A.Date_Time,'InputFormat','yyyy-MM-dd'); %Array that converts 'string date' to datetime format
    A.Date_Time = temp_A_Date_Time;
    Wind_Gust = cell2table(data2{k,1}.SpdOfMaxGust_km_h_);
    Wind_Gust = table2array(Wind_Gust);
    Wind_Gust = str2double(Wind_Gust);
    if isnan(Wind_Gust)
        u = u-1;
        continue
    end
    A.SpdOfMaxGust_km_h_ = (Wind_Gust);
    A = table2timetable(A);
    idx = ~any(ismissing(A),2);
    A = A(idx,:);
    B = sortrows(A,1,'descend');
    B = timetable2table(B);
    MaxPoints(k,:) = B(1,:);
end
    u = numel(data);
    TEMP = MaxPoints;
    MaxPoints = rmmissing(TEMP);
    