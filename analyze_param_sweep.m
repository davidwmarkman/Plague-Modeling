% a script to analyze the parameter sweep

% first load the data into a tensor
%ra = [0.02 .2 2 20];
% ra = [0,0.1, 0.15, 0.2, 0.25,1,10];
% ra = [0,0.1,.5,1,10];
% ec = [0,0.002,0.05, 0.1, 0.15, 0.2];
% ec = [0,0.002,0.02,0.2];
% p = [.001 .01 .1 0.5];
% p = [0,0.005, 0.01, 0.015, 0.02,0.1,1];
% p = [0,0.01,.1,1];

ra = [0,0.1,0.2,0.5];
ec = [0,0.05,0.1,0.2];
p = [0.01,0.05,0.1,0.5];
% 
% ec = [0.0,0.1];
% ra = [0.0,0.1];
% p = [0.1,0.1];

all_med_cot = zeros(4,4,4);
all_med_tau = zeros(4,4,4);
all_var_cot = zeros(4,4,4);
all_var_tau = zeros(4,4,4);
for i=1:length(ra)
    for j=1:length(ec)
        for k = 1:length(p)
            try
            load(['results/sweep/outbreak_analysis_ra_' num2str(ra(i)) '_ec_' num2str(ec(j)) '_p_' num2str(p(k)) '.mat']);
            all_med_cot(i,j,k) = results.median_cot;
            all_var_cot(i,j,k) = results.var_cot;
            all_med_tau(i,j,k) = results.median_tau;
            all_var_tau(i,j,k) = results.var_tau;
            %re-analyze the number of outbreaks on a per-trajectory basis. 
            %analyze_metrics(results.all_yout,'param_sweep',1)

            catch
                disp(['Unable to load file: ' 'results/sweep/outbreak_analysis_ra_' num2str(ra(i)) '_ec_' num2str(ec(j)) '_p_' num2str(p(k)) '.mat'])
                continue
            end
        end
    end
end
% for i=1:length(ra)
% %             try
%             load(['results/sweep/outbreak_analysis_ra_' num2str(ra(i)) '_ec_' num2str(ec(i)) '_p_' num2str(p(i)) '.mat']);
% %             all_med_cot(i,j,k) = results.median_cot;
% %             all_var_cot(i,j,k) = results.var_cot;
% %             all_med_tau(i,j,k) = results.median_tau;
% %             all_var_tau(i,j,k) = results.var_tau;
%             %re-analyze the number of outbreaks on a per-trajectory basis. 
%             analyze_metrics(results.trajectories,'param_sweep',1)
%             figure()
%             hold on
%             mean_soln = mean(results.trajectories,3);
%             plot(mean_soln(:,1),'linewidth',2.5)
%             plot(reshape(results.trajectories(:,1,:),50001,100),'k','linewidth',.3)
% %             catch
% %                 %disp(['Unable to load file: ' 'results/sweep/outbreak_analysis_ra_' num2str(ra(i)) '_ec_' num2str(ec(i)) '_p_' num2str(p(i)) '.mat'])
% %                 continue
% %             end
% end
%% make the contour plots
[XX,YY] = meshgrid(ec,ra);
minval = min(min(min(all_med_cot)));
maxval = max(max(max(all_med_cot)));
mintau = min(min(min(all_med_tau)));
maxtau = max(max(max(all_med_tau)));
for k =1:length(p)
    figure(1)
    subplot(1,length(p),k)    
%    contourf(XX,YY,all_med_cot(:,:,k))
%   set(gca,'xscale','log','yscale','log')
    imagesc(all_med_cot(:,:,k),[minval,maxval])
    xticks(1:length(ec));
    yticks(1:length(ra));
    xticklabels(ec);
    yticklabels(ra);
    title(['p=' num2str(p(k))])
    if k==1
        xlabel('\epsilon_c','Fontsize',22)
        ylabel('R_a')
    end
    
    figure(3)
    subplot(1,length(p),k)    
%    contourf(XX,YY,all_med_cot(:,:,k))
%   set(gca,'xscale','log','yscale','log')
    imagesc(sqrt(all_var_cot(:,:,k)))
    xticks(1:length(ec));
    yticks(1:length(ra));
    xticklabels(ec);
    yticklabels(ra);
    title(['p=' num2str(p(k))])
    if k==1
        xlabel('\epsilon_c','Fontsize',22)
        ylabel('R_a')
    end

    figure(2)
    subplot(1,length(p),k)
%    contourf(XX,YY,all_med_tau(:,:,k))
%    set(gca,'xscale','log','yscale','log')
    if k==1
        xlabel('\epsilon_c','Fontsize',22)
        ylabel('R_a')
    end

    imagesc(all_med_tau(:,:,k),[mintau,maxtau])
    xticks(1:length(ec));
    yticks(1:length(ra));
    xticklabels(ec);
    yticklabels(ra);
    title(['p=' num2str(p(k))])
    
    figure(4)
    subplot(1,length(p),k)
%    contourf(XX,YY,all_med_tau(:,:,k))
%    set(gca,'xscale','log','yscale','log')
    if k==1
        xlabel('\epsilon_c','Fontsize',22)
        ylabel('R_a')
    end

    imagesc(sqrt(all_var_tau(:,:,k)))
    xticks(1:length(ec));
    yticks(1:length(ra));
    xticklabels(ec);
    yticklabels(ra);
    title(['p=' num2str(p(k))])

end
figure(1)
colorbar
suptitle('Median outbreak threshold')
figure(2)
colorbar
suptitle('Median time between outbreaks')
figure(3)
colorbar
suptitle('Variance outbreak threshold')
figure(4)
colorbar
suptitle('Variance time between outbreaks')

