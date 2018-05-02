%this program is the function of CollectMaxPrecipPointsForAStation for
%Precipitation
%Use this to verify the program
function MaxPoints = CollectMaxPrecipPointsForAStation(folder)   
%Define the folder location of CSV files
folder='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Hamilton';
i=1; %Set i=1 so that it does not give error for data{0} which is impossible
%use the Datastore function to read all the CSV files in the folder
ds = tabularTextDatastore(folder,'FileExtensions','.csv','SelectedVariableNames',{'Date_Time','TotalPrecip_mm_'});
%a while loop divides the Datastore variable data into years
while hasdata(ds)
    data{i} = read(ds);
    i=i+1;
end
%traspose the cells in data cell
for k=1:numel(data)
    data2{k,1} = data{1,k};
end
%Extract maximum data points for each of the years
u = numel(data);
for k=1:u
    A = (data2{k,1});
    temp_A_Date_Time = datetime(A.Date_Time,'InputFormat','yyyy-MM-dd');
    A.Date_Time = temp_A_Date_Time;
    Precip = cell2table(data2{k,1}.TotalPrecip_mm_);
    Precip = table2array(Precip);
    Precip = str2double(Precip);
    A.TotalPrecip_mm_ = (Precip);
    A = table2timetable(A);
    idx = ~any(ismissing(A),2);
    A = A(idx,:);
    B = sortrows(A,1,'descend');
    B = timetable2table(B);
    MaxPoints(k,:) = B(1,:);
end
