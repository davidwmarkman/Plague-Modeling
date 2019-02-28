clear all
% This is a script to a deterministic version of the model with amoeba.

% Load the model parameters
define_parameters

% Change some parameters to test different model variants. 
% params.betad = 0;
% params.k = 0.04; 
% params.K = 1000;
% params.p = 0.4;

% specify initial conditions. The vector y is defined in 
% richgels_odes.m. All ICs are zero unless defined below. 
y0 = zeros(16,1);           
y0(1) = params.K*0.98;          % susceptible hosts
y0(2) = params.K*0.02;          % exposed hosts
y0(7) = 8.4*params.K*0.2;       % susceptible questing fleas
y0(10) = 8.4*params.K*0.8;      % susceptible on-host fleas
y0(6) = 1; 
%y0(13) = sum(y0(1:4));

y0(13) = 1e9;
y0(15) = 1e9;

% time vector
tvec = 0:5000;
% solve the model
ODE = @(t,y) markman_odes(t,y,params);
[tout,yout] = ode23(ODE,tvec,y0);


%% plot results
% Add back in the variable N:
figure()
N = sum(yout(:,1:4),2);
subplot(1,3,1);
plot(tout,[yout(:,1:6) N],'linewidth',2.5);
xlabel('Days','FontSize',20);
ylabel('Number','FontSize',20);
legend('S','E','I','R','Carcass','Soil','N');
subplot(1,3,2);
N2 = sum(yout(:,7:12),2);
plot(tout,[yout(:,7:12) N2],'linewidth',2.5);
ylim([-1 5000]);
xlabel('Days','FontSize',20);
legend('Susceptible questing','EP1 questing','EP2 questing','Susceptible on host','EP1 on host','EP2 on host','N');
subplot(1,3,3); % Amoebas
%figure()
plot(tout,yout(:,13:16),'linewidth',2.5);
%ylim([-1 5000]);
xlabel('Days','FontSize',20);
legend('Susceptible Amoeba','Infected Amoeba','Susceptible Amoeba (cyst)','Infected Amoeba (cyst)');






