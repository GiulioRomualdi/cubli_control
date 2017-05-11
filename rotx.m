function Rx = rotx(theta)
%ROTX Rotation matrix around x-axis
%    Rx = ROTX(theta) returns the rotation matrix, Rx, that rotates
%    a point around the x-axis for an angle theta (in radians)
%         |1      0            0     |
%    Rx = |0  cos(theta)  -sin(theta)|
%         |0  sin(theta)   cos(theta)|
%    See also ROTY, ROTZ.

Rx = [1 0 0
      0 cos(theta) -sin(theta)
      0 sin(theta) cos(theta)];
end