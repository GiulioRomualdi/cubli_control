function [invariant_distr, matrix_rank] = accessibility_test(f, g, x, x0)
%ACCESSIBILITY_TEST Compute the accessibility test for a nonlinear dynamics
%                   system
%   [invariant_distr, matrix_rank] = ACCESSIBILITY_TEST(f, g, x, x0) 
%   returns: 1) invariant_distr: the invariant distribuition evaluated
%                                using filtrations method
%                                Delta_inv = < Delta, Delta0 >
%                                where Delta = [f, g] and Delta0 = g
%
%            2) matrix_rank: the rank of the invariant distribuition
%                            evaluated in x0

global zero

matrix_rank = 0;
delta = [f, g];
delta0 = g;

filtrations = struct();
filtrations.delta0 = delta0;

i = 0;

while 1
    rank_prev = matrix_rank;
    
    delta_i = filtrations.(strcat('delta',num2str(i)));
    [delta_next, matrix_rank] = accessibility_step(delta_i, delta, x, x0, zero);
    i = i + 1;
    filtrations.(strcat('delta',num2str(i))) = delta_next;
    
    if (matrix_rank == 9)
        invariant_distr = filtrations.(strcat('delta',num2str(i)));
        return
    elseif(matrix_rank == rank_prev)
        invariant_distr = filtrations.(strcat('delta',num2str(i-1)));
        return
    end
end
end

function [delta_next, matrix_rank] = accessibility_step(delta_i, delta, ...
                                                       x, x0, zero)
%ACCESIBILITY_STEP Summary of this function goes here
%   Detailed explanation goes here

counter_i = 0;
counter_j = 0;

delta_next = delta_i;

s = size(delta_i);
fprintf('length of Delta_i: %d \n',s(2)); 

for i = delta_i
    counter_i = counter_i + 1; 
    for j = delta
        counter_j = counter_j + 1; 
        fprintf('i: %d, j: %d \n',counter_i, counter_j); 
        lie = lie_bracket(i, j, x);
        if(~isequal(lie, zero))
            delta_next =[delta_next, lie];
        end
    end
    counter_j = 0; 
end
matrix_rank = rank(eval(subs(delta_next, x, x0)));
fprintf('rank: %d\n', matrix_rank);
fprintf('*************\n');
end

function lie = lie_bracket(f, g, x)
%LIE_BRACKET compute lie bracket
%   lie = LIE_BRACKET(f, g, x)
%   where f and g are tho vector fields
%   lie = (dg/dx) * f - (df/dx) * g 

lie = jacobian(g, x) * f - jacobian(f, x) * g; 
end
