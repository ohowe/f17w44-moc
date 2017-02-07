% script_computeAndInitialiseSteadyState

lossCoeff = 0;
for i = 1:length(pipe)%sums up frictional head loss
    lossCoeff = lossCoeff + pipe(i).f * pipe(i).L / pipe(i).D / pipe(i).A ^ 2;%darcy weisbach
end
Qss = sqrt(2 * g * (H0SS - HLSS) / lossCoeff);%Flow at steady state
%the following outlines vectors of flow and head
i = 1;%for pipe 1
pipe(i).Qo = Qss * ones(pipe(i).Nx/2+1,1);
pipe(i).Ho = H0SS - [0:pipe(i).Nx/2]' * 2 * pipe(i).R * Qss ^ 2;

for i = 2:length(pipe)%for other pipes
    pipe(i).Qo = Qss * ones(pipe(i).Nx/2+1,1);
    pipe(i).Ho = pipe(i-1).Ho(pipe(i-1).Nx/2+1) - [0:pipe(i).Nx/2]' * 2 * pipe(i).R * Qss ^ 2;
end