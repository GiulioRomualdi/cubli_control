function [] = plot_aesthetic(Title, Label_x, Label_y, Label_z, varargin)
% PLOT_AESTHETIC add Title, label and legends in a plot
%   PLOT_AESTHETIC(Title, Label_x, Label_y, Label_z, Legend_1, ..., Legend_n)
%   add title, labels and legends in a plot. LaTex syntax is allowed.

x_label = xlabel(Label_x);
y_label = ylabel(Label_y);
z_label = zlabel(Label_z);
set(x_label,'Interpreter','latex')
set(y_label,'Interpreter','latex')
set(z_label,'Interpreter','latex')
set(x_label,'FontSize', 16);
set(y_label,'FontSize', 16);
set(z_label,'FontSize', 16);

 if ~isempty(varargin)
    h = legend(varargin{:}, 'Location', 'best');
    set(h,'Interpreter','latex')
    set(h,'FontSize', 16);
 end
h = findobj(gcf,'type','line');
set(h,'linewidth',1.2)

tit = title(Title);
set(tit,'FontSize', 25);
set(tit,'Interpreter','latex');

set(gca,'FontSize', 16)
grid on;
end