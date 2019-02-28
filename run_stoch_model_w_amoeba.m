clear all
% This is a script to run the stochastic model with amoeba. 
% First, load the stoichiometry matrix
get_stoich_amoeba;
% load the parameters
define_parameters

% get the propensity function
W = @(t,y) get_propensity_amoeba(t,y,params);

% define the initial state. y0 is a vector with entries for each
% species/class in the model. 
y0 = zeros(16,1);           
y0(1) = params.K*0.98;          % susceptible hosts
y0(2) = params.K*0.02;          % exposed hosts
y0(7) = 8.4*params.K*0.2;       % susceptible questing fleas
y0(10) = 8.4*params.K*0.8;      % susceptible on-host fleas
y0(6) = 1; 
y0(13) = 1e9;
y0(15) = 1e9;
 
colors = get(gca,'ColorOrder');
all_yout = [];
tf = 5000;
ntraj = 1;
for i=1:ntraj
    % run the SSA
    tic;
    [tout,yout]  = tau_leaping(tf, y0, S, W);
    %toc
    yout = yout';
    all_yout(:,:,i) = yout;
    disp(['Finished trajectory ' num2str(i) ' of ' num2str(ntraj)]);
end
all_yout=all_yout(1:10:end,:,:);
%% Plotting
for j=1:5
    % Plotting
    N = sum(all_yout(:,1:4,j),2);
    subplot(1,3,1);
    hold on
    h = plot(tout,[all_yout(:,1:5,j) N],'linewidth',.5);
    set(h, {'color'}, num2cell(colors(1:6,:),2));
    xlabel('Days','FontSize',20);
    ylabel('Number','FontSize',20);
    legend('S','E','I','R','Carcass','N');
    yl1 = ylim;
    subplot(1,3,2);
    hold on
    N2 = sum(all_yout(:,7:12,j),2);
    h = plot(tout,[all_yout(:,7:12,j) N2],'linewidth',.5);
    set(h, {'color'}, num2cell(colors(1:7,:),2));
    %h = set(h, {'color'}, num2cell(parula(6),6));
    ylim([-1 5000]);
    xlabel('Days','FontSize',20);
    legend('Susceptible questing','EP1 questing','EP2 questing','Susceptible on host','EP1 on host','EP2 on host','N');
    yl2 = ylim;
    subplot(1,3,3); % Amoebas
    hold on
    h = plot(tout,all_yout(:,[14 16],j),'linewidth',.5);
    set(h, {'color'}, num2cell(colors(1:2,:),2));
    %ylim([-1 5000]);
    xlabel('Days','FontSize',20);
    legend('Infected Amoeba','Infected Amoeba (cyst)');
    yl3 = ylim;
end


%% add a backgroup for weather . 
t=[0:1:tf];
G = (-cos(pi.*t/90)+1)/2;
G1 = repmat(G,100,1);
% G2 = repmat(G,100);
% G3 = rempat(G,100);
[X1,Y1] = meshgrid(t,linspace(yl1(1),yl1(2),100));
[X2,Y2] = meshgrid(t,linspace(yl2(1),yl2(2),100));
[X3,Y3] = meshgrid(t,linspace(yl3(1),yl3(2),100));
subplot(1,3,1);
imagesc(t,linspace(yl1(1),yl1(2),100),G1);
colormap('bone')
alpha(0.2)
subplot(1,3,2);
imagesc(t,linspace(yl2(1),yl2(2),100),G1);
colormap('bone')
alpha(0.2)
subplot(1,3,3)
imagesc(t,linspace(yl3(1),yl3(2),100),G1);
colormap('bone')
alpha(0.2)



