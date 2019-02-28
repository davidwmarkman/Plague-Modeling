% a script to generate the parameters object, which is 
% then saved as parameters.mat, and contains the 
% MATLAB object params. 
params.K = 200; % carrying capacity
params.mu = 0.0002;       % natural mortality rate
params.betam = 0.073;     % transmission rate from carcasses
params.betai = 0.073;     % transmission rate from direct contact
params.betad = 0.00096;   % transmission from soil
%params.lambdad = 0.035;  % decay rate of soil\]
%params.lambdad = 0.35;  % decay rate of soil
params.B = 20;            % burrows used per day for PDs
params.Br = 4.25;         % active PD burrows used per day for small rodents
params.sigma = 0.22;      % exposed period ^ -1
params.alpha = 0.5;       % disease induced mortality rate
%params.lambdam = 0.017;   % infectious carcass decay rate
%params.lambdam = 0.09;     % infectious carcass decay rate
params.lambdam = 0.04;     % infectious carcass decay rate
%params.lambdam = 0.0;    % infectious carcass decay rate
params.p = 0.01;          % probability of gaining resistance
params.phi = 0.011;       % rate resistance is lost
params.betae = 0.044;     % transmission rate for EP1
params.betal = 0.01;      % transmission rate for EP2
params.delta = 0.059;     % rate of leaving hosts
params.a = 0.02;          % questing efficiency
params.muf = 0.01;        % natural mortality rate
params.mufq = 0.07;       % questing mortality rate
params.rf = 1.5;          % conversion efficiency
params.gamma = 0.84;      % transmission rates hosts to vector
params.thetae = 1;        % transition from EP1 to EP2 while feeding
params.thetal = 1;        % transition from EP2 to susceptible while feeding
params.epsilon = 0.125;   % transition from EP1 to EP2 while not feeding
params.xi = 0.033;         % transition from EP2 to susc. while not feeding
params.psi = 0.79;         % proportion of infecteds that are pneumonic
params.sd = 0.10;         % standard deviation, as a proportion of the mean
params.W = 10;            % Number of new p-dogs that immigrate each year. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% New parameters to incorporate Amoeba submodel.
params.betaa = 0.00096;       % Transmission rate from Ai to E
%params.betaa = 0.0;            % Transmission rate from Ai to E
params.ra =  0.2;                 % Reproductive rate of trophozoite amoeba
params.Ka = 4e8;               % Average carrying capacity of trophozoite amoeba in soil area represented by D.
params.mut = 0.04762;          % Natural mortality of trophozoites under optimal condition
params.mut2 = 0.16666;         % Natural mortality of trophozoites under sub-optimal conditions
params.betas = 0.014;         % Transmission rate from As to Ai given contact with D
%params.epsilonc = 0.15833;     % Rate of transition from trophozoite to mature cyst (As/i to Ac s/i)
params.epsilonc = 0.2;     % Rate of transition from trophozoite to mature cyst (As/i to Ac s/i)

%params.epsilont = params.epsilonc+.1*params.epsilonc; 
params.epsilont = .4*params.epsilonc;
params.muc = 0.000130463;      % Natural mortality of cysts
%params.muc = 0.000391;     
%params.k = .336;
params.k = .0336;

params.s = 150;
params.b = -pi/3;

% Connecting soil and bacteria to amoeba.
Q = 6.5e8;            % bacteria/D 
q = 3.90;             % bacteria/amoeba
params.q_star = 182e6; %;

params.C = 66;           % critical community threshold

%params.rw = 8.4;         % increase fleas based on pdog birth/immigration
% Save the params object to the file parameters.mat
save('parameters','params')