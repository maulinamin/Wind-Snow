%this program is the function of CollectMaxDataPointsForAStation
%Use this to verify the program
clear; % Clear Memory
clc; %Clear Command Window    
%Define the folder location of CSV files
    folder='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Hamilton';
    i=1; %Set i=1 so that it does not give error for data{0} which is impossible
    %use the Datastore function to read all the CSV files in the folder
    ds = tabularTextDatastore(folder,'FileExtensions','.csv','SelectedVariableNames',{'Date_Time','SpdOfMaxGust_km_h_'});
    %a while loop divides the Datastore variable data into years
    while hasdata(ds)
        wind_data{i} = read(ds);
        i=i+1;
    end
    %Make a second set of data. Here we just replace <31 with 30.5 in the data
    for k = 1:numel(wind_data)
        wind_data2{k,1} = wind_data{1,k}; %extract data cell by cell
        t = cell2table(wind_data{1,k}.SpdOfMaxGust_km_h_); %extract just the data column for modifications
        y = table2array(t); %prepare to make modifications
        y = strrep(y,'<31','30.5'); %make modifications
        wind_data2{k,1}.SpdOfMaxGust_km_h_ = y; %overwrite the modified data into its old column
    end