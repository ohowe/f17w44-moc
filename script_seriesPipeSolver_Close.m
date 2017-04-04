% script_seriesPipeSolver
function [datH]=script_seriesPipeSolver_Close(HLSS)
% Input parameters
g = 9.81;%gravitational acceleration
rho = 1000;
Nt = 10000;%number of pipe sections
H0SS = 25; % Upstream reservoir steady-state head
HLSS = 0; %downstream reservoir steady-state head
HL = HLSS + zeros(Nt,1);%time series of downstream head
%H0 = H0SS + 10 * [ones(500,1) ; zeros(Nt-500,1)];
H0 = H0SS + 10*ones(Nt,1);  % time series of upstream head
Dt = 0.001; % time step
t = [1:Nt]'*2*Dt;%summation of time steps
datH = zeros(Nt,2);
datQ = zeros(Nt,2);

script_inputPipeProperties
script_computePipeProperties
script_computeAndInitialiseSteadyState


for i = 1:Nt
%    disp(['Time = ' int2str(i)])
pipe(5).QoD=0;
% Storing Measurements
    datH(i,1) = pipe(1).Ho(15);%Head at point 1
    datH(i,2) = pipe(3).Ho(20);%Head at point 2
    datQ(i,1) = pipe(1).Qo(15);%Flow at point 1
    datQ(i,2) = pipe(3).Qo(20);%Flow at point 2
    for j = 1:length(pipe)
%        disp(['Pipe = ' int2str(j)])
% Computing internal node values for "inner" nodes
        [pipe(j).Hi pipe(j).Qi] = computeMOCInternalNodes(pipe(j).B,pipe(j).R,pipe(j).Ho,pipe(j).Qo);
% Computing internal node values for "outer" nodes
        [pipe(j).HoI pipe(j).QoI] = computeMOCInternalNodes(pipe(j).B,pipe(j).R,pipe(j).Hi,pipe(j).Qi);
    end
% Computing upstream boundary condition
    pipe(1).HoU = H0(i);
    Cm = pipe(1).Hi(1) - pipe(1).Qi(1)*(pipe(1).B-pipe(1).R*abs(pipe(1).Qi(1)));
    pipe(1).QoU = (H0(i) - Cm) / pipe(1).B;
    for j = 1:length(pipe)-1
% downstream of pipe i
        Ha = pipe(j).Hi(pipe(j).Nx/2); Qa = pipe(j).Qi(pipe(j).Nx/2);
        Ba = pipe(j).B;                Ra = pipe(j).R;
        Hb = pipe(j+1).Hi(1);          Qb = pipe(j+1).Qi(1);
        Bb = pipe(j+1).B;              Rb = pipe(j+1).R;
        [Hn Qn] = computeMOCNodes(Ha,Qa,Ba,Ra,Hb,Qb,Bb,Rb);
% load into pipes
        pipe(j).HoD   = Hn;
        pipe(j).QoD   = Qn;
        pipe(j+1).HoU = Hn;
        pipe(j+1).QoU = Qn;
    end
% Downstream BC of last pipe
    j = length(pipe);
    %pipe(j).HoD = HL(i);
    Cp = pipe(j).Hi(pipe(j).Nx/2) + pipe(j).Qi(pipe(j).Nx/2)*(pipe(j).B-pipe(j).R*abs(pipe(j).Qi(pipe(j).Nx/2)));
    pipe(j).HoD = Cp - pipe(j).B.*pipe(j).QoD;
    for j = 1:length(pipe)
        pipe(j).Ho   = [pipe(j).HoU ; pipe(j).HoI ; pipe(j).HoD];
        pipe(j).Qo   = [pipe(j).QoU ; pipe(j).QoI ; pipe(j).QoD];
    end
    
  
end

 % plot(t,datH(1:Nt,2))