clear; % Clear Memory
clc; %Clear Command Window
%===================================
%CLEAR THE EXCEL FILE BEFORE RUNNING THE PROGRAM
%===================================

File = 'C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&Snow\Step1.xlsx';

% %=================================
% %===========================TORONTO AIRPORT
% %=================================
folder1='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Toronto_Airport';
%Get the maximum data points for Toronto Airport
MaxPoints{1,1} = CollectMaxDataPointsForAStation(folder1);
%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{1,1});
MaxPoints{1,1} = sortrows(temp,2,'descend');
writetable(MaxPoints{1,1},File,'Sheet','TorontoAirport');

% %=================================
% %===========================TRENTON
% %=================================
folder2='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\TRENTON';
%Get the maximum data points for Trenton
MaxPoints{2,1} = CollectMaxDataPointsForAStation(folder2);
%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{2,1});
MaxPoints{2,1} = sortrows(temp,2,'descend');
writetable(MaxPoints{2,1},File,'Sheet','Trenton');

%=================================
%===========================TORONTO ISLAND
%=================================
folder3='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Toronto_Island';
%Get the maximum data points for Toronto Island
MaxPoints{3,1} = CollectMaxDataPointsForAStation(folder3);
%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{3,1});
MaxPoints{3,1} = sortrows(temp,2,'descend');
writetable(MaxPoints{3,1},File,'Sheet','TorontoIsland');

% %=================================
% %===========================LONDON
%=================================
folder4='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\London';
%Get the maximum data points for London
MaxPoints{4,1} = CollectMaxDataPointsForAStation(folder4);
%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{4,1});
MaxPoints{4,1} = sortrows(temp,2,'descend');
writetable(MaxPoints{4,1},File,'Sheet','London');

% %=================================
% %===========================Wiarton
% %=================================
folder5='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Wiarton';
%Get the maximum data points for Wiarton
MaxPoints{5,1} = CollectMaxDataPointsForAStation(folder5);
%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{5,1});
MaxPoints{5,1} = sortrows(temp,2,'descend');
writetable(MaxPoints{5,1},File,'Sheet','Wiarton');

% %=================================
% %===========================KW
% %=================================
folder6='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\KW';
%Get the maximum data points for KW
MaxPoints{6,1} = CollectMaxDataPointsForAStation(folder6);
%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{6,1});
MaxPoints{6,1} = sortrows(temp,2,'descend');
writetable(MaxPoints{6,1},File,'Sheet','KW');

% %=================================
% %===========================Hamilton
% %=================================
folder7='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Hamilton';
%Get the maximum data points for Hamilton
MaxPoints{7,1} = CollectMaxDataPointsForAStation(folder7);
%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{7,1});
MaxPoints{7,1} = sortrows(temp,2,'descend');
writetable(MaxPoints{7,1},File,'Sheet','Hamilton');

% %=================================
% %===========================Sarnia
% %=================================
folder8='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Sarnia';
%Get the maximum data points for Sarnia
MaxPoints{8,1} = CollectMaxDataPointsForAStation(folder8);
%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{8,1});
MaxPoints{8,1} = sortrows(temp,2,'descend');
writetable(MaxPoints{8,1},File,'Sheet','Sarnia');