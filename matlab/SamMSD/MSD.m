function [MSD,taMSD,MSDstd,Disp_MSD] = MSD(tr,Disp);

%This function calculates time-averaged MSD ("taMSD") and  ensemble-time averaged
%MSD ("MSD") from the matrix "Disp", that contains displacements of all particles at all lag times.
    %taMSD has 4 columns:   [radius^2   theta^2   LagTime   ParticleNumber]
    %MSD has 3 columns:     [radius^2   theta^2   LagTime]

i=1;,j=1;
[n,m] = size(tr);               %find size of tr
tsteps = max(tr(:,3));          %find the number of time steps
part = unique(tr(:,4));         %find particle numbers in tr
[p1 p2] = size(part);           %p1 is the number of particles in tr
MSD = zeros(tsteps,3);          %intialize MSD matrix
taMSD = zeros(tsteps*p1,4);     %initialize the time-averaged (only) MSD matrix
MSDstd = zeros(tsteps,3);

% % % For Shalaka
Disp(:,1) = sqrt((Disp(:,2).^2));  %convert to radius (polar coord.)

% % % For David
%Disp(:,1) = sqrt((Disp(:,1).^2)+(Disp(:,2).^2));  %convert to radius (polar coord.)

Disp(:,2) = atan(Disp(:,2)./Disp(:,1));           %convert to theta (polar coord.)
Disp(:,1) = Disp(:,1).^2;                         %squares the radial displacements
Disp(:,2) = Disp(:,2).^2;                         %squares the theta displacements

for i = 1:p1;
    i = part(i);
    for j = 1:tsteps;
        TimeAvg = find(Disp(:,3)==j & Disp(:,4)==i);
        taMSD(i.*tsteps+j,:) = [mean(Disp(TimeAvg,1)) mean(Disp(TimeAvg,2)) j i];   %only the time-average of the squared displacements for each particle
    end
end

for j = 1:tsteps; %Ensemble particle time average i.e. for all frames lets say j=2 & all particles i=1,2,3...
        EnsTimeAvg = find(Disp(:,3)==j);
        MSD(j,:) = [mean(Disp(EnsTimeAvg,1)) mean(Disp(EnsTimeAvg,2)) j];       %calculate the mean of the squared displacements
        MSDstd(j,:) = [std(Disp(EnsTimeAvg,1)) std(Disp(EnsTimeAvg,2)) j]; %This helps check for ouliers later
end


Disp_MSD = Disp;    % UNITS [=] px^2; Puts all the displacement values used to calculate MSD at each lag time into a matrix that; David added on 07/23/2019
%------------------------------------------------------------------------
%This part checks for outliers, or particles which may not be at the
%interface by checking the MSD of each particle and comparing it's deviation 
%from the average MSD with 3 standard deviations.
%frames = 2;    %Only average the MSD over the first ... frames. (avoids influcence of drift at longer lag times)
difference = zeros(tsteps-1,2);
check = zeros(tsteps-1,2);
ThreeSD = zeros(tsteps-1,2);
ThreeSD = 3.*[MSDstd(1:(tsteps-1),1) MSDstd(1:(tsteps-1),2)];
c1 = 0;,c2 = 0;
for i = 1:p1;
    i = part(i);
    rowNum = find(taMSD(:,4)==i);
    difference(:,[1 2]) = taMSD(rowNum(1:tsteps-1),[1 2])-MSD(1:(tsteps-1),[1 2]);
    check(:,[1 2]) = (ThreeSD(:,[1 2])-difference(:,[1 2]));
    checkRows = find(check(:,1)<=0);
    [c1 c2] = size(checkRows);
    if (c1 >= 1);
        coord = mean(tr(find(tr(:,4)== i),[1 2]));
        MSD1 = taMSD(find(taMSD(:,4)==i & taMSD(:,3)==1),1);
        fprintf('\n!!!Potential rogue particle!!! Check particle %2.0f (MSD @T1 = %2.4f): x~%2.0f, y~%2.0f',i,MSD1,coord(1,1),coord(1,2))
    end
    c1 = 0;,c2 = 0;
end
%------------------------------------------------------------------------
%Plot the MSD and the taMSD on axis of 'pixels^2' vs 'frames'
figure(10);
set(figure(10),'DefaultAxesFontSize',14,'Color',[1 1 1]); %figure properties
loglog(MSD(:,3),MSD(:,1),'o');
hold on;
% errorbar(MSD(:,3),MSD(:,1),2.*MSDstd(:,1),2.*MSDstd(:,1))
% errorbar(MSD(:,3),MSD(:,1),2.*MSDstd(:,2),2.*MSDstd(:,2))
plot(taMSD(:,3),taMSD(:,1),'--r');
xlabel('Lag Time (Frames)');ylabel('MSD (pixels^2)');title('Not corrected for drift');
%xlabel('Time (s)');ylabel('MSD (micrometers^2)');

% % figure(11);                              %plot diffusivity vs time
% % set(figure(11),'DefaultAxesFontSize',14,'Color',[1 1 1]); %figure properties
% % loglog(Diff(:,2),Diff(:,1),'o');
% % axis([0 max(Diff(:,2)) 1E-7 1]);              %defines figure axis: axis([xmin xmax ymin ymax])
% % xlabel('Time (s)');ylabel('D (micrometers^2/s)');