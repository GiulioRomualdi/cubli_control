global M m a r h gravity zero

%% parameters
M = 2.5; %frame mass
m = 0.204; %fly-wheel mass
a = 0.15;
r = 0.05;
h = 0.005;
gravity = 9.81;

parametrization = 'xyz';

%% symbolic variables
syms th1 th2 th3 qx qy qz
syms th1dot th2dot th3dot qxdot qydot qzdot
syms u1 u2 u3

assume(th1,'real');
assume(th2,'real');
assume(th3,'real');
assume(qx,'real');
assume(qy,'real');
assume(qz,'real');

assume(th1dot,'real');
assume(th2dot,'real');
assume(th3dot,'real');
assume(qxdot,'real');
assume(qydot,'real');
assume(qzdot,'real');

assume(u1,'real');
assume(u2,'real');
assume(u3,'real');

q = [th1 th2 th3 qx qy qz]';
dq = [th1dot th2dot th3dot qxdot qydot qzdot]';
u = [u1 u2 u3]';

zero = sym(zeros(9,1)); 

%% evaluate cubli dynamics
[f, g, y] = cubli_dynamics(q, dq, parametrization);
state = [q(1:3); dq];

%% evaluate equilibrium
if  strcmp(parametrization, 'xyz') == 1
    state0 = get_equilibrium(pi/2, 0, pi/4, f ,state);
else
    state0 = get_equilibrium(0, -pi/4, pi/2, f, state);
end