function [invariant_codistr, matrix_rank] = observability_test(f, g, h, x, x0)
%OBSERVABILITY_TEST Compute the observability test for a nonlinear dynamics
%                   system
%   [invariant_codistr,  matrix_rank] = OBSERVABILITY_TEST(f, g, h, x, x0) 
%   returns: 1) invariant_codistr: the invariant codistribuition evaluated
%                                  using filtrations method
%                                  Omega_inv = < Omega0, Delta >
%                                  where Delta = [f, g] and Omega0 = dh
%
%            2) matrix_rank: the rank of the invariant codistribuition
%                            evaluated in x0
global zero

matrix_rank = 0;
delta = [f, g];
omega0 = jacobian(h, x);

filtrations = struct();
filtrations.omega0 = omega0;

i = 0;

while 1
    rank_prev = matrix_rank;
    
    delta_i = filtrations.(strcat('omega',num2str(i)));
    [delta_next, matrix_rank] = observability_step(delta_i, delta, x, x0, zero);
    i = i + 1;
    filtrations.(strcat('omega',num2str(i))) = delta_next;
    
    if (matrix_rank == 9)
        invariant_codistr = filtrations.(strcat('omega',num2str(i)));
        return
    elseif(matrix_rank == rank_prev)
        invariant_codistr = filtrations.(strcat('omega',num2str(i-1)));
        return
    end
end 
end

function [delta_next, matrix_rank] = observability_step(delta_i, delta, ...
                                                       x, x0, zero)

counter_i = 0;
counter_j = 0;

delta_next = delta_i;

s = size(delta_i,1);
fprintf('length of Delta_i: %d \n',s); 

for i = delta_i.'
    counter_i = counter_i + 1; 
    for j = delta
        counter_j = counter_j + 1; 
        fprintf('i: %d, j: %d \n',counter_i, counter_j); 
        l = L(j, i.', x);
        if(~isequal(l, zero.'))
            delta_next =[delta_next; l];
        end
    end
    counter_j = 0; 
end
matrix_rank = rank(eval(subs(delta_next, x, x0)));
fprintf('rank: %d\n', matrix_rank);
fprintf('*************\n');
end

function L = L(f, omega, x)
    L = omega * jacobian(f, x) + f.' * jacobian(omega.', x).';
end