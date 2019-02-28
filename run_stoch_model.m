clear all
% This is a script to run the stochastic model variant without Amoeba. 
% it is essentially the model from Richgel's et al. 
% Load the stoichiometry matrix (population changes for each reaction)
get_stoich;
% load the parameters
define_parameters

% Get the propensity of each reaction. 
W = @(t,y) get_propensity(t,y,params);

% define the initial state
y0 = zeros(12,1);           
y0(1) = params.K*0.98;          % susceptible hosts
y0(2) = params.K*0.02;          % exposed hosts
y0(7) = 8.4*params.K*0.2;       % susceptible questing fleas
y0(10) = 8.4*params.K*0.8;      % susceptible on-host fleas
y0(6) = 0; 


for i=1:50
% run the SSA
[tout,yout]  = tau_leaping(1000, y0, S, W);
yout = yout';
%%
% Plotting
figure(1)
N = sum(yout(:,1:4),2);
subplot(1,2,1);
hold on
plot(tout,[yout(:,1:6) N],'linewidth',.5);
xlabel('Days','FontSize',20);
ylabel('Number','FontSize',20);
legend('S','E','I','R','Carcass','Soil','N');
subplot(1,2,2);
hold on
N2 = sum(yout(:,7:12),2);
plot(tout,[yout(:,7:12) N2],'linewidth',.5);
ylim([-1 5000]);
xlabel('Days','FontSize',20);
legend('Susceptible questing','EP1 questing','EP2 questing','Susceptible on host','EP1 on host','EP2 on host','N');
end