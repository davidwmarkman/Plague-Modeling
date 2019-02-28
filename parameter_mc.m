%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a script to run the deterministic model with varying parameters. 
% it will collect the results into a matrix,
% then plot means +/- 1 stdv to see how sensitive the model 
% is to different parameter values. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


n_trials = 50; 
define_parameters
% make a struct of all of the free parameters. 
free_params = {'Br','lambdam','sigma','p','phi','betad',...
      'ra','mut','mut2','muc','epsilonc','epsilont'};
fns = fieldnames(params);
n_pars = length(fns);
all_params = {};
all_yout = [];
params.W = 10;
for i=1:n_trials
    % copy parameters
    tmp_pars = params;
    % generate new parameters within ~ 1 order of magnitude of the real
    % parameters. 
    rand_par = randi(length(free_params));
    tmp_pars.(free_params{rand_par}) = 10^(log10(tmp_pars.(free_params{rand_par})) + 10^(-.5)*randn);
    % store the new parameter vector
    all_params{i} = tmp_pars;
    % solve the model
    y0 = zeros(16,1);           

    y0(1) = tmp_pars.K;               % susceptible hosts
    y0(2) = tmp_pars.K*0.02;          % exposed hosts
    y0(7) = 8.4*tmp_pars.K*0.2;       % susceptible questing fleas
    y0(10) = 8.4*tmp_pars.K*0.8;      % susceptible on-host fleas
    y0(6) = 1; 
  
    y0(13) = 1e9;
    y0(15) = 1e9;
    tvec = 0:1:3000;           

    % solve the model
    ODE = @(t,y) markman_odes(t,y,tmp_pars);
    [tout,yout] = ode23(ODE,tvec,y0);
    
    % store the results
    all_yout(:,:,i) = yout;    
end

%% plot the results
mean_soln = mean(all_yout,3);
stdv = std(all_yout,1,3)+.001; % add a small minimum standard deviation. 
up = mean_soln+stdv;
down = mean_soln-stdv;

% Add back in the variable N:
N = sum(mean_soln(:,1:4),2);
colors = get(gca,'ColorOrder');
figure(1);
hold on
for i=1:5
    h = fill([tvec,flip(tvec)],[up(:,i);flip(down(:,i))]',colors(i,:));
    plot(tvec,mean_soln(:,i),'linewidth',2.5,'color',colors(i,:));
    for jj=1:50
        plot(tvec,all_yout(:,i,jj),'color',colors(i,:),'linewidth',.3)
    end        
    set(h,'facealpha',.5)
end
figure(2)
hold on
for j=7:12
    h = fill([tvec,flip(tvec)],[up(:,j);flip(down(:,j))]',colors(j-6,:));
    plot(tvec,mean_soln(:,j),'linewidth',2.5,'color',colors(j-6,:));
    for k=1:50
        plot(tvec,all_yout(:,j,k),'color',colors(j-6,:),'linewidth',.3)
    end        
    set(h,'facealpha',.5)
end
xlabel('Time (days)','fontsize',18)
ylabel('Species count','fontsize',18)
figure(3)
hold on
for j=[14 16]
    h = fill([tvec,flip(tvec)],[up(:,j);flip(down(:,j))]',colors(j-13,:));
    plot(tvec,mean_soln(:,j),'linewidth',2.5,'color',colors(j-13,:));
    for k=1:50
        plot(tvec,all_yout(:,j,k),'color',colors(j-13,:),'linewidth',.3)
    end        
    set(h,'facealpha',.5)
end
xlabel('Time (days)','fontsize',18)
ylabel('Species count','fontsize',18)

