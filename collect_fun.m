clear; % Clear Memory
clc; %Clear Command Window
%Define the folder location of CSV files
folder='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Toronto_Airport';
i=1; %Set i=1 so that it does not give error for data{0} which is impossible
%use the Datastore function to read all the CSV files in the folder
ds = tabularTextDatastore(folder,'FileExtensions','.csv','SelectedVariableNames',{'Date_Time','SpdOfMaxGust_km_h_'});
%a while loop divides the Datastore variable data into years
while hasdata(ds)
    data{i} = read(ds);
    i=i+1;
end
%Make a second set of data. Here we just replace <31 with 30.5 in the data
for k = 1:49
    data2{k,1} = data{1,k};
    t = cell2table(data{1,k}.SpdOfMaxGust_km_h_);
    y = table2array(t);
    y = strrep(y,'<31','30.5');
    data2{k,1}.SpdOfMaxGust_km_h_ = y;
end
%summary(A)

%====================================================================
%DISCARDED CODE
%read the files using a slow method
% filetype='*.csv';  % or xlsx
% f=fullfile(folder,filetype);
% d=dir(f);
% count = numel(d);
% for k=1:count
%   data{k}=readtable(fullfile(folder,d(k).name));
% end
% %Generate a sequence of years
% years = 1970:1:2018;
% serial_number = 1:1:49;
% row = 24;
% j = 2;
% %delete the unecessary data columns
% for r = 1:24
%     for k = 1:count
%         data{1,k}(:,2) = [];
%     end
% end
% %delete the last unecessary data column
% for k = 1:count
%     data{1,k}(:,3) = [];
% end
% TorontoAirportFilename = "C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&Snow\StationXLSX\TorontoAirport.xlsx"
% 
% % B = data{1,1}(:,26);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXTRACT required data for one year
% A = data{1,1};
% s = cell2table(data{1,1}.SpdOfMaxGust_km_h_);
% u = table2array(s);
% u = strrep(u,'<31','30.5');
% A.SpdOfMaxGust_km_h_ = u;
