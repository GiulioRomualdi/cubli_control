function Ry = roty(theta)
%ROTY Rotation matrix around y-axis
%    Ry = ROTY(theta) returns the rotation matrix, Ry, that rotates
%    a point around the y-axis for an angle theta (in radians)
%         |cos(theta)  0  sin(theta)|
%    Ry = |     0      1      0     |
%         |-sin(theta) 0  cos(theta)|
%    See also ROTX, ROTZ.

Ry = [cos(theta) 0 sin(theta)
      0 1 0
      -sin(theta) 0 cos(theta)];
end
