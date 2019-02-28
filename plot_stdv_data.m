clear all
close all
% This is a script to plot mean trajectores +/- 1 standard deviation for a
% particular set of realizations of the stochastic model. 

% load 100 trajectores
tvec = 0:1:5000;
load('results/all_trajectories_baseline.mat');
data = all_yout;

% Get the mean and standard deviation of the data. 
mean_soln = mean(all_yout,3);
stdv = std(all_yout,1,3);

up = mean_soln+stdv;
down = mean_soln-stdv;
down(down<0) = 0;  % set the lower bound to be zero (populations can't be negative). 

% Add back in the variable N:
N = sum(mean_soln(:,1:4),2);
colors = get(gca,'ColorOrder');
pdog_labels = {'S','E','I','R','Carcass'};
figure(1);
hold on
all_plots = [];
for i=1:5
    h = fill([tvec,flip(tvec)],[up(:,i);flip(down(:,i))]',colors(i,:));
    all_plots = [ all_plots plot(tvec,mean_soln(:,i),'linewidth',2.5,'color',colors(i,:),'Displayname',pdog_labels{i})];
    for jj=1:3
        plot(tvec,all_yout(:,i,jj),'color',colors(i,:),'linewidth',.15)
    end        
    set(h,'facealpha',.2)
end
legend(all_plots, pdog_labels)
ylim([0 300])
figure(2)
hold on
flea_labels = {'Susceptible questing','EP1 questing','EP2 questing','Susceptible on host','EP1 on host','EP2 on host'};
all_plots = [];
for j=7:12
    h = fill([tvec,flip(tvec)],[up(:,j);flip(down(:,j))]',colors(j-6,:));
    all_plots = [all_plots plot(tvec,mean_soln(:,j),'linewidth',2.5,'color',colors(j-6,:))];
    for k=1:5
        plot(tvec,all_yout(:,j,k),'color',colors(j-6,:),'linewidth',.15)
    end        
    set(h,'facealpha',.2)
end
xlabel('Time (days)','fontsize',18)
ylabel('Species count','fontsize',18)
legend(all_plots, flea_labels)

figure(3)
hold on
amoeba_labels = {'susceptible amoeba','infected amoeba'};
all_plots = [];
for j=[14 16]
    h = fill([tvec,flip(tvec)],[up(:,j);flip(down(:,j))]',colors(j-13,:));
    all_plots = [all_plots plot(tvec,mean_soln(:,j),'linewidth',2.5,'color',colors(j-13,:))];
    for k=1:5
        plot(tvec,all_yout(:,j,k),'color',colors(j-13,:),'linewidth',.15)
    end        
    set(h,'facealpha',.2)
end
xlabel('Time (days)','fontsize',18)
ylabel('Species count','fontsize',18)
legend(all_plots, amoeba_labels)
