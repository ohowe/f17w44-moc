% script_computePipeProperties
g = 9.81;%gravitational acceleration
rho = 1000;
Nt = 10000;%number of pipe sections
H0SS = 25; % Upstream reservoir steady-state head
HLSS = 0; %downstream reservoir steady-state head (if 0 then valve is open)
HL = HLSS + zeros(Nt,1);%time series of downstream head
H0 = H0SS + 10 * [ones(500,1) ; zeros(Nt-500,1)];
H0 = H0SS + 10*ones(Nt,1);  % time series of upstream head
Dt = 0.001; % time step
t = [1:Nt]'*2*Dt;%summation of time steps
datH = zeros(Nt,2);%Build vector to store head values
datQ = zeros(Nt,2);%Build vector to store flow values

for a = 1:i
    for b = 1:j
        pipe(a,b).A  = pi * pipe(a,b).D^2/4; % area
        pipe(a,b).B  = pipe(a,b).c / (g * pipe(a,b).A); % impedance
        pipe(a,b).Dx = Dt * pipe(a,b).c; % reach distance
        pipe(a,b).L  = pipe(a,b).Dx * pipe(a,b).Nx; % pipe length
        pipe(a,b).Ho = zeros(pipe(a,b).Nx/2+1,1); % vector of pipe heads
        pipe(a,b).Qo = zeros(pipe(a,b).Nx/2+1,1); % vector of pipe flows
        pipe(a,b).Hi = zeros(pipe(a,b).Nx/2,1); % internal heads
        pipe(a,b).Qi = zeros(pipe(a,b).Nx/2,1); % internal flows
        pipe(a,b).R  = pipe(a,b).f * pipe(a,b).Dx / (2 * g * pipe(a,b).D * pipe(a,b).A^2); % resistance coefficient
    end
end