clear; % Clear Memory
clc; %Clear Command Window
%===================================
%CLEAR THE EXCEL FILE BEFORE RUNNING THE PROGRAM
%===================================

% File = 'C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&Snow\Step1.xlsx';

% %=================================
% %===========================TORONTO AIRPORT
% %=================================
folder1='C:\Users\Maulin Amin\OneDrive - University of Waterloo\Waterloo\Winter 2018\Environment Canada\Wind&SnowData\CSV\Toronto_Airport';
%Get the maximum data points for Toronto Airport
MaxPoints{1,1} = CollectMaxDataPointsForAStation(folder1);

%Sort and rewrite the maximum data points for Toronto
temp = (MaxPoints{1,1});
MaxPoints{1,1} = sortrows(temp,2,'ascend');
temp = (MaxPoints{1,1});
PPP = table2timetable(temp);
PPP.Properties.VariableNames{'SpdOfMaxGust_km_h_'} = 'Kmph';
%calculations for PPP
z = numel(PPP);
for k = 1:z
    PPP.Ln_Kmph(k) = log(PPP.Kmph(k));
end
for k = 1:z
    PPP.Rank(k) = k;
end
for k = 1:z
    PPP.Pi(k) = k/(z+1);
end
for k = 1:z
    PPP.InvPi(k) = norminv(PPP.Pi(k));
end
for k = 1:z
    PPP.ExpPi(k) = -log(1-PPP.Pi(k));
end
for k = 1:z
    PPP.WeibPi(k) = log(-log(1-PPP.Pi(k)));
end
for k = 1:z
    PPP.GumbPi(k) = -log(-log(PPP.Pi(k)));
end

%PLOT THE Gumbel PPP
p = polyfit(PPP.GumbPi,PPP.Kmph,1); 
f = polyval(p,PPP.GumbPi); 
plot(PPP.GumbPi,PPP.Kmph,'.',PPP.GumbPi,f,'-')
grid on;
legend('data','linear fit')
dim = [0.2 0.5 0.3 0.3];
mdl = fitlm(PPP.GumbPi,PPP.Kmph);
ylabel('Data(Xi)'); xlabel('(-Ln(-Ln(Pi)))');
X = sprintf('Gumbel');
legend('data','linear fit','Location','southeast')
title(X);
%set(gca,'Ylim',[30 160]) % Adjust Y limits of "current axes"
set(gca,'FontName','Times');
set(gcf,'Units','inches') % Set figure size units of "current figure"
set(gcf,'Color','white');
set(gcf,'Position',[0,0,7.5,5.5]) % Set figure width (6 in.) and height (4 in.)


