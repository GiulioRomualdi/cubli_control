function equilibrium = get_equilibrium(th1, th2, th3, f, x)
%GET_EQUILIBRIUM evaluate an equilibrium point of cubli using
%levenberg-marquardt algorithm
%   equilibrium = GET_EQUILIBRIUM(th1, th2, th3, f, x)
%       where 1) th1, th2, th3 are the initial guess 
%             2) f is the symbolic function
%             3) x is the state of the system

% set algorithm
opts = optimoptions(@fsolve, 'Algorithm', 'levenberg-marquardt');

% convert symbolic function into matlab function
fun = matlabFunction(subs(f(4:9), x(4:9)', zeros(1,6)), 'vars', {x(1:3)'});

% find equilibrium point
th = fsolve(fun, [th1, th2, th3], opts);
equilibrium = [th, zeros(1,6)]';
end