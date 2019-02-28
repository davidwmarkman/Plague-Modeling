
clear all
close all
% This is a script to plot the mean trajectories for the different models. 
% load trajectories from the different models.
tvec = 0:1:5000;
model_data_ids = {'results/all_trajectories_baseline.mat','results/all_trajectories_no_amoeba.mat','results/all_trajectories_no_cysts.mat',...
    'results/all_trajectories_no_immigration.mat','results/all_trajectories_no_alt_hosts.mat','results/all_trajectories_no_amoeba_high_resistance.mat',...
    'results/all_trajectories_no_amoeba_high_resistance_slow_loss.mat'};
model_names = {'Baseline','No amoeba','No cysts','No immigration','No alternative hosts','High resistance','High resistance slow loss'};
count = 1; 
for i=6:length(model_data_ids)
    figure(1)
    % plot the mean solutions
    hold on
    load(model_data_ids{i});
    mean_soln = mean(all_yout,3);
    plot(tvec,mean_soln(:,1),'linewidth',2.5)
    
    % make histograms
    analyze_metrics(all_yout,model_names{i},0)
    % if it is the "no amoeba" model, we want to know the (1) longest time
    % an infected prairie dog survived and (2) the longest time an infected
    % flea survived.
    if strcmp(model_names{i},'No amoeba')
        max_flea_time = [];
        max_inf_pdog_time = [];
        % loop over the trajectories
        for j = 1:size(all_yout,3)
            max_flea_time = [max_flea_time max(find(sum(all_yout(:,[8 9 11 12],j),2)~=0))];
            max_inf_pdog_time = [max_inf_pdog_time max(find(all_yout(:,5,j)~=0))];
        end
        display(['Max flea time: ' num2str(max(max_flea_time)) ])
        display(['Max infected p-dog time ' num2str(max(max_inf_pdog_time))])
    end
    plot_names{count} = model_names{i};
    count = count+1; 
end

figure(1)
xlabel('Time','FontSize',20)
ylabel('Number of S p-dogs','FontSize',20)
legend(plot_names)
savefig('figs/sample_resistance_figs')
