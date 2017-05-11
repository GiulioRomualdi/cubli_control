function [f, g, y] = cubli_dynamics(q, dq, parametrization)
%CUBLI_DYNAMICS evaluate the dynamics of the cubli
%   [f, g, y, f_alt, g_alt] = CUBLI_DYNAMICS(q, dq, parametrization)   
%   dx = f(x) + g(x) * [u1, u2, u3]'
%   y = y(x)
%   where x = [q, dq]' = [th1, th1, th3, th1dot, th1dot, th3dot, 
%                         qxdot, qydot, qzdot]'

global M m a r h gravity

if strcmp(parametrization, 'xyz') == 0 && strcmp(parametrization, 'zyx') == 0   
    error('Parametrization must be a ZYX or XYZ.')
end

th1 = q(1);
th2 = q(2);
th3 = q(3);

if strcmp(parametrization, 'xyz') == 1
    cJ_omega = [cos(th2)*cos(th3), sin(th3), 0
                -cos(th2)*sin(th3), cos(th3), 0
                sin(th2), 0, 1];      
             
else
    cJ_omega = [((roty(th2)*rotx(th3)).')*[0;0;1],...
                 (rotx(th3).')*[0;1;0],...
                 [1;0;0]];
end
    
cJ_omega_ext = [cJ_omega, zeros(3)];

e1 = diag([1 0 0]);
e2 = diag([0 1 0]);
e3 = diag([0 0 1]);
cJ_omega_ext_x = [cJ_omega, e1];
cJ_omega_ext_y = [cJ_omega, e2];
cJ_omega_ext_z = [cJ_omega, e3];

cGc = [a/2; a/2; a/2];
cGx = [0; a/2; a/2];
cGy = [a/2; 0; a/2];
cGz = [a/2; a/2; 0];

cIGc = eye(3) * 1/6 * M * (a^2);
cIGx = diag([m * r^2 / 2, 1/12 * m * (h^2 + 3 * r^2), 1/12 * m * (h^2 + 3 * r^2)]);
cIGy = diag([1/12 * m * (h^2 + 3 * r^2), m * r^2 / 2, 1/12 * m * (h^2 + 3 * r^2)]);
cIGz = diag([1/12 * m * (h^2 + 3 * r^2), 1/12 * m * (h^2 + 3 * r^2), m * r^2 / 2]);

B = M * (skew(cGc) * cJ_omega_ext).' * (skew(cGc) * cJ_omega_ext) + ...
    cJ_omega_ext.' * cIGc * cJ_omega_ext + ...
    m * (skew(cGx) * cJ_omega_ext).' * (skew(cGx) * cJ_omega_ext) + ...
    cJ_omega_ext_x.' * cIGx * cJ_omega_ext_x + ...
    m * (skew(cGy) * cJ_omega_ext).' * (skew(cGy) * cJ_omega_ext) + ...
    cJ_omega_ext_y.' * cIGy * cJ_omega_ext_y + ...
    m * (skew(cGz) * cJ_omega_ext).' * (skew(cGz) * cJ_omega_ext) + ...
    cJ_omega_ext_z.' * cIGz * cJ_omega_ext_z;

g0 = [0; 0; -gravity];
if strcmp(parametrization, 'xyz') == 1
    Rcs = (rotx(th1) * roty(th2) * rotz(th3)).';
else
    Rcs = (rotz(th1) * roty(th2) * rotx(th3)).';
end

cg = Rcs * g0;
U = - cg.' * (m * (cGx + cGy + cGz) + M * cGc);
G = jacobian(U, q);
G = G.';

C = sym(zeros(6, 6));
for i = 1:6
    for j = 1:6
       for k = 1:6
           C(i,j) = C(i,j) + christoffel(B, q, i, j, k) * dq(k);
       end
    end
end

f_full = simplify([dq; B \ (-G -C * dq)]);
g_full = simplify([zeros(6, 3); B \  [zeros(3); eye(3)]]);
y = [th1; th2; th3];

% remove qx qy and qz from state
f = [f_full(1:3); f_full(7:12)];
g = [g_full(1:3,:); g_full(7:12,:)];
end

function gamma_ijk = christoffel(B, q, i, j, k)
%CHRISTOFFEL evaluate the i,j,k christoffel symbol
%   gamma_ijk = CHRISTOFFEL(B, q, i, j, k)
%   - B: inertial matrix
%   - q: lagrangian variables

gamma_ijk = 1/2 *(jacobian(B(i,j), q(k)) + ...
    jacobian(B(i,k), q(j)) + ...
    -jacobian(B(j,k), q(i)));

end
