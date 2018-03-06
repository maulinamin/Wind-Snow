%this program is the function of Extracting the data above the threshold
function WindData = ExtractAboveThrehold(folder)
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
%Copy it to the output variable
WindData = A;

end