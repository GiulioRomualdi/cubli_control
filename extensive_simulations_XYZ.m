% load model
model = 'cubli_XYZ_extensive_simulations';
load_system(model);

% start parallel pool
parpool;

% set angles and trajectory duration
angles_value = -180:1:180;
angles_value  = angles_value(find(angles_value~=0));
durations = 1:1:8;
[combo1, combo2] = meshgrid(angles_value, durations);
combo = [combo1(:), combo2(:)];

simout(size(combo,1))  = Simulink.SimulationOutput;

spmd
    % Setup tempdir and cd into it
    currDir = pwd;
    addpath(currDir);
    tmpDir = tempname;
    mkdir(tmpDir);
    cd(tmpDir);
    % Load the model on the worker
    load_system(model);
    evalin('base', 'load(''matlab.mat'')');
end

parfor i=1:size(combo,1)
    % set angle and trajectory time for all simulation   
    theta = combo(i,1);
    final_time = combo(i,2);
   
    fprintf('sim n°: %d with i; %f, j:%f\n', i, theta, final_time);
    set_param([model '/Cubli'],'theta', num2str(theta), 'final_time', num2str(final_time))
    simout(i) = sim(model,'ReturnWorkspaceOutputs','on');
    
end

spmd
    cd(currDir);
    rmdir(tmpDir,'s');
    rmpath(currDir);
    close_system(model, 0);
end

close_system(model, 0);
delete(gcp('nocreate'));