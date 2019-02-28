function [] = analyze_metrics(all_yout,model_id,verbose)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% analyze_metrics(all_yout,model_id,verbose)
% Analyze trajectories for outbreaks and store the results. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_traj = size(all_yout,3);
% split up data for convenience
dtmp = all_yout(:,1,:);
intmp = all_yout(:,3,:);
data = reshape(dtmp,5001,n_traj);
infected= reshape(intmp,5001,n_traj);


% Mini-outbreaks! 
ndata = size(data,2);
tau = [];
COT = []; 
ind_pops = [];
tvec = 0:1:5000;
for i=1:n_traj
     % find the indices where the population drops below 10 p-dogs
     di = data(:,i);
     ii = infected(:,i);
     nz_infs = ii>0;
     nz_infs_plt = find(ii>0);
     inds = di<10;
     %inds_inf = ii>0;
     blank = zeros(length(di),1);
     inds_change = strfind(inds',[0 1]);
     blank(inds_change) = 1;
     
     nz_infs(inds_change) = sum(nz_infs(max(1,inds_change-10):inds_change))>0;
     total_locs = blank.*nz_infs;
     
      
     full_inds_change = find(total_locs==1);
     inds_change = full_inds_change';
     % don't include first outbreak
     %tau = [tau diff(inds_change)];
     % Include first outbreak
     %tau = [tau diff([0 inds_change])];
     % find the max value right before the crash, assuming the crash
     % started in the last 10 days
     COT_TMP = [];
     IND_TMP = [];
     for j=1:length(inds_change)      
         if j == 1 & inds_change(j)>50
            [max_pop,ind_pop] = max(di(inds_change(j)-50:inds_change(j)));
            COT_TMP = [COT_TMP max_pop];
            COT = [COT max_pop];
            IND_TMP = [IND_TMP ind_pop+(inds_change(j)-50)];
            ind_pops = [ind_pops ind_pop+(inds_change(j)-50)];
         elseif inds_change(j)>50 & (inds_change(j)-inds_change(j-1))>150   
            [max_pop,ind_pop] = max(di(inds_change(j)-50:inds_change(j)));
            COT_TMP = [COT_TMP max_pop];
            COT = [COT max_pop];
            IND_TMP = [IND_TMP ind_pop+(inds_change(j)-50)];
            ind_pops = [ind_pops ind_pop+(inds_change(j)-50)];   
         end
         tau = [tau diff(IND_TMP)];

      end


end

h = figure()
histogram(tau,35,'facealpha',.5,'facecolor','k','edgecolor','none')
xlabel('Time between outbreaks')
ylabel('Frequency')
savefig(h,['figs/' model_id '_IOP_histogram_new'])
figure()
histogram(COT,35,'facealpha',.5,'facecolor','k','edgecolor','none')
xlabel('COT')
ylabel('Frequency')
savefig(['figs/' model_id '_COT_histogram_new'])
% Print out the statistics:
disp(['****RESULTS FOR MODEL: ' model_id])
disp(['Mean interoutbreak: ' num2str(mean(tau))])
disp(['Median interoutbreak: ' num2str(median(tau))])
disp(['Standard deviation interoutbreak: ' num2str(std(tau))])

disp(['Mean COT: ' num2str(mean(COT))])
disp(['Median COT: ' num2str(median(COT))])
disp(['Standard deviation COT: ' num2str(std(COT))])
