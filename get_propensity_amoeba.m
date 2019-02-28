function W = get_propensity_amoeba(t,y,params)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Update the propensity function for the stochastic system, with amoeba.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prairie dog stuff
N = sum(y(1:4));
F0 = y(10) + y(8) + y(9); 
% (S) Prairie dog natural mortality
W(1) = params.mu*y(1);    
% Prairie dogs recover to susceptible 
W(2) = params.phi*y(4); 
% Prairie dogs become exposed through other fleas 
W(3) = params.betae * y(8) * y(1) *(1 - exp(-params.a * N / (params.B - params.Br))); 
W(4) = params.betal * y(9) * y(1) * (1 - exp(-params.a * N / (params.B - params.Br)));
% Prairie dogs run into carcasses. 
W(5) = params.betam * y(1) * (y(5) / (params.B - params.Br));
% Prairie dogs 
W(6) = params.betai * y(1)* ( params.psi * y(3) / (params.B - params.Br));
% Amoeba
W(7) = params.betad * y(1) * ((y(14)/params.q_star) / (params.B - params.Br));
%W(7) = 0; % for testing
% Immigration/breeding season
W(8) = params.k.*exp(-params.s.*cos((pi/365)*t+pi/2.5).^2)*(y(1)+y(4)+params.W)*(1- min([1,N/params.K]));
% Exposed prairie dogs die
W(9) = y(2)*params.mu; 
% Exposed prairie dogs become infected
W(10) = y(2)*params.sigma*(1-params.p);
% Infected prairie dogs die. 
W(11) = y(3)*params.alpha;
% Prairie dogs become resistant
W(12) = y(2)*params.sigma*(params.p);
% (R) Prairie dogs natural death
W(13) = y(4)*params.mu; 
% Carcass leakage into the soil
W(14) = params.lambdam*y(5); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Flea stuff
% Susceptible on-host fleas become questing
W(15) = params.delta*y(10);
% Conversion ?/????
W(16) = params.rf * F0 * (N / (1 + N + F0));
% Susceptible questing fleas die
W(17) = y(7)*params.mufq; 
% Susceptible questing fleas jump onto host
W(18) = y(7)*(1 - exp(-params.a * N / (params.B - params.Br)));
% Infected questing fleas (EP1) become susceptible questing fleas
W(19) = params.xi * y(9);
% Gain EP1 questing from EP1 on host
W(20) = y(11)*params.delta;
% Gain EP1 questing when EP1 on host when host dies
W(21) = y(11)*params.alpha; 
% Lose EP1 questing from natural mortality
W(22) = y(8)*params.mufq;
% Lose EP1 quest to EP1 on hose
W(23) = y(8)*(1 - exp(-params.a * N / (params.B - params.Br)));
% Lose EP1 quest to EP2 quest
W(24) = params.epsilon * y(8);
% Gain EP2 questing that leave host
W(25) = y(12)*params.delta;
% Gain EP2 questing From dying host
W(26) = y(12)*params.alpha;
% Lose EP2 questing From dying host
W(27) = y(9)*params.mufq;
% Lose EP2 questing to EP2 on host 
W(28) = y(9)*(1 - exp(-params.a * N / (params.B - params.Br)));
% Death of susceptible on-host fleas
W(29) = y(10)*params.muf; 
% Get transfered ?
W(30) = params.gamma * y(3) *y(10)/ N;
% S on host gains from EP2 on host
W(31) =  params.thetal * y(12) * (y(1) + y(2) + y(4)) / N;
% Lose EP1 on host to mortality. 
W(32) = y(11) * params.muf; 
% Lose from on host EP1->EP2 transition
W(33) = params.thetae*y(11)*(y(1)+y(2)+y(4))/N;
% Gain from EP2 on host/dying pdogs
W(34) = params.gamma * y(12) * y(3) / N;
% Lose EP2 on host from mortality
W(35) = y(12)*params.muf;
% Lose EP2 because host died normally
W(36) = y(12)*params.delta;
% Lose EP2 because host died another way
W(37) = y(12)*params.alpha;
% Lose EP2 due to class conversion of some kind 
% W(38) = y(12)*params.gamma*y(3)/N; 
%W(45) = params.k.*exp(-params.s.*cos((pi/365)*t+pi/2.5).^2)*(y(1)+y(4)+params.W)*(1- min([1,N/params.K]))*params.rw;
%%%%%
% Amoeba
G = @(t) (-cos(pi*t/90)+1)/2;
J = @(t) 1-G(t);
% Gain infected amoeba from carcass
W(38) =  y(5)*params.lambdam*params.q_star;
% Gain infected amoeba from reproduction 
W(39) = params.ra*y(14)*(1-min([(y(14)/params.Ka),1]))*G(t);
% Gain from infected cyst.
W(40) = params.epsilont*G(t)*y(16); 
% transfer into dormancy
W(41) = params.epsilonc*(1-G(t))*y(14);
% Lose to optimal
W(42) = params.mut*y(14)*G(t);
% Lose to death, nonoptimal
W(43) = params.mut2*y(14)*J(t);
% natural mortality of cyst.
W(44) = params.muc*y(16); 



end 
