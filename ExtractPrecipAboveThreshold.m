%this program is the function of Extracting the data above the threshold
function Precipitation_mm = ExtractPrecipAboveThrehold(folder)
%use the Datastore function to read all the CSV files in the folder
ds = tabularTextDatastore(folder,'FileExtensions','.csv','SelectedVariableNames',{'Date_Time','TotalPrecip_mm_'});
%a while loop divides the Datastore variable data into years
precip = readall(ds);
%remove the rows with missing entries
precip = rmmissing(precip);
%Covert to DatTime
temp_Date_Time = datetime(precip.Date_Time,'InputFormat','yyyy-MM-dd'); %Array that converts 'string date' to datetime format
precip.Date_Time = temp_Date_Time;
%Convert Wind data from String to Number
Precip_mm = cell2table(precip.TotalPrecip_mm_);
Precip_mm = table2array(Precip_mm);
Precip_mm = str2double(Precip_mm);
precip.TotalPrecip_mm_ = (Precip_mm);
%Delete all the data below 60kmph
A = precip;
A = table2timetable(A);
toDelete = A.TotalPrecip_mm_ < 10;
A(toDelete,:) = [];
%Calculate the time interval between the data
A = timetable2table(A);
for k = 2:numel(A.Date_Time)
    A.Time_Interval(k) = daysact(A.Date_Time(k-1), A.Date_Time(k));
end
toDelete = A.Time_Interval < 7;
A(toDelete,:) = [];
%Copy it to the output variable
Precipitation_mm = A;

end