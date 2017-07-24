 %script_computeAndInitialiseSteadyState

sz=size(pipe); 
lossCoeff = zeros(sz); %Generate loss coefficient vector for each pipe

for i = 1:length(lossCoeff(:,1))
    for j = 1:length(lossCoeff(1,:))
        lossCoeff(i,j) = pipe(i,j).f * pipe(i,j).L / pipe(i,j).D / pipe(i,j).A^2;
    end
end

lossCoeff(1,2) = lossCoeff(1,1) + lossCoeff(1,2);
lossCoeff(2,1) = lossCoeff(1,2) + lossCoeff(2,1);
lossCoeff(2,2) = lossCoeff(2,1) + lossCoeff(2,2);
lossCoeff(3,1) = lossCoeff(1,2) + lossCoeff(3,1);
lossCoeff(3,2) = lossCoeff(3,1) + lossCoeff(3,2);
lossCoeff(4,1) = lossCoeff(2,2) + lossCoeff(4,1);
lossCoeff(4,2) = lossCoeff(4,1) + lossCoeff(4,2);
lossCoeff(5,1) = lossCoeff(3,2) + lossCoeff(5,1);
lossCoeff(5,2) = lossCoeff(5,1) + lossCoeff(5,2);
lossCoeff(6,1) = lossCoeff(2,2) + lossCoeff(6,1);
lossCoeff(6,2) = lossCoeff(6,1) + lossCoeff(6,2);
lossCoeff(7,1) = lossCoeff(3,2) + lossCoeff(7,1);
lossCoeff(7,2) = lossCoeff(7,1) + lossCoeff(7,2);
lossCoeff(8,1) = lossCoeff(6,2) + lossCoeff(7,2) + lossCoeff(8,1);
lossCoeff(8,2) = lossCoeff(8,1) + lossCoeff(8,2);
  
Qss = zeros(3,1);%Flow at steady state (vector size is number of downstream fixture points)
Qss(3)=sqrt(2 * g * (H0SS - HLSS) / lossCoeff(2,2)); %Valve 3 is open
Qss(1)=0; %Valve 1 is closed
Qss(1)=0; %Valve 2 is closed


%the following outlines vectors of flow and head
pipe(1,1).Qo = (sum(Qss)) * ones(pipe(1,1).Nx/2+1,1);%flow throughout first pipe at steady
pipe(1,2).Qo = (sum(Qss)) * ones(pipe(1,2).Nx/2+1,1);%head throughout first pipe at steady state 
pipe(1,1).Ho = H0SS - [0:pipe(1,1).Nx/2]' * 2 * pipe(1,1).R * (Qss(1)+Qss(2)) ^ 2;
pipe(1,2).Ho = pipe(1,1).Ho(pipe(1,1).Nx/2+1) - [0:pipe(1,2).Nx/2]' * 2 * pipe(1,2).R * (Qss(1)+Qss(2)) ^ 2;

pipe(2,1).Qo = (Qss(1)+Qss(3)/2) * ones(pipe(2,1).Nx/2+1,1);
pipe(2,1).Ho = pipe(1,2).Ho(pipe(1,2).Nx/2+1) - [0:pipe(2,1).Nx/2]' * 2 * pipe(2,1).R * (Qss(1)+Qss(3)/2) ^ 2;
pipe(2,2).Qo = (Qss(1)+Qss(3)/2) * ones(pipe(2,2).Nx/2+1,1);
pipe(2,2).Ho = pipe(2,1).Ho(pipe(2,1).Nx/2+1) - [0:pipe(2,2).Nx/2]' * 2 * pipe(2,2).R * (Qss(1)+Qss(3)/2) ^ 2;

pipe(3,1).Qo = (Qss(2)+Qss(3)/2) * ones(pipe(3,1).Nx/2+1,1);
pipe(3,1).Ho = pipe(1,2).Ho(pipe(1,2).Nx/2+1) - [0:pipe(3,1).Nx/2]' * 2 * pipe(3,1).R * (Qss(2)+Qss(3)/2) ^ 2;
pipe(3,2).Qo = (Qss(2)+Qss(3)/2) * ones(pipe(3,2).Nx/2+1,1);
pipe(3,2).Ho = pipe(3,1).Ho(pipe(3,1).Nx/2+1) - [0:pipe(3,2).Nx/2]' * 2 * pipe(3,2).R * (Qss(2)+Qss(3)/2) ^ 2;

pipe(4,1).Qo = Qss(1) * ones(pipe(4,1).Nx/2+1,1);
pipe(4,1).Ho = pipe(2,2).Ho(pipe(1,2).Nx/2+1) - [0:pipe(4,1).Nx/2]' * 2 * pipe(4,1).R * Qss(1) ^ 2;
pipe(4,2).Qo = Qss(1) * ones(pipe(4,2).Nx/2+1,1);
pipe(4,2).Ho = pipe(4,1).Ho(pipe(4,1).Nx/2+1) - [0:pipe(4,2).Nx/2]' * 2 * pipe(4,2).R * Qss(1) ^ 2;

pipe(5,1).Qo = Qss(2) * ones(pipe(5,1).Nx/2+1,1);
pipe(5,1).Ho = pipe(3,2).Ho(pipe(3,2).Nx/2+1) - [0:pipe(5,1).Nx/2]' * 2 * pipe(5,1).R * Qss(2) ^ 2;
pipe(5,2).Qo = Qss(1) * ones(pipe(2,2).Nx/2+1,1);
pipe(5,2).Ho = pipe(2,1).Ho(pipe(2,1).Nx/2+1) - [0:pipe(2,2).Nx/2]' * 2 * pipe(2,2).R * Qss(2) ^ 2;

pipe(6,1).Qo = (Qss(3)/2) * ones(pipe(6,1).Nx/2+1,1);
pipe(6,1).Ho = pipe(2,2).Ho(pipe(2,2).Nx/2+1) - [0:pipe(6,1).Nx/2]' * 2 * pipe(6,1).R * (Qss(3)/2) ^ 2;
pipe(6,2).Qo = (Qss(3)/2) * ones(pipe(6,2).Nx/2+1,1);
pipe(6,2).Ho = pipe(6,1).Ho(pipe(6,1).Nx/2+1) - [0:pipe(6,2).Nx/2]' * 2 * pipe(6,2).R * (Qss(3)/2) ^ 2;

pipe(7,1).Qo = (Qss(3)/2) * ones(pipe(7,1).Nx/2+1,1);
pipe(7,1).Ho = pipe(3,2).Ho(pipe(3,2).Nx/2+1) - [0:pipe(7,1).Nx/2]' * 2 * pipe(7,1).R * (Qss(3)/2) ^ 2;
pipe(7,2).Qo = (Qss(3)/2) * ones(pipe(7,2).Nx/2+1,1);
pipe(7,2).Ho = pipe(7,1).Ho(pipe(7,1).Nx/2+1) - [0:pipe(7,2).Nx/2]' * 2 * pipe(7,2).R * (Qss(3)/2) ^ 2;

pipe(8,1).Qo = Qss(3) * ones(pipe(8,1).Nx/2+1,1);
pipe(8,1).Ho = (pipe(6,2).Ho(pipe(6,2).Nx/2+1)+pipe(7,2).Ho(pipe(7,2).Nx/2+1)) - [0:pipe(8,1).Nx/2]' * 2 * pipe(8,1).R * Qss(3) ^ 2;
pipe(8,2).Qo = Qss(3) * ones(pipe(8,2).Nx/2+1,1);
pipe(8,2).Ho = pipe(8,1).Ho(pipe(8,1).Nx/2+1) - [0:pipe(8,2).Nx/2]' * 2 * pipe(8,2).R * Qss(3) ^ 2;

%for i = 2:length(pipe)%for other pipes
%    pipe(i).Qo = Qss(i) * ones(pipe(i).Nx/2+1,1);
%    pipe(i).Ho = pipe(i-1).Ho(pipe(i-1).Nx/2+1) - [0:pipe(i).Nx/2]' * 2 * pipe(i).R * Qss(i) ^ 2;
%end