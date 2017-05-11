function sys = linearization(f, g, h, x, u, x0, u0)
%LINEARIZATION find the linear approximation to a system at a given point
%   sys = LINEARIZATION(f, g, h, x, u, x0, u0)
%       dx = f(x) + g(x) * u = k(x, u)
%       y = h(x, u)
%       sys = ss(A, B, C, D);
%       where: 1) A = dk/dx in {x, u} = {x0, u0}
%              2) B = dk/du in {x, u} = {x0, u0}
%              3) C = dh/dx in {x, u} = {x0, u0}
%              4) D = dh/du in {x, u} = {x0, u0}

dstate = f + g * u;

A = eval(subs(jacobian(dstate, x),[x; u],[x0; u0]));
B = eval(subs(jacobian(dstate, u),[x; u],[x0; u0]));
C = eval(subs(jacobian(h, x),[x; u],[x0; u0]));
D = eval(subs(jacobian(h, u),[x; u],[x0; u0]));

sys = ss(A, B, C, D);

state_name = arrayfun(@(t){char(t)}, x);
input_name = arrayfun(@(t){char(t)}, u);
sys.StateName = state_name;
sys.InputName = input_name;
end