clear; % Clear Memory
clc; %Clear Command Window
File = 'C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&Snow\Step1.xlsx';

% %=================================
% %===========================TORONTO AIRPORT
% %=================================
folder1='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Toronto_Airport';
%Get the maximum data points for Toronto
MaxPoints{1,1} = CollectMaxDataPointsForAStation(folder1);
%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{1,1});
MaxPoints{1,1} = sortrows(temp,2,'descend');
writetable(MaxPoints{1,1},File,'Sheet','TorontoAirport');

% %=================================
% %===========================TRENTON
% %=================================
folder2='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\TRENTON';
%Get the maximum data points for Toronto
MaxPoints{2,1} = CollectMaxDataPointsForAStation(folder2);
%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{2,1});
MaxPoints{2,1} = sortrows(temp,2,'descend');
writetable(MaxPoints{2,1},File,'Sheet','Trenton');

%=================================
%===========================TORONTO ISLAND
%=================================
folder3='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Toronto_Island';
%Get the maximum data points for Toronto
MaxPoints{3,1} = CollectMaxDataPointsForAStation(folder3);
%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{3,1});
MaxPoints{3,1} = sortrows(temp,2,'descend');
writetable(MaxPoints{3,1},File,'Sheet','TorontoIsland');

% %=================================
% %===========================LONDON
%=================================
folder4='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\London';
%Get the maximum data points for Toronto
MaxPoints{4,1} = CollectMaxDataPointsForAStation(folder4);
%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{4,1});
MaxPoints{4,1} = sortrows(temp,2,'descend');
writetable(MaxPoints{4,1},File,'Sheet','London');

% %=================================
% %===========================Wiarton
% %=================================
folder5='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Wiarton';
%Get the maximum data points for Toronto
MaxPoints{5,1} = CollectMaxDataPointsForAStation(folder5);
%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{5,1});
MaxPoints{5,1} = sortrows(temp,2,'descend');
writetable(MaxPoints{5,1},File,'Sheet','Wiarton');