function [] = plots_extensive_simulations(simout, angles, durations, save)
if save
    if exist('export_fig') == 0
        error('Error. export_fig is needed to save figures http://it.mathworks.com/matlabcentral/fileexchange/23629-export-fig');
    end
end

stable_velocity = [];
stable_theta = [];
stable_duration = [];

unstable_velocity = [];
unstable_theta = [];
unstable_duration = [];

[combo1, combo2] = meshgrid(angles, durations);
combo = [combo1(:), combo2(:)];

for i = 1:size(combo,1)
    theta = combo(i,1);
    final_time = combo(i,2);
    fly_wheel = simout(i).get('fly_wheel');
    if simout(i).get('unstable') == 0
        stable_velocity = [stable_velocity; fly_wheel];
        stable_theta = [stable_theta; theta];
        stable_duration= [stable_duration; final_time];
    else
        unstable_velocity = [unstable_velocity; fly_wheel];
        unstable_theta = [unstable_theta; theta];
        unstable_duration= [unstable_duration; final_time];
    end
end

%% plots outcomes

hfig = figure();
axh = axes('Parent', hfig);
hold(axh, 'all');

p1 = scatter(stable_theta, stable_duration, ...
            'MarkerFaceColor','b' );

p2 = scatter(unstable_theta, unstable_duration, ...
             'MarkerFaceColor','r');
grid(axh, 'on');
legend(axh, [p1 p2], {'Success', 'Failure'})
plot_aesthetic('Outcomes', 'Angle (deg)', 'Duration (s)', '')
ylim([0.8 8.2])

if save
    export_fig(strcat('figures/','simulation_lqr','.pdf'), '-native', '-transparent');
end

%% Plots velocities
hfig = figure();
axh = axes('Parent', hfig);
hold(axh, 'all');

p1 = scatter3(stable_velocity(:,1), stable_velocity(:,2), stable_velocity(:,3), ...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','b' );

p2 = scatter3(unstable_velocity(:,1), unstable_velocity(:,2), unstable_velocity(:,3), ...
             'MarkerEdgeColor','k',...
             'MarkerFaceColor','r');
view(axh, -33, 22);
grid(axh, 'on');
legend(axh, [p1 p2], {'Success', 'Failure'})
plot_aesthetic('Flywheel velocities before switch', '$\dot{q}_x$ (rad/s)', ...
               '$\dot{q}_y (rad/s)$', '$\dot{q}_z (rad/s)$')

zlim([-500 15000])
ylim([-3.5 0.2]*10^4)

if save
    export_fig(strcat('figures/','simulation_lqr_velocities','.pdf'), '-native', '-transparent');
end