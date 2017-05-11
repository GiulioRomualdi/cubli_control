function Rz = rotz(theta)
%ROTZ Rotation matrix around z-axis
%    Rz = ROTZ(theta) returns the rotation matrix, Rz, that rotates
%    a point around the y-axis for an angle theta (in radians)
%         |cos(theta)  -sin(theta)  0|
%    Rz = |sin(theta)   cos(theta)  0|
%         |     0            0      1|
%    See also ROTX, ROTY.

Rz = [cos(theta) -sin(theta) 0
      sin(theta) cos(theta) 0
      0 0 1];
end
