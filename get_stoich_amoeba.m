%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a script to build a stoichimetry matrix for the stochastic 
% model with amoeba. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Prairie dog stuff
N = 5;
S = zeros(5,17);
% First row is for the susceptible  
S(1,1) = -1;             % Natural pdog death
S(1,2) = 1;              % Recovered individuals return to S
S(1,3:7) = -1;           % (3) exposed through EP1 questing fleas
                         % (4) exposed through EP2 questing fleas
                         % (5) exposed through carcasses
                         % (6) exposed through infected p-dogs
                         % (7) exposed via amoeba
S(1,8)=1;                % immigration/breeding season

% Second row is exposed
S(2,3:7) = 1;            % (3) exposed through EP1 questing fleas
                         % (4) exposed through EP2 questing fleas
                         % (5) exposed through carcasses
                         % (6) exposed through infected p-dogs
                         % (7) exposed via amoeba      

S(2,9:10) = -1;          % (9) exposed pdogs die 
                         % (10) exposed pdogs become infected
 
% Third row is infected
S(3,10) = 1;             % exposed pdogs become infected
S(3,11) = -1;            % infected pdogs die

% Fourth row is resistant
S(4,2) = -1;             % Recovered individuals return to S
S(4,12) = 1;             % Gain resistant pdogs from exposed
S(2,12) = -1;
S(4,13) = -1;            % Resistant pdogs die
% Fifth row is Carcasses
S(5,11) = 1;             % infected pdogs become infectious carcasses
S(5,14) = -1;            % infected pdogs decay
% Sixth row is soil, to be consistent with the ODE model, but is all
% zeros...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fleas
% 7th row is Susceptible questing fleas (F.sq)
S(7,15) = 1;        % gain from on host fleas
S(7,16) = 1;        % gain by conversion?
S(7,17) = -1;       % lose to mortality
S(7,18) = -1;       % lose to host
S(7,19) = 1;        % gain from infected EP2 questing (F.lq)

% 8th row is EP1 Infected questing fleas (F.eq)
S(8,20) = 1;        % gain from leaving host
S(8,21) = 1;        % gain from dying host
S(8,22) = -1;       % lose from natural mortality 
S(8,23) = -1;       % lose from questing to on-host
S(8,24) = -1;        % lose from transfer to EP2

% 9th EP2 Infected questing fleas (F.lq)
S(9,25) = 1;        % gain from leaving host
S(9,26) = 1;        % gain from dying host
S(9,27) = -1;       % lose from natural mortality 
S(9,28) = -1;       % lose from questing
S(9,24) = 1;        % gain from transfer from EP1
S(9,19) = -1;       % Lose to susceptible questing

% 10th Susceptible on-host fleas
S(10,18) = 1;        % gain from susceptible questing fleas
S(10,29) = -1;       % lose from mortality
S(10,15) = -1;       % lose to susceptible questing                          
S(10,30) = -1;       % host to vector/?
S(10,31) = 1;        % transition from EP2 to susceptible on host
S(10,8) = 8;        % gain on host fleas 

% 11th EP1 Infected on-host fleas
S(11,23) = 1;       % Gain from EP1 infected questingc
S(11,20) = -1;      % lose to questing
S(11,32) = -1;      % Lose from mortality
S(11,21) = -1;      % lose because host died, normal. 
%S(11,22) = -1;        % lose because host died from infection.
S(11,33) = -1;        % lose when transition from EP1 to EP2. 
S(11,30) = 1;         % infected by pdogs??
S(11,34) = 1;         % infected by other pdogs.

% 12th EP2 on host
S(12,28) = 1;        % Gain from EP2 questing
S(12,33) = 1;        % Gain from EP1 on host
S(12,35) = -1;       % lose from mortality
S(12,36) = -1;       % lose because host died normal 
S(12,37) = -1;       % lose becuase host died infection
S(12,34) = -1;       % infected by pdogs?
S(12,31) = -1;       % lose to susceptible. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Amoebas

% Infected mobile amoeba
S(14,38) = 1;        % Gain infected amoeba from carcass 
S(14,39) = 1;        % Gain infected amoeba from reproduction 
S(14,40) = 1;        % Gain from infected cyst.
S(14,41) = -1;       % transfer into dormancy 
S(14,42) = -1;       % die during optimal
S(14,43) = -1;       % die during non-optimal

% Infected cyst amoeba
S(16,41) = 1;        % Gain from mobile. 
S(16,40) = -1;       % Lose to mobile
S(16,44) = -1;       % natural mortality of cyst.



