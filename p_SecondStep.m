clear; % Clear Memory
clc; %Clear Command Window
%===================================
%CLEAR THE EXCEL FILE BEFORE RUNNING THE PROGRAM
%===================================

File = 'C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&Snow\p_Step1.xlsx';

% %=================================
% %===========================TORONTO AIRPORT
% %=================================
folder1='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Toronto_Airport';
%Get the maximum data points for Toronto Airport
MaxPoints{1,1} = CollectMaxPrecipPointsForAStation(folder1);
%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{1,1});
MaxPoints{1,1} = sortrows(temp,2,'descend');

% %=================================
% %===========================TRENTON
% %=================================
folder2='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\TRENTON';
%Get the maximum data points for Trenton
MaxPoints{2,1} = CollectMaxPrecipPointsForAStation(folder2);
%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{2,1});
MaxPoints{2,1} = sortrows(temp,2,'descend');

%=================================
%===========================TORONTO ISLAND
%=================================
folder3='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Toronto_Island';
%Get the maximum data points for Toronto Island
MaxPoints{3,1} = CollectMaxPrecipPointsForAStation(folder3);
%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{3,1});
MaxPoints{3,1} = sortrows(temp,2,'descend');

% %=================================
% %===========================LONDON
%=================================
folder4='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\London';
%Get the maximum data points for London
MaxPoints{4,1} = CollectMaxPrecipPointsForAStation(folder4);
%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{4,1});
MaxPoints{4,1} = sortrows(temp,2,'descend');

% %=================================
% %===========================Wiarton
% %=================================
folder5='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Wiarton';
%Get the maximum data points for Wiarton
MaxPoints{5,1} = CollectMaxPrecipPointsForAStation(folder5);
%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{5,1});
MaxPoints{5,1} = sortrows(temp,2,'descend');

% %=================================
% %===========================KW
% %=================================
folder6='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\KW';
%Get the maximum data points for KW
MaxPoints{6,1} = CollectMaxPrecipPointsForAStation(folder6);
%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{6,1});
MaxPoints{6,1} = sortrows(temp,2,'descend');

% %=================================
% %===========================Hamilton
% %=================================
folder7='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Hamilton';
%Get the maximum data points for Hamilton
MaxPoints{7,1} = CollectMaxPrecipPointsForAStation(folder7);
%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{7,1});
MaxPoints{7,1} = sortrows(temp,2,'descend');

% %=================================
% %===========================Sarnia
% %=================================
folder8='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Sarnia';
%Get the maximum data points for Sarnia
MaxPoints{8,1} = CollectMaxPrecipPointsForAStation(folder8);
%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{8,1});
MaxPoints{8,1} = sortrows(temp,2,'descend');

%=========================================================================
% Finding the threshold
%=========================================================================

%declare the location of the excel file in which we are going to write the
%data
File = 'C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&Snow\p_Step2.xlsx';

%for loop creates two tables: Low and High
%High table has the max points of all the stations
%Low table has the min points of all the stations
for k = 1:8
    T = MaxPoints{k,1};
    H = height(T);
    Low(k,:) = T(H,:);
    High(k,:) = T(1,:);
end
%Cell array with the names of the stations
City_Names = {'Toronto Airport';'Trenton';'Toronto Island';'London';'Wiarton';'KW';'Hamilton';'Sarnia'};
%Add a column with the names of the stations to the tables Low and High
Low.City_Names = City_Names; High.City_Names = City_Names;
%Renaming the variable names of the table so that when we join the two
%tables we can differentiate between the min and the max data
Low.Properties.VariableNames = {'Min_Date_Time','Min_TotalPrecip_mm_','City_Names'};
High.Properties.VariableNames = {'Max_Date_Time','TotalPrecip_mm_','City_Names'};
%join the two tables
Range = join(Low,High);
%Sort the two tables to find the range of the values that will help us
%decide the threshold.
Low = sortrows(Low,2,'ascend');
High = sortrows(High,2,'descend');
%Write the tables to an Excel Workbook so that I can share the data.
writetable(Range,File,'Sheet','Ranges');
writetable(Low,File,'Sheet','Minimum');
writetable(High,File,'Sheet','Maximum');