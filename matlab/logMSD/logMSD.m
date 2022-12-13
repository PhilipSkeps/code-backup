Data = readmatrix(FILE);

hold on

xlabel('lagtime (ps)');
ylabel('Log MSD (units)');

loglog(Data(:,1), Data(:,2))
loglog(Data(:,1), Data(:,3))

legend('LogMSDFlake1', 'LogMSDFlake2');

grid on

hold off

uiwait(helpdlg('Examine the figures, then click OK to finish.'));
fprintf("finished\n")