function M = skew(vector)
%SKEW Forms the 3x3 skew-symmetric matrix from a vector
%   M = SKEW(vector) returns the skew-symmetric matrix
%   vector = [x y z]'    
%       | 0  -z   y|
%   M = | z   0  -x|
%       |-y   x   0|

x = vector(1);
y = vector(2);
z = vector(3);

M = [0 -z y
     z 0 -x
     -y x 0];
end

