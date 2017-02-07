% script_computePipeProperties

for i = 1:length(pipe)
    pipe(i).A  = pi * pipe(i).D^2/4; % area
    pipe(i).B  = pipe(i).c / (g * pipe(i).A); % impedance
    pipe(i).Dx = Dt * pipe(i).c; % reach distance
    pipe(i).L  = pipe(i).Dx * pipe(i).Nx; % pipe length
    pipe(i).Ho = zeros(pipe(i).Nx/2+1,1); % vector of pipe heads
    pipe(i).Qo = zeros(pipe(i).Nx/2+1,1); % vector of pipe flows
    pipe(i).Hi = zeros(pipe(i).Nx/2,1); % internal heads
    pipe(i).Qi = zeros(pipe(i).Nx/2,1); % internal flows
    pipe(i).R  = pipe(i).f * pipe(i).Dx / (2 * g * pipe(i).D * pipe(i).A^2); % resistance coefficient
end