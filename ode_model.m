function [dydt] = ode_model(t,y,params)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Implementation of SEIR model from Richgels et al, 2016. 
    % Transcribed from the R codes to integrate the model.
    % y(1): S
    % y(2): E
    % y(3): I
    % y(4): R 
    % y(5): Carcasses 
    % y(6): Soil
    % y(7): susceptible questing fleas (F.sq Richgels)
    % y(8): EP1 infected questing fleas (F.eq Richgels)
    % y(9): EP2 infected questing fleas (F.lq Richgels)
    % y(10): susceptible fleas on host (F.sh Richgels)
    % y(11): EP1 infected on host fleas (F.eh Richgels)
    % y(12): EP2 infected on host fleas (F.lh Richgels)
    % y(13): Susceptible amoeba
    % y(14): Infected amoeba 
    % y(15): Susceptible amoeba in cyst form
    % y(16): Infected amoeba in cyst form
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Number of prarie dogs: 
    N = sum(y(1:4)); 
    % Set a minimum value for the variables.
    y(y<1e-5)=0;
    % Define a simple G function for the time being. 
    %G = @(t) max([0,ceil(-cos(pi*t/90))]);
    G = @(t) (-cos(pi*t/90)+1)/2;
    J = @(t) 1-G(t);
    
    % ensure that N>=1
    if N<1
        N=1;
    end
    
    dydt = zeros(length(y),1);
    % Susceptible prairie dogs, 'S'
    dydt(1) = -params.mu * y(1) + params.phi * y(4)  + threshold*(-params.betae * y(8) * y(1) *(1 - exp(-params.a * N / (params.B - params.Br)))...
    - params.betal * y(9) * y(1) * (1 - exp(-params.a * N / (params.B - params.Br)))...
    - params.betam * y(1) * (y(5) / (params.B - params.Br))...
    - params.betai * y(1)* ( params.psi * y(3) / (params.B - params.Br))...
    - params.betad * y(1) * ((y(14)/params.q_star) / (params.B - params.Br)))...
    + params.k.*exp(-params.s.*cos((pi/365)*t+pi/2.5).^2)*(y(1)+y(4)+params.W)*(1-N/params.K);

    % Exposed prairie dogs, 'E'
    dydt(2) = threshold*( params.betae * y(8) * y(1) * (1 - exp(-params.a * N / (params.B - params.Br)))...
    + params.betal * y(9) * y(1) * (1 - exp(-params.a * N / (params.B - params.Br)))...
    + params.betam * y(1) * (y(5)/ (params.B - params.Br))...
    + params.betai * y(1) * (params.psi * y(3)/ (params.B - params.Br))...
    + params.betad * y(1) * ((y(14)/params.q_star) / (params.B - params.Br)))...
    - y(2) * (params.sigma + params.mu);

    % in case more hosts become exposed than exist (via Richgels et al) 
    if y(1)+dydt(1)<0
        dydt(1) = -y(1);
        dydt(2) = y(1) - y(2)*(params.sigma+params.mu);
    end
    
    % Infected prarie dogs: 
    dydt(3) = (params.sigma * (1 - params.p) * y(2) - params.alpha * y(3));
    
    % Resistant prairie dogs:
    dydt(4) = (params.p * params.sigma * y(2) - y(4) * (params.phi + params.mu));
    
    % Carcasses (M in richgels:)
    dydt(5) = params.alpha * y(3) - params.lambdam * y(5);
    
    % Soil
    dydt(6) = 0 ;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Flea model starts here
    
    % On host flea population
    
    F0 = y(10) + y(8) + y(9); 

    
    % Susceptible, questing fleas (F.sq) 
    dydt(7) = (params.delta * y(10) + params.rf * F0 * (N / (1 + N + F0))...
    - y(7) * (params.mufq + (1 - exp(-params.a * N / (params.B - params.Br))))...
     + params.xi * y(9));
    
    % EP1 infected questing fleas (F.eq)
    dydt(8) =  (y(11) * (params.delta + params.alpha) ...
    - y(8) * (params.mufq + (1 - exp(-params.a * N / (params.B - params.Br)))) ...
    - params.epsilon * y(8));

    % EP2 infected questing fleas (F.lq) 
    dydt(9) =  (y(12) * (params.delta + params.alpha) ... 
    - y(9) * (params.mufq + (1 - exp(-params.a * N / (params.B - params.Br)))) ...
    + params.epsilon * y(8)- params.xi * y(9));

    % Susceptible on-host fleas (F.sh)
    dydt(10) = (y(7) * (1 - exp(-params.a * N / (params.B - params.Br)))...
    - y(10) * (params.muf + params.delta + params.gamma * y(3) / N)...
    + params.thetal * y(12) * (y(1) + y(2) + y(4)) / N);
    
    % EP1 infected on-host fleas (F.eh)
    dydt(11) = (y(8)*(1-exp(-params.a*N/(params.B-params.Br))) ...
    - y(11) * (params.muf + params.delta + params.alpha + params.thetae*(y(1)+y(2)+y(4))/N) ... 
    + params.gamma * y(10) * y(3) / N + params.gamma * y(12) * y(3) / N);
    
    % EP2 infected on-host fleas (F.lh)
    dydt(12) = (y(9) * (1 - exp(-params.a * N / (params.B - params.Br)))...
    + params.thetae * y(11) * (y(1)+ y(2) + y(4)) / N...
    - y(12) * (params.muf + params.delta + params.alpha + params.gamma * y(3) / N ...
    + params.thetal * (y(1) + y(2) + y(4)) / N));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Amoeba model starts here
    
    % Susceptible Amoeba removed for simplified model.
    dydt(13) = 0;
    
    % Infected Amoeba 
    dydt(14) = y(5)*params.lambdam*params.q_star+params.ra*y(14)*(1-(y(14)/params.Ka))*G(t) + params.epsilont*G(t)*y(16) ...
    - params.epsilonc*(1-G(t))*y(14) -  params.mut*y(14)*G(t) - params.mut2*y(14)*J(t);
    
    % Susceptible Amoeba in cysts removed for simplified model. 
    dydt(15) = 0;
    
    % Infected Amoeba in cysts. 
    dydt(16) = - params.muc*y(16) + params.epsilonc*(1-G(t))*y(14) - params.epsilont*G(t)*y(16)*.4;

end
