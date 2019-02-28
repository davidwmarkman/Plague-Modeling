function [tstore,xstore] = tau_leaping(t_f, x0, stoich_mat, propensity)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [tstore,xstore] = tau_leaping(t_f, x0, stoich_mat, propensity)
% Implementation of the tau leaping algorithm. 
% Assumes a fixed tau=0.1. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = x0;
t = 0;
tstore = t;
xstore = x;
tstep = .1;
while (t < t_f)
% get the propensity

a = propensity(t,x);
% determine the number of times each
% reaction has fired in the time step.
% change the values of "a" that are going to Nan because you have a 
% 0/0 in the propensity. 
a(isnan(a)) = 0;
n_rxn = poissrnd(a*tstep); 

% Update time
t = t + tstep;
% Update state
x = x + sum(n_rxn.*stoich_mat,2);
x(x<0) = 0;
tstore = [tstore t];
xstore = [xstore x];
if sum(isnan(x))>0
    a;
    n_rxn;
    display('It blew up');
    xstore(:,end-5:end);
%        pause;
end

end
end_state = x;
end