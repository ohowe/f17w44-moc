 %script_computeAndInitialiseSteadyState

 
lossCoeff = zeros(length(pipe));%Generate loss coefficient for each pipe
lossCoeff(1)= pipe(1).f * pipe(1).L / pipe(1).D / pipe(1).A^2; % first pipe loss coefficient

%loss coefficients after first split
lossCoeff(2)=lossCoeff(1) + pipe(2).f * pipe(2).L / pipe(2).D / pipe(2).A^2;
lossCoeff(3)=lossCoeff(1) + pipe(3).f * pipe(3).L / pipe(3).D / pipe(3).A^2;    

Qss = zeros(2);%Flow at steady state (vector size is number of downstream fixture points)
Qss(1)=sqrt(2 * g * (H0SS - HLSS) / lossCoeff(2)); %Valve 1 is open
Qss(2)=0; %Valve 2 is closed

%the following outlines vectors of flow and head
i = 1;%for pipe 1
pipe(i).Qo = (Qss(1)+Qss(2)) * ones(pipe(i).Nx/2+1,1); %flow throughout first pipe at steady
pipe(i).Ho = H0SS - [0:pipe(i).Nx/2]' * 2 * pipe(i).R * (Qss(1)+Qss(2)) ^ 2; %head throughout first pipe at steady state 

for i = 2:length(pipe)%for other pipes
    pipe(i).Qo = Qss(i) * ones(pipe(i).Nx/2+1,1);
    pipe(i).Ho = pipe(i-1).Ho(pipe(i-1).Nx/2+1) - [0:pipe(i).Nx/2]' * 2 * pipe(i).R * Qss(i) ^ 2;
end