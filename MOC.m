% script_seriesPipeSolver

% Input parameters, basic upstream and downstream conditions
%See MOC description froom Water III for further understanding
g = 9.81;%gravitational acceleration
rho = 1000;
Nt = 10000;%number of pipe sections
H0SS = 25; % Upstream reservoir steady-state head
HLSS = 0; %downstream reservoir steady-state head (if 0 then valve is open)
HL = HLSS + zeros(Nt,1);%time series of downstream head
%H0 = H0SS + 10 * [ones(500,1) ; zeros(Nt-500,1)];
H0 = H0SS + 10*ones(Nt,1);  % time series of upstream head
Dt = 0.001; % time step
t = [1:Nt]'*2*Dt;%summation of time steps
datH = zeros(Nt,2);%Build vector to store head values
datQ = zeros(Nt,2);%Build vector to store flow values

script_inputPipeProperties %Use to generate house network 
script_computePipeProperties %General code to build other values for the pipes (does not need to eb altered)
script_computeAndInitialiseSteadyStateP %Generate starting Head and flow values (NOTE: CONTAINS HARD CODING SPECIFIC TO NETWORK)


for i = 1:Nt
% Store fixed situation here (e.g. closure of valve, Q=0)
% Storing Measurements
    datH(i,1) = pipe(1).Ho(150);%Head at point 1, for storing values
    datQ(i,1) = pipe(1).Qo(1);%Flow at point 1, for storing values
% Computing the following head values WITHIN each pipe (no pipe network interactions required)  
    for j = 1:length(pipe)
%        disp(['Pipe = ' int2str(j)])
% Computing internal node values for "inner" nodes
        [pipe(j).Hi pipe(j).Qi]  = computeMOCInternalNodes(pipe(j).B,pipe(j).R,pipe(j).Ho,pipe(j).Qo);
% Computing internal node values for "outer" nodes
        [pipe(j).HoI pipe(j).QoI] = computeMOCInternalNodes(pipe(j).B,pipe(j).R,pipe(j).Hi,pipe(j).Qi);
    end
% Computing upstream boundary condition
    pipe(1).HoU = H0(i);%steady state of reservoir (upstream)head as identified above
    Cm = pipe(1).Hi(1) - pipe(1).Qi(1)*(pipe(1).B-pipe(1).R*abs(pipe(1).Qi(1)));%Calc corresponding Cm
    pipe(1).QoU = (H0(i) - Cm) / pipe(1).B; %Calc Upstream flow
    for j = 1:length(pipe)-2 %for each junction (only one junction in this case)
    % downstream of pipe i
        Hu = pipe(j).Hi(pipe(j).Nx/2); Qu = pipe(j).Qi(pipe(j).Nx/2); %Upstream head and flow
        Bu = pipe(j).B;                Ru = pipe(j).R; %Upstream B and R
        Hd1 = pipe(j+1).Hi(1);          Qd1 = pipe(j+1).Qi(1); %Downstream pipe 1 properties at junction
        Bd1 = pipe(j+1).B;              Rd1 = pipe(j+1).R;
        Hd2 = pipe(j+2).Hi(1);          Qd2 = pipe(j+2).Qi(1); %Downstream pipe 2 properties at junction (error here; I dont know what the problem is)
        Bd2 = pipe(j+2).B;              Rd2 = pipe(j+2).R;
        
        [Hn Qn] = computeMOCNodesP(Hu,Qu,Bu,Ru,Hd1,Qd1,Bd1,Rd1,Hd2,Qd2,Bd2,Rd2); %computes head and flow at junction 
% load into pipes; allocating the junction values to be placed into the
% corresponding pipes
        pipe(j).HoD   = Hn; 
        pipe(j).QoD   = Qn;
        pipe(j+1).HoU = Hn;
        pipe(j+1).QoU = Qn;
        pipe(j+2).HoU = Hn;
        pipe(j+2).QoU = Qn;
    end
% Downstream BC of pipe 2 (where fixture occurs)
    pipe(2).HoD = HL(i);
    Cp = pipe(2).Hi(pipe(2).Nx/2) + pipe(2).Qi(pipe(2).Nx/2)*(pipe(2).B-pipe(2).R*abs(pipe(2).Qi(pipe(2).Nx/2)));
    pipe(2).QoD =  - (HL(i) - Cp) / pipe(2).B;
    for j = 1:length(pipe)
        pipe(j).Ho   = [pipe(j).HoU ; pipe(j).HoI ; pipe(j).HoD];
        pipe(j).Qo   = [pipe(j).QoU ; pipe(j).QoI ; pipe(j).QoD];
    end
    
  
end

  %plot(t,datQ(1:Nt,2))