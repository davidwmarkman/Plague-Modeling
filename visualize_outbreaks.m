function [tau]=visualize_outbreaks(all_yout)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[tau]=visualize_outbreaks(all_yout)
% This is a function to show individual trajectories and plot them.
% It also uses the algorithm described in the main text to detect
% outbreaks, and records the IOP and COT. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load 100 trajectores
data = [];
infected = [];
n_traj = size(all_yout,3);

%     all_yout = results.trajectories;
dtmp = all_yout(:,1,:);
intmp = all_yout(:,3,:);
dtmp = reshape(dtmp,size(all_yout,1),n_traj);
intmp = reshape(intmp,size(all_yout,1),n_traj);
data = [data dtmp];
infected = [infected intmp];


% Analyze time between outbreaks, community numbers before the outbreak, and the frequency of 
% Mini-outbreaks.
ndata = size(data,2);
tau = [];
COT = []; 
ind_pops = [];
tvec = 0:1:5000;
tvec = 0:1:size(all_yout,1);

for i=1:ndata
     % find the indices where the population drops below 10 p-dogs
     di = data(:,i);
     ii = infected(:,i);
     nz_infs = ii>0;
     nz_infs_plt = find(ii>0);
     inds = di<10;
     blank = zeros(length(di),1);
     inds_change = strfind(inds',[0 1]);
     blank(inds_change) = 1;
     
     nz_infs(inds_change) = sum(nz_infs(max(1,inds_change-10):inds_change))>0;
     total_locs = blank.*nz_infs;
     
      
     full_inds_change = find(total_locs==1);
     inds_change = full_inds_change';
     % find the max value right before the crash, assuming the crash
     % started in the last 10 days
     COT_TMP = [];
     IND_TMP = [];
     for j=1:length(inds_change)      
         inds_change
         if j == 1 & inds_change(j)>50
            [max_pop,ind_pop] = max(di(inds_change(j)-50:inds_change(j)))
            COT_TMP = [COT_TMP max_pop];
            COT = [COT max_pop];
            IND_TMP = [IND_TMP ind_pop+(inds_change(j)-50)];
            ind_pops = [ind_pops ind_pop+(inds_change(j)-50)];
         elseif inds_change(j)>50 & (inds_change(j)-inds_change(j-1))>150    
            [max_pop,ind_pop] = max(di(inds_change(j)-50:inds_change(j)))
            COT_TMP = [COT_TMP max_pop];
            COT = [COT max_pop];
            IND_TMP = [IND_TMP ind_pop+(inds_change(j)-50)];
            ind_pops = [ind_pops ind_pop+(inds_change(j)-50)];   
         end
         ind_pops
         tau = [tau diff(IND_TMP)];

      end
      
    figure(1)
    hold on      
    scatter(IND_TMP,di(IND_TMP),'k')
    scatter(inds_change,di(inds_change))
    hold on
    plot(di)
    pause
    clf;

end