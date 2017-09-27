%ss=[1 0 0 0 0 0 0 0];cs=[0 0 0 0 0 0 0 0];
% script_seriesPipeSolver
function [dtH] = script_MOC2(ss,cs)
% Input parameters, basic upstream and downstream conditions
%See MOC description froom Water III for further understanding
g = 9.81;%gravitational acceleration
rho = 1000;
Nt = 10000;%number of pipe sections
H0SS = 25; % Upstream reservoir steady-state head
HLSS = 10; %downstream reservoir steady-state head (if 0 then valve is open)
HL = HLSS * ones(Nt,1);%time series of downstream head
%H0 = H0SS + 10 * [ones(500,1) ; zeros(Nt-500,1)];
H0 = H0SS * ones(Nt,1);  % time series of upstream head
Dt = 0.0001; % time it takes a wave to travel a reach
t = [1:Nt]'*2*Dt;%summation of time steps
datH = zeros(Nt,3);%Build vector to store head values
datQ = zeros(Nt,1);%Build vector to store flow values

script_inputPipeProperties2 %Use to generate house network 
script_computePipeProperties %General code to build other values for the pipes (does not need to eb altered)
script_computeAndInitialiseSteadyStateP2 %Generate starting Head and flow values (NOTE: CONTAINS HARD CODING SPECIFIC TO NETWORK)
        
spd=1;
noise = zeros(Nt,1);
%noise = (2*rand(Nt,1)-1);
sysnoise=zeros(Nt,1);
%sysnoise=(2*rand(Nt,1)-1)*2;

for i = 1:Nt
    %i
% Store fixed situation here (e.g. closure of valve, Q=0)
% Storing Measurements
    datH(i,1) = pipe(1,2).Ho(20);%Head at point 1, for storing values
    datQ(i,1) = pipe(1,1).Qo(1);%Flow at point 1, for storing values

% Computing INTERNAL VALUES
    for k = 1:15
    for j = 1:2

% Computing internal node values for "inner" nodes
        [pipe(k,j).Hi pipe(k,j).Qi]  = computeMOCInternalNodes(pipe(k,j).B,pipe(k,j).R,pipe(k,j).Ho,pipe(k,j).Qo);
% Computing internal node values for "outer" nodes
        [pipe(k,j).HoI pipe(k,j).QoI] = computeMOCInternalNodes(pipe(k,j).B,pipe(k,j).R,pipe(k,j).Hi,pipe(k,j).Qi);
    end   
    end
    
% Compute JUNCTION NODES
% The section below is hardcoded based on the specific network
% UPSTREAM (SET HEAD)
    pipe(1,1).HoU = H0(i) + sysnoise(i);%steady state of reservoir (upstream)head as identified above
    Cm = pipe(1,1).Hi(1) - pipe(1,1).Qi(1)*(pipe(1,1).B - pipe(1,1).R*abs(pipe(1,1).Qi(1)));%Calc corresponding Cm
    pipe(1,1).QoU = (H0(i) - Cm) / pipe(1,1).B; %Calc Upstream flow
%~~~SERIES 1 CONNECTION----------------------------------

    for k=1:15
        j=1;
        Ha = pipe(k,j).Hi(pipe(k,j).Nx/2); Qa = pipe(k,j).Qi(pipe(k,j).Nx/2);
        Ba = pipe(k,j).B;                Ra = pipe(k,j).R; %Upstream B and R
        Hb = pipe(k,j+1).Hi(1);          Qb = pipe(k,j+1).Qi(1); %Downstream pipe 1 properties at junction
        Bb = pipe(k,j+1).B;              Rb = pipe(k,j+1).R; 
        %values denoted _a are the pipes upstream of the node
        %values denoted _b are the pipes downstream of the node
    [Hn Qnd Qnu] = computeMOCNodesS(Ha,Qa,Ba,Ra,Hb,Qb,Bb,Rb);
        %computeMOCNodesS is for pipes in series (one upstream one
        %downstream)
        pipe(k,j).HoD   = Hn; 
        pipe(k,j).QoD   = Qnd;
        pipe(k,j+1).HoU = Hn;
        pipe(k,j+1).QoU = Qnu;
        %replace values in system

    end


%---AT FIXTURES
fixloc = [3 4 7 8 11 13 14 15];
for tt=1:8
    k=fixloc(tt);
    j=2;
    Cp = pipe(k,j).Hi(pipe(k,j).Nx/2) + pipe(k,j).Qi(pipe(k,j).Nx/2)*pipe(k,j).B;
    Bp = pipe(k,j).B - pipe(k,j).R * abs(pipe(k,j).Qi(pipe(k,j).Nx/2));
    if cs(tt)<0.5    %cs=0 indicates the fixture is closed
        pipe(k,j).QoD = max(0,((1/spd)-i)*spd* Qss(tt));
        pipe(k,j).HoD = Cp;
    else            %cs=1 indicates the fixture is open
        Cd = 0.998; %note Cd is a set constant
        aq = 1/(Cd * pipe(k,j).A * sqrt(2*g))^2;% Arises from equation discussed in meetings
        bq = pipe(k,j).B; cq = -Cp;  %coefficients for quadratic equatio
        if Cp < 0 %indicates the direction of flow 
            Qmax = (bq - sqrt(bq^2 - 4*aq*cq))/(2*aq);
           % specific version of the quadratic equation
        else
            Qmax = (sqrt(bq^2 - 4*aq*cq) - bq)/(2*aq);
        end
    pipe(k,j).QoD = min(spd*i*Qmax,Qmax); 
        pipe(k,j).HoD =  Cp - pipe(k,j).QoD*Bp + sysnoise(i);
    end
%pipe(k,j).QoD
%pipe(k,j).HoD
end
    %Indicates resultant flow

%--------------------------------------------------------
%---PARALLEL A CONNECTION  (1up,2down)-------------------------------     
k = 1; j = 1;
        Hu = pipe(k,j+1).Hi(pipe(k,j+1).Nx/2); Qu = pipe(k,j+1).Qi(pipe(k,j+1).Nx/2); 
        Bu = pipe(k,j+1).B;                Ru = pipe(k,j+1).R; 
        Hd1 = pipe(k+1,j).Hi(1);          Qd1 = pipe(k+1,j).Qi(1);
        Bd1 = pipe(k+1,j).B;              Rd1 = pipe(k+1,j).R;
        Hd2 = pipe(k+4,j).Hi(1);          Qd2 = pipe(k+4,j).Qi(1);
        Bd2 = pipe(k+4,j).B;              Rd2 = pipe(k+4,j).R;
        %_u denotes upstream, _d1 and _d2 denote downstream of node. the
        %subs 1 and 2 are arbitrary, but maust remain consistent
    [Hn Qnd Qnu1 Qnu2] = computeMOCNodesP1(Hu,Qu,Bu,Ru,Hd1,Qd1,Bd1,Rd1,Hd2,Qd2,Bd2,Rd2); 
        %computeMOCNodesP1 is for one upstream, two downstram
        pipe(k,j+1).HoD   = Hn; 
        pipe(k,j+1).QoD   = Qnd;
        pipe(k+1,j).HoU = Hn;
        pipe(k+1,j).QoU = Qnu1;
        pipe(k+4,j).HoU = Hn;
        pipe(k+4,j).QoU = Qnu2;
        
        
%--------------------------------------------------------
%---PARALLEL B CONNECTION  (1up,2down)-------------------------------     
k = 2; j = 1;
        Hu = pipe(k,j+1).Hi(pipe(k,j+1).Nx/2); Qu = pipe(k,j+1).Qi(pipe(k,j+1).Nx/2); 
        Bu = pipe(k,j+1).B;                Ru = pipe(k,j+1).R; 
        Hd1 = pipe(k+1,j).Hi(1);          Qd1 = pipe(k+1,j).Qi(1);
        Bd1 = pipe(k+1,j).B;              Rd1 = pipe(k+1,j).R;
        Hd2 = pipe(k+2,j).Hi(1);          Qd2 = pipe(k+2,j).Qi(1);
        Bd2 = pipe(k+2,j).B;              Rd2 = pipe(k+2,j).R;
        %_u denotes upstream, _d1 and _d2 denote downstream of node. the
        %subs 1 and 2 are arbitrary, but maust remain consistent
    [Hn Qnd Qnu1 Qnu2] = computeMOCNodesP1(Hu,Qu,Bu,Ru,Hd1,Qd1,Bd1,Rd1,Hd2,Qd2,Bd2,Rd2); 
        %computeMOCNodesP1 is for one upstream, two downstram
        pipe(k,j+1).HoD   = Hn; 
        pipe(k,j+1).QoD   = Qnd;
        pipe(k+1,j).HoU = Hn;
        pipe(k+1,j).QoU = Qnu1;
        pipe(k+2,j).HoU = Hn;
        pipe(k+2,j).QoU = Qnu2;


%--------------------------------------------------------
%---PARALLEL C CONNECTION  (1up,2down)-------------------------------     
k = 5; j = 1;
        Hu = pipe(k,j+1).Hi(pipe(k,j+1).Nx/2); Qu = pipe(k,j+1).Qi(pipe(k,j+1).Nx/2); 
        Bu = pipe(k,j+1).B;                Ru = pipe(k,j+1).R; 
        Hd1 = pipe(k+1,j).Hi(1);          Qd1 = pipe(k+1,j).Qi(1);
        Bd1 = pipe(k+1,j).B;              Rd1 = pipe(k+1,j).R;
        Hd2 = pipe(k+5,j).Hi(1);          Qd2 = pipe(k+5,j).Qi(1);
        Bd2 = pipe(k+5,j).B;              Rd2 = pipe(k+5,j).R;
        %_u denotes upstream, _d1 and _d2 denote downstream of node. the
        %subs 1 and 2 are arbitrary, but maust remain consistent
    [Hn Qnd Qnu1 Qnu2] = computeMOCNodesP1(Hu,Qu,Bu,Ru,Hd1,Qd1,Bd1,Rd1,Hd2,Qd2,Bd2,Rd2); 
        %computeMOCNodesP1 is for one upstream, two downstram
        pipe(k,j+1).HoD   = Hn; 
        pipe(k,j+1).QoD   = Qnd;
        pipe(k+1,j).HoU = Hn;
        pipe(k+1,j).QoU = Qnu1;
        pipe(k+5,j).HoU = Hn;
        pipe(k+5,j).QoU = Qnu2;


%------------------------------------------------------------
%---PARALLEL D CONNECTION (1 up 3 down)-----------------------------------
    k = 6; j = 1;
        Hu1 = pipe(k,j+1).Hi(pipe(k,j+1).Nx/2); Qu1 = pipe(k,j+1).Qi(pipe(k,j+1).Nx/2);
        Bu1 = pipe(k,j+1).B;                Ru1 = pipe(k,j+1).R; 
        Hd1 = pipe(k+1,j).Hi(1);              Qd1 = pipe(k+1,j).Qi(1);
        Bd1 = pipe(k+1,j).B;                Rd1 = pipe(k+1,j).R;
        Hd2 = pipe(k+2,j).Hi(1);          Qd2 = pipe(k+2,j).Qi(1); 
        Bd2 = pipe(k+2,j).B;              Rd2 = pipe(k+2,j).R;
        Hd3 = pipe(k+3,j).Hi(1);          Qd3 = pipe(k+3,j).Qi(1); 
        Bd3 = pipe(k+3,j).B;              Rd3 = pipe(k+3,j).R;
        
        [Hn Qnd1 Qnu1 Qnu2 Qnu3] = computeMOCNodesP3(Hu1,Qu1,Bu1,Ru1,Hd1,Qd1,Bd1,Rd1,Hd2,Qd2,Bd2,Rd2,Hd3,Qd3,Bd3,Rd3);
        %P2 computes the node for two upstream one downstream
        pipe(k,j+1).HoD   = Hn; 
        pipe(k,j+1).QoD   = Qnd1;
        pipe(k+1,j).HoU = Hn;
        pipe(k+1,j).QoU = Qnu1;
        pipe(k+2,j).HoU = Hn;
        pipe(k+2,j).QoU = Qnu2;
        pipe(k+3,j).HoU = Hn;
        pipe(k+3,j).QoU = Qnu3;
%---------------------------------------------------------
%--PARALLEL E CONNECTION (2 up 2 down)----------------------
k = 9; j = 1;
        Hu1 = pipe(k,j+1).Hi(pipe(k,j+1).Nx/2); Qu1 = pipe(k,j+1).Qi(pipe(k,j+1).Nx/2); 
        Bu1 = pipe(k,j+1).B;                Ru1 = pipe(k,j+1).R; 
        Hu2 = pipe(k+1,j+1).Hi(pipe(k+1,j+1).Nx/2); Qu2 = pipe(k+1,j+1).Qi(pipe(k+1,j+1).Nx/2); 
        Bu2 = pipe(k+1,j+1).B;                Ru2 = pipe(k+1,j+1).R; 
        Hd1 = pipe(k+2,j).Hi(1);          Qd1 = pipe(k+2,j).Qi(1);
        Bd1 = pipe(k+2,j).B;              Rd1 = pipe(k+2,j).R;
        Hd2 = pipe(k+3,j).Hi(1);          Qd2 = pipe(k+3,j).Qi(1);
        Bd2 = pipe(k+3,j).B;              Rd2 = pipe(k+3,j).R;
        %_u denotes upstream, _d1 and _d2 denote downstream of node. the
        %subs 1 and 2 are arbitrary, but maust remain consistent
    [Hn Qnd1 Qnd2 Qnu1 Qnu2] = computeMOCNodesP4(Hu1,Qu1,Bu1,Ru1,Hu2,Qu2,Bu2,Ru2,Hd1,Qd1,Bd1,Rd1,Hd2,Qd2,Bd2,Rd2); 
        %computeMOCNodesP1 is for one upstream, two downstram
        pipe(k,j+1).HoD   = Hn; 
        pipe(k,j+1).QoD   = Qnd1;
        pipe(k+1,j+1).HoD   = Hn; 
        pipe(k+1,j+1).QoD   = Qnd2;
        pipe(k+2,j).HoU = Hn;
        pipe(k+2,j).QoU = Qnu1;
        pipe(k+3,j).HoU = Hn;
        pipe(k+3,j).QoU = Qnu2;
%---------------------------------------------------------
%--PARALLEL F CONNECTION (1 up 3 down)---------------------
    k = 12; j = 1;
        Hu1 = pipe(k,j+1).Hi(pipe(k,j+1).Nx/2); Qu1 = pipe(k,j+1).Qi(pipe(k,j+1).Nx/2);
        Bu1 = pipe(k,j+1).B;                Ru1 = pipe(k,j+1).R; 
        Hd1 = pipe(k+1,j).Hi(1);              Qd1 = pipe(k+1,j).Qi(1);
        Bd1 = pipe(k+1,j).B;                Rd1 = pipe(k+1,j).R;
        Hd2 = pipe(k+2,j).Hi(1);          Qd2 = pipe(k+2,j).Qi(1); 
        Bd2 = pipe(k+2,j).B;              Rd2 = pipe(k+2,j).R;
        Hd3 = pipe(k+3,j).Hi(1);          Qd3 = pipe(k+3,j).Qi(1); 
        Bd3 = pipe(k+3,j).B;              Rd3 = pipe(k+3,j).R;
        
        [Hn Qnd1 Qnu1 Qnu2 Qnu3] = computeMOCNodesP3(Hu1,Qu1,Bu1,Ru1,Hd1,Qd1,Bd1,Rd1,Hd2,Qd2,Bd2,Rd2,Hd3,Qd3,Bd3,Rd3);
        %P2 computes the node for two upstream one downstream
        pipe(k,j+1).HoD   = Hn; 
        pipe(k,j+1).QoD   = Qnd1;
        pipe(k+1,j).HoU = Hn;
        pipe(k+1,j).QoU = Qnu1;
        pipe(k+2,j).HoU = Hn;
        pipe(k+2,j).QoU = Qnu2;
        pipe(k+3,j).HoU = Hn;
        pipe(k+3,j).QoU = Qnu3;

%---SUMMING UP --------------------------------------------
    for k = 1:15
        for j = 1:2
            pipe(k,j).Ho   = [pipe(k,j).HoU ; pipe(k,j).HoI ; pipe(k,j).HoD];
            pipe(k,j).Qo   = [pipe(k,j).QoU ; pipe(k,j).QoI ; pipe(k,j).QoD];
        end     
    end

end

  plot(t(1:Nt),datH(1:Nt,1))
dtH = datH(1:Nt,1) + noise;
% end