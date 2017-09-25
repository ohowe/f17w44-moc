 %script_computeAndInitialiseSteadyState

sz=size(pipe); 
lossCoeff = zeros(sz); %Generate loss coefficient vector for each pipe

%determines all loss coefficients analysing each pipe individually
for i = 1:length(lossCoeff(:,1))
    for j = 1:length(lossCoeff(1,:))
        lossCoeff(i,j) = pipe(i,j).f * pipe(i,j).L / pipe(i,j).D / pipe(i,j).A^2;
    end
end

%The actual loss coefficient for each pipe is the loss within the pipe AND
%every upstream loss coefficient This is enered manually below (see
%script_MOC for a visual representation)
lgg=zeros(3,1); %vector for loss coeficients at each fixture
lossCoeff(1,2) = lossCoeff(1,1) + lossCoeff(1,2);
lossCoeff(2,1) = lossCoeff(1,2) + lossCoeff(2,1);
lossCoeff(2,2) = lossCoeff(2,1) + lossCoeff(2,2);
lossCoeff(3,1) = lossCoeff(1,2) + lossCoeff(3,1);
lossCoeff(3,2) = lossCoeff(3,1) + lossCoeff(3,2);
lossCoeff(4,1) = lossCoeff(2,2) + lossCoeff(4,1);
lossCoeff(4,2) = lossCoeff(4,1) + lossCoeff(4,2);
lgg(1)=lossCoeff(4,2);  %loss coefficient at fixture 4
lossCoeff(5,1) = lossCoeff(3,2) + lossCoeff(5,1);
lossCoeff(5,2) = lossCoeff(5,1) + lossCoeff(5,2);
lgg(2)=lossCoeff(5,2);%loss coefficient at fixture 5
lossCoeff(6,1) = lossCoeff(2,2) + lossCoeff(6,1);
lossCoeff(6,2) = lossCoeff(6,1) + lossCoeff(6,2);
lossCoeff(7,1) = lossCoeff(3,2) + lossCoeff(7,1);
lossCoeff(7,2) = lossCoeff(7,1) + lossCoeff(7,2);
lossCoeff(8,1) = lossCoeff(6,2) + lossCoeff(7,2) + lossCoeff(8,1);
lossCoeff(8,2) = lossCoeff(8,1) + lossCoeff(8,2);
lgg(3)=lossCoeff(8,2); %loss coefficient at fixture8 

Qss = zeros(3,1);%Flow at steady state (vector size is number of downstream fixture points)
%determines the steady state flow at each fixture (0 if closed and
%according to equation below if open)

HLSS = [6.5047 7.0353 4.3457];

for i=1:3
    if ss(i)>0.5 %(ss(i)=0 then fixture starts clkosed if ss(i)=1 then open) 
        Qss(i)=sqrt(2 * g * (H0SS - HLSS(i)) / (lgg(i)));
    else
        Qss(i)=0;
    end
end
Qss

%the following outlines vectors of flow and head with hardcoded connections
%in accordance with the figure in script_MOC
pipe(1,1).Qo = (sum(Qss)) * ones(pipe(1,1).Nx/2+1,1);%flow throughout first pipe at steady
pipe(1,2).Qo = (sum(Qss)) * ones(pipe(1,2).Nx/2+1,1);
pipe(1,1).Ho = H0SS - [0:pipe(1,1).Nx/2]' * 2 * pipe(1,1).R * (sum(Qss)) ^ 2;%head throughout first pipe at steady state 
pipe(1,2).Ho = pipe(1,1).Ho(pipe(1,1).Nx/2+1) - [0:pipe(1,2).Nx/2]' * 2 * pipe(1,2).R * (sum(Qss)) ^ 2;

pipe(2,1).Qo = (Qss(1)+Qss(3)/2) * ones(pipe(2,1).Nx/2+1,1);
pipe(2,1).Ho = pipe(1,2).Ho(pipe(1,2).Nx/2+1) - [0:pipe(2,1).Nx/2]' * 2 * pipe(2,1).R * (Qss(1)+Qss(3)/2) ^ 2;
pipe(2,2).Qo = (Qss(1)+Qss(3)/2) * ones(pipe(2,2).Nx/2+1,1);
pipe(2,2).Ho = pipe(2,1).Ho(pipe(2,1).Nx/2+1) - [0:pipe(2,2).Nx/2]' * 2 * pipe(2,2).R * (Qss(1)+Qss(3)/2) ^ 2;

pipe(3,1).Qo = (Qss(2)+Qss(3)/2) * ones(pipe(3,1).Nx/2+1,1);
pipe(3,1).Ho = pipe(1,2).Ho(pipe(1,2).Nx/2+1) - [0:pipe(3,1).Nx/2]' * 2 * pipe(3,1).R * (Qss(2)+Qss(3)/2) ^ 2;
pipe(3,2).Qo = (Qss(2)+Qss(3)/2) * ones(pipe(3,2).Nx/2+1,1);
pipe(3,2).Ho = pipe(3,1).Ho(pipe(3,1).Nx/2+1) - [0:pipe(3,2).Nx/2]' * 2 * pipe(3,2).R * (Qss(2)+Qss(3)/2) ^ 2;

pipe(4,1).Qo = Qss(1) * ones(pipe(4,1).Nx/2+1,1);
pipe(4,1).Ho = pipe(2,2).Ho(pipe(2,2).Nx/2+1) - [0:pipe(4,1).Nx/2]' * 2 * pipe(4,1).R * Qss(1) ^ 2;
pipe(4,2).Qo = Qss(1) * ones(pipe(4,2).Nx/2+1,1);
pipe(4,2).Ho = pipe(4,1).Ho(pipe(4,1).Nx/2+1) - [0:pipe(4,2).Nx/2]' * 2 * pipe(4,2).R * Qss(1) ^ 2;

pipe(5,1).Qo = Qss(2) * ones(pipe(5,1).Nx/2+1,1);
pipe(5,1).Ho = pipe(3,2).Ho(pipe(3,2).Nx/2+1) - [0:pipe(5,1).Nx/2]' * 2 * pipe(5,1).R * Qss(2) ^ 2;
pipe(5,2).Qo = Qss(1) * ones(pipe(5,2).Nx/2+1,1);
pipe(5,2).Ho = pipe(5,1).Ho(pipe(5,1).Nx/2+1) - [0:pipe(5,2).Nx/2]' * 2 * pipe(5,2).R * Qss(2) ^ 2;

pipe(6,1).Qo = (Qss(3)/2) * ones(pipe(6,1).Nx/2+1,1);
pipe(6,1).Ho = pipe(2,2).Ho(pipe(2,2).Nx/2+1) - [0:pipe(6,1).Nx/2]' * 2 * pipe(6,1).R * (Qss(3)/2) ^ 2;
pipe(6,2).Qo = (Qss(3)/2) * ones(pipe(6,2).Nx/2+1,1);
pipe(6,2).Ho = pipe(6,1).Ho(pipe(6,1).Nx/2+1) - [0:pipe(6,2).Nx/2]' * 2 * pipe(6,2).R * (Qss(3)/2) ^ 2;

pipe(7,1).Qo = (Qss(3)/2) * ones(pipe(7,1).Nx/2+1,1);
pipe(7,1).Ho = pipe(3,2).Ho(pipe(3,2).Nx/2+1) - [0:pipe(7,1).Nx/2]' * 2 * pipe(7,1).R * (Qss(3)/2) ^ 2;
pipe(7,2).Qo = (Qss(3)/2) * ones(pipe(7,2).Nx/2+1,1);
pipe(7,2).Ho = pipe(7,1).Ho(pipe(7,1).Nx/2+1) - [0:pipe(7,2).Nx/2]' * 2 * pipe(7,2).R * (Qss(3)/2) ^ 2;

pipe(8,1).Qo = Qss(3) * ones(pipe(8,1).Nx/2+1,1);
pipe(8,1).Ho = (pipe(6,2).Ho(pipe(6,2).Nx/2+1)/2+pipe(7,2).Ho(pipe(7,2).Nx/2+1)/2) - [0:pipe(8,1).Nx/2]' * 2 * pipe(8,1).R * Qss(3) ^ 2;
pipe(8,2).Qo = Qss(3) * ones(pipe(8,2).Nx/2+1,1);
pipe(8,2).Ho = pipe(8,1).Ho(pipe(8,1).Nx/2+1) - [0:pipe(8,2).Nx/2]' * 2 * pipe(8,2).R * Qss(3) ^ 2;
