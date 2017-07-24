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
datH = zeros(Nt,1);%Build vector to store head values
datQ = zeros(Nt,1);%Build vector to store flow values

script_inputPipeProperties %Use to generate house network 
script_computePipeProperties %General code to build other values for the pipes (does not need to eb altered)
script_computeAndInitialiseSteadyStateP %Generate starting Head and flow values (NOTE: CONTAINS HARD CODING SPECIFIC TO NETWORK)


for i = 1:Nt
% Store fixed situation here (e.g. closure of valve, Q=0)
% Storing Measurements
    datH(i,1) = pipe(2,1).Ho(10);%Head at point 1, for storing values
    datQ(i,1) = pipe(1).Qo(1);%Flow at point 1, for storing values
% Computing the following head values WITHIN each pipe (no pipe network interactions required)
    for k = 1:8
    for j = 1:2
%        disp(['Pipe = ' int2str(j)])
% Computing internal node values for "inner" nodes
        [pipe(k,j).Hi pipe(k,j).Qi]  = computeMOCInternalNodes(pipe(k,j).B,pipe(k,j).R,pipe(k,j).Ho,pipe(k,j).Qo);
% Computing internal node values for "outer" nodes
        [pipe(k,j).HoI pipe(k,j).QoI] = computeMOCInternalNodes(pipe(k,j).B,pipe(k,j).R,pipe(k,j).Hi,pipe(k,j).Qi);
    end   
    end
% Computing upstream boundary condition
    pipe(1,1).HoU = H0(i);%steady state of reservoir (upstream)head as identified above
    Cm = pipe(1,1).Hi(1) - pipe(1,1).Qi(1)*(pipe(1,1).B-pipe(1,1).R*abs(pipe(1,1).Qi(1)));%Calc corresponding Cm
    pipe(1,1).QoU = (H0(i) - Cm) / pipe(1,1).B; %Calc Upstream flow
    %for j = 1:length(pipe)-2 %for each junction (only one junction in this case)
    % downstream of pipe i
%~~~SERIES 1 CONNECTION----------------------------------
    k=1; j=1;           %Indicates which pipe
        Ha = pipe(k,j).Hi(pipe(k,j).Nx/2); Qa = pipe(k,j).Qi(pipe(k,j).Nx/2);
        Ba = pipe(k,j).B;                Ra = pipe(k,j).R; %Upstream B and R
        Hb = pipe(k,j+1).Hi(1);          Qb = pipe(k,j+1).Qi(1); %Downstream pipe 1 properties at junction
        Bb = pipe(k,j+1).B;              Rb = pipe(k,j+1).R;
        
    [Hn Qn] = computeMOCNodesS(Ha,Qa,Ba,Ra,Hb,Qb,Bb,Rb);
        pipe(k,j).HoD   = Hn; 
        pipe(k,j).QoD   = Qn;
        pipe(k,j+1).HoU = Hn;
        pipe(k,j+1).QoU = Qn;
%--------------------------------------------------------
%---PARALLEL A CONNECTION -------------------------------     
    k = 1; j = 1;
        Hu = pipe(k,j+1).Hi(pipe(k,j+1).Nx/2); Qu = pipe(k,j+1).Qi(pipe(k,j+1).Nx/2); %Upstream head and flow
        Bu = pipe(k,j+1).B;                Ru = pipe(k,j+1).R; %Upstream B and R
        Hd1 = pipe(k+1,j).Hi(1);          Qd1 = pipe(k+1,j).Qi(1); %Downstream pipe 1 properties at junction
        Bd1 = pipe(k+1,j).B;              Rd1 = pipe(k+1,j).R;
        Hd2 = pipe(k+2,j).Hi(1);          Qd2 = pipe(k+2,j).Qi(1); %Downstream pipe 2 properties at junction (error here; I dont know what the problem is)
        Bd2 = pipe(k+2,j).B;              Rd2 = pipe(k+2,j).R;
        
        [Hn Qn] = computeMOCNodesP1(Hu,Qu,Bu,Ru,Hd1,Qd1,Bd1,Rd1,Hd2,Qd2,Bd2,Rd2); %computes head and flow at junction 
        pipe(k,j+1).HoD   = Hn; 
        pipe(k,j+1).QoD   = Qn;
        pipe(k+1,j).HoU = Hn;
        pipe(k+1,j).QoU = Qn;
        pipe(k+2,j).HoU = Hn;
        pipe(k+2,j).QoU = Qn;
%---SERIES 2 CONNECTION ---------------------------------
    k=2; j=1;
        Ha = pipe(k,j).Hi(pipe(k,j).Nx/2); Qa = pipe(k,j).Qi(pipe(k,j).Nx/2);
        Ba = pipe(k,j).B;                Ra = pipe(k,j).R; %Upstream B and R
        Hb = pipe(k,j+1).Hi(1);          Qb = pipe(k,j+1).Qi(1); %Downstream pipe 1 properties at junction
        Bb = pipe(k,j+1).B;              Rb = pipe(k,j+1).R;
        
    [Hn Qn] = computeMOCNodesS(Ha,Qa,Ba,Ra,Hb,Qb,Bb,Rb);
        pipe(k,j).HoD   = Hn; 
        pipe(k,j).QoD   = Qn;
        pipe(k,j+1).HoU = Hn;
        pipe(k,j+1).QoU = Qn;
%---SERIES 3 CONNECTION --------------------------------
    k=3; j=1;
        Ha = pipe(k,j).Hi(pipe(k,j).Nx/2); Qa = pipe(k,j).Qi(pipe(k,j).Nx/2);
        Ba = pipe(k,j).B;                Ra = pipe(k,j).R; %Upstream B and R
        Hb = pipe(k,j+1).Hi(1);          Qb = pipe(k,j+1).Qi(1); %Downstream pipe 1 properties at junction
        Bb = pipe(k,j+1).B;              Rb = pipe(k,j+1).R;
        
    [Hn Qn] = computeMOCNodesS(Ha,Qa,Ba,Ra,Hb,Qb,Bb,Rb);
        pipe(k,j).HoD   = Hn; 
        pipe(k,j).QoD   = Qn;
        pipe(k,j+1).HoU = Hn;
        pipe(k,j+1).QoU = Qn;
%-------------------------------------------------------
%---PARALLEL B CONNECTION ------------------------------
   k = 2; j = 1;
        Hu = pipe(k,j+1).Hi(pipe(k,j+1).Nx/2); Qu = pipe(k,j+1).Qi(pipe(k,j+1).Nx/2); %Upstream head and flow
        Bu = pipe(k,j+1).B;                Ru = pipe(k,j+1).R; %Upstream B and R
        Hd1 = pipe(k+2,j).Hi(1);          Qd1 = pipe(k+2,j).Qi(1); %Downstream pipe 1 properties at junction
        Bd1 = pipe(k+2,j).B;              Rd1 = pipe(k+2,j).R;
        Hd2 = pipe(k+4,j).Hi(1);          Qd2 = pipe(k+4,j).Qi(1); %Downstream pipe 2 properties at junction (error here; I dont know what the problem is)
        Bd2 = pipe(k+4,j).B;              Rd2 = pipe(k+4,j).R;
        
        [Hn Qn] = computeMOCNodesP1(Hu,Qu,Bu,Ru,Hd1,Qd1,Bd1,Rd1,Hd2,Qd2,Bd2,Rd2); %computes head and flow at junction 
        pipe(k,j+1).HoD   = Hn; 
        pipe(k,j+1).QoD   = Qn;
        pipe(k+2,j).HoU = Hn;
        pipe(k+2,j).QoU = Qn;
        pipe(k+4,j).HoU = Hn;
        pipe(k+4,j).QoU = Qn;
%---SERIES 4 CONNECTION -----------------------------
    k=4; j=1;
        Ha = pipe(k,j).Hi(pipe(k,j).Nx/2); Qa = pipe(k,j).Qi(pipe(k,j).Nx/2);
        Ba = pipe(k,j).B;                Ra = pipe(k,j).R; %Upstream B and R
        Hb = pipe(k,j+1).Hi(1);          Qb = pipe(k,j+1).Qi(1); %Downstream pipe 1 properties at junction
        Bb = pipe(k,j+1).B;              Rb = pipe(k,j+1).R;
        
    [Hn Qn] = computeMOCNodesS(Ha,Qa,Ba,Ra,Hb,Qb,Bb,Rb);
        pipe(k,j).HoD   = Hn; 
        pipe(k,j).QoD   = Qn;
        pipe(k,j+1).HoU = Hn;
        pipe(k,j+1).QoU = Qn;
%---AT FIXTURE 4
    k=4; j=2;
    pipe(k,j).QoD = 0;
    Cp = pipe(k,j).Hi(pipe(k,j).Nx/2) + pipe(k,j).Qi(pipe(k,j).Nx/2)*(pipe(k,j).B-pipe(k,j).R*abs(pipe(k,j).Qi(pipe(k,j).Nx/2)));
    pipe(k,j).HoD =  - Cp - pipe(k,j).QoD*pipe(k,j).B;
%---SERIES 6 CONNECTION --------------------------------
    k=6; j=1;
        Ha = pipe(k,j).Hi(pipe(k,j).Nx/2); Qa = pipe(k,j).Qi(pipe(k,j).Nx/2);
        Ba = pipe(k,j).B;                Ra = pipe(k,j).R; %Upstream B and R
        Hb = pipe(k,j+1).Hi(1);          Qb = pipe(k,j+1).Qi(1); %Downstream pipe 1 properties at junction
        Bb = pipe(k,j+1).B;              Rb = pipe(k,j+1).R;
        
    [Hn Qn] = computeMOCNodesS(Ha,Qa,Ba,Ra,Hb,Qb,Bb,Rb);
        pipe(k,j).HoD   = Hn; 
        pipe(k,j).QoD   = Qn;
        pipe(k,j+1).HoU = Hn;
        pipe(k,j+1).QoU = Qn;
%-------------------------------------------------------
%---PARALLEL C CONNECTION ------------------------------
   k = 3; j = 1;
        Hu = pipe(k,j+1).Hi(pipe(k,j+1).Nx/2); Qu = pipe(k,j+1).Qi(pipe(k,j+1).Nx/2); %Upstream head and flow
        Bu = pipe(k,j+1).B;                Ru = pipe(k,j+1).R; %Upstream B and R
        Hd1 = pipe(k+2,j).Hi(1);          Qd1 = pipe(k+2,j).Qi(1); %Downstream pipe 1 properties at junction
        Bd1 = pipe(k+2,j).B;              Rd1 = pipe(k+2,j).R;
        Hd2 = pipe(k+4,j).Hi(1);          Qd2 = pipe(k+4,j).Qi(1); %Downstream pipe 2 properties at junction (error here; I dont know what the problem is)
        Bd2 = pipe(k+4,j).B;              Rd2 = pipe(k+4,j).R;
        
        [Hn Qn] = computeMOCNodesP1(Hu,Qu,Bu,Ru,Hd1,Qd1,Bd1,Rd1,Hd2,Qd2,Bd2,Rd2); %computes head and flow at junction 
        pipe(k,j+1).HoD   = Hn; 
        pipe(k,j+1).QoD   = Qn;
        pipe(k+2,j).HoU = Hn;
        pipe(k+2,j).QoU = Qn;
        pipe(k+4,j).HoU = Hn;
        pipe(k+4,j).QoU = Qn;
%---SERIES 5 CONNECTION -----------------------------
    k=5; j=1;
        Ha = pipe(k,j).Hi(pipe(k,j).Nx/2); Qa = pipe(k,j).Qi(pipe(k,j).Nx/2);
        Ba = pipe(k,j).B;                Ra = pipe(k,j).R; %Upstream B and R
        Hb = pipe(k,j+1).Hi(1);          Qb = pipe(k,j+1).Qi(1); %Downstream pipe 1 properties at junction
        Bb = pipe(k,j+1).B;              Rb = pipe(k,j+1).R;
        
    [Hn Qn] = computeMOCNodesS(Ha,Qa,Ba,Ra,Hb,Qb,Bb,Rb);
        pipe(k,j).HoD   = Hn; 
        pipe(k,j).QoD   = Qn;
        pipe(k,j+1).HoU = Hn;
        pipe(k,j+1).QoU = Qn;
%---AT FIXTURE 5
    k=5; j=2;
    pipe(k,j).QoD = 0;
    Cp = pipe(k,j).Hi(pipe(k,j).Nx/2) + pipe(k,j).Qi(pipe(k,j).Nx/2)*(pipe(k,j).B-pipe(k,j).R*abs(pipe(k,j).Qi(pipe(k,j).Nx/2)));
    pipe(k,j).HoD =  - Cp - pipe(k,j).QoD*pipe(k,j).B;
 
%---SERIES 7 CONNECTION --------------------------------
    k=7; j=1;
        Ha = pipe(k,j).Hi(pipe(k,j).Nx/2); Qa = pipe(k,j).Qi(pipe(k,j).Nx/2);
        Ba = pipe(k,j).B;                Ra = pipe(k,j).R; %Upstream B and R
        Hb = pipe(k,j+1).Hi(1);          Qb = pipe(k,j+1).Qi(1); %Downstream pipe 1 properties at junction
        Bb = pipe(k,j+1).B;              Rb = pipe(k,j+1).R;
        
    [Hn Qn] = computeMOCNodesS(Ha,Qa,Ba,Ra,Hb,Qb,Bb,Rb);
        pipe(k,j).HoD   = Hn; 
        pipe(k,j).QoD   = Qn;
        pipe(k,j+1).HoU = Hn;
        pipe(k,j+1).QoU = Qn;      
%------------------------------------------------------------
%---PARALLEL D CONNECTION -----------------------------------
    k = 6; j = 1;
        Hu1 = pipe(k,j+1).Hi(pipe(k,j+1).Nx/2); Qu1 = pipe(k,j+1).Qi(pipe(k,j+1).Nx/2); %Upstream head and flow
        Bu1 = pipe(k,j+1).B;                Ru1 = pipe(k,j+1).R; %Upstream B and R
        Hu2 = pipe(k+1,j+1).Hi(pipe(k+1,j+1).Nx/2); Qu2 = pipe(k+1,j+1).Qi(pipe(k+1,j+1).Nx/2); %Upstream head and flow
        Bu2 = pipe(k+1,j+1).B;                Ru2 = pipe(k+1,j+1).R;
        Hd = pipe(k+2,j).Hi(1);          Qd = pipe(k+2,j).Qi(1); %Downstream pipe 2 properties at junction (error here; I dont know what the problem is)
        Bd = pipe(k+2,j).B;              Rd = pipe(k+2,j).R;
        
        [Hn Qn] = computeMOCNodesP2(Hu1,Qu1,Bu1,Ru1,Hu2,Qu2,Bu2,Ru2,Hd,Qd,Bd,Rd); %computes head and flow at junction 
        pipe(k,j+1).HoD   = Hn; 
        pipe(k,j+1).QoD   = Qn;
        pipe(k+1,j+1).HoD = Hn;
        pipe(k+1,j+1).QoD = Qn;
        pipe(k+2,j).HoU = Hn;
        pipe(k+2,j).QoU = Qn;
%---SERIES 8 CONNECTION --------------------------------
    k=8; j=1;
        Ha = pipe(k,j).Hi(pipe(k,j).Nx/2); Qa = pipe(k,j).Qi(pipe(k,j).Nx/2);
        Ba = pipe(k,j).B;                Ra = pipe(k,j).R; %Upstream B and R
        Hb = pipe(k,j+1).Hi(1);          Qb = pipe(k,j+1).Qi(1); %Downstream pipe 1 properties at junction
        Bb = pipe(k,j+1).B;              Rb = pipe(k,j+1).R;
        
    [Hn Qn] = computeMOCNodesS(Ha,Qa,Ba,Ra,Hb,Qb,Bb,Rb);
        pipe(k,j).HoD   = Hn; 
        pipe(k,j).QoD   = Qn;
        pipe(k,j+1).HoU = Hn;
        pipe(k,j+1).QoU = Qn;
%-----------------------------------------------------------------        
      % Downstream BC of pipe 8 (where fixture occurs)
    k=8; j=2;
    pipe(k,j).HoD = HL(i);
    Cp = pipe(k,j).Hi(pipe(k,j).Nx/2) + pipe(k,j).Qi(pipe(k,j).Nx/2)*(pipe(k,j).B-pipe(k,j).R*abs(pipe(k,j).Qi(pipe(k,j).Nx/2)));
    pipe(k,j).QoD =  - (HL(i) - Cp) / pipe(k,j).B;
%---SUMMING UP --------------------------------------------
    for k = 1:8
        for j = 1:2
            pipe(k,j).Ho   = [pipe(k,j).HoU ; pipe(k,j).HoI ; pipe(k,j).HoD];
            pipe(k,j).Qo   = [pipe(k,j).QoU ; pipe(k,j).QoI ; pipe(k,j).QoD];
    end
            
end
    
end
%  plot(t,datH(1:Nt,1))