clear; % Clear Memory
clc; %Clear Command Window
%Location of the file
File = 'C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&Snow\p_Step3.xlsx';
%===================================
%CLEAR THE EXCEL FILE BEFORE RUNNING THE PROGRAM
%===================================
for SheetNum=1:9
     [N, T, Raw]=xlsread(File, SheetNum);
     [Raw{:, :}]=deal(NaN);
     xlswrite(File, Raw, SheetNum);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %=================================
% %===========================TORONTO AIRPORT
% %=================================
folder1='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Toronto_Airport';
PrecipData{1} = ExtractPrecipAboveThreshold(folder1);
writetable(PrecipData{1},File,'Sheet','TorontoAirport');

% %=================================
% %===========================TRENTON
% %=================================
folder2='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\TRENTON';
PrecipData{2} = ExtractPrecipAboveThreshold(folder2);
writetable(PrecipData{2},File,'Sheet','Trenton');

%=================================
%===========================TORONTO ISLAND
%=================================
folder3='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Toronto_Island';
PrecipData{3} = ExtractPrecipAboveThreshold(folder3);
writetable(PrecipData{3},File,'Sheet','TorontoIsland');

% %=================================
% %===========================LONDON
%=================================
folder4='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\London';
PrecipData{4} = ExtractPrecipAboveThreshold(folder4);
writetable(PrecipData{4},File,'Sheet','London');

% %=================================
% %===========================Wiarton
% %=================================
folder5='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Wiarton';
PrecipData{5} = ExtractPrecipAboveThreshold(folder5);
writetable(PrecipData{5},File,'Sheet','Wiarton');

% %=================================
% %===========================KW
% %=================================
folder6='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\KW';
PrecipData{6} = ExtractPrecipAboveThreshold(folder6);
writetable(PrecipData{6},File,'Sheet','KW');

% %=================================
% %===========================Hamilton
% %=================================
folder7='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Hamilton';
PrecipData{7} = ExtractPrecipAboveThreshold(folder7);
writetable(PrecipData{7},File,'Sheet','Hamilton');

% %=================================
% %===========================Sarnia
% %=================================
folder8='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Sarnia';
PrecipData{8} = ExtractPrecipAboveThreshold(folder8);
writetable(PrecipData{8},File,'Sheet','Sarnia');
