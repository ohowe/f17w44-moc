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
lgg=zeros(11,1); %vector for loss coeficients at each fixture

lossCoeff(1,2) = lossCoeff(1,1) + lossCoeff(1,2);
lossCoeff(2,1) = lossCoeff(1,2) + lossCoeff(2,1);
lossCoeff(2,2) = lossCoeff(2,1) + lossCoeff(2,2);
lossCoeff(3,1) = lossCoeff(2,2) + lossCoeff(3,1);
lossCoeff(3,2) = lossCoeff(3,1) + lossCoeff(3,2);
lgg(1) = lossCoeff(3,2);
lossCoeff(4,1) = lossCoeff(2,2) + lossCoeff(4,1);
lossCoeff(4,2) = lossCoeff(4,1) + lossCoeff(4,2);
lossCoeff(5,1) = lossCoeff(4,2) + lossCoeff(5,1);
lossCoeff(5,2) = lossCoeff(5,1) + lossCoeff(5,2);
lgg(2) = lossCoeff(5,2);
lossCoeff(6,1) = lossCoeff(4,2) + lossCoeff(6,1);
lossCoeff(6,2) = lossCoeff(6,1) + lossCoeff(6,2);
lossCoeff(7,1) = lossCoeff(6,2) + lossCoeff(7,1);
lossCoeff(7,2) = lossCoeff(7,1) + lossCoeff(7,2);
lgg(3)=lossCoeff(7,2);
lossCoeff(8,1) = lossCoeff(6,2) + lossCoeff(8,1);
lossCoeff(8,2) = lossCoeff(8,1) + lossCoeff(8,2);
lossCoeff(9,1) = lossCoeff(8,2) + lossCoeff(9,1);
lossCoeff(9,2) = lossCoeff(9,1) + lossCoeff(9,2);
lgg(4)=lossCoeff(9,2);
lossCoeff(10,1) = lossCoeff(1,2) + lossCoeff(10,1);
lossCoeff(10,2) = lossCoeff(10,1) + lossCoeff(10,2);
lossCoeff(11,1) = lossCoeff(10,2) + lossCoeff(11,1);
lossCoeff(11,2) = lossCoeff(11,1) + lossCoeff(11,2);
lgg(5)=lossCoeff(11,2);
lossCoeff(12,1) = lossCoeff(11,2) + lossCoeff(12,1);
lossCoeff(12,2) = lossCoeff(12,1) + lossCoeff(12,2);
lossCoeff(13,1) = lossCoeff(12,2) + lossCoeff(13,1);
lossCoeff(13,2) = lossCoeff(13,1) + lossCoeff(13,2);
lossCoeff(14,1) = lossCoeff(13,2) + lossCoeff(14,1);
lossCoeff(14,2) = lossCoeff(14,1) + lossCoeff(14,2);
lgg(6)=lossCoeff(14,2);
lossCoeff(15,1) = lossCoeff(13,2) + lossCoeff(15,1);
lossCoeff(15,2) = lossCoeff(15,1) + lossCoeff(15,2);
lossCoeff(16,1) = lossCoeff(15,2) + lossCoeff(16,1);
lossCoeff(16,2) = lossCoeff(15,1) + lossCoeff(16,2);
lgg(7)=lossCoeff(16,2);
lossCoeff(17,1) = lossCoeff(12,2) + lossCoeff(17,1);
lossCoeff(17,2) = lossCoeff(17,1) + lossCoeff(17,2);
lossCoeff(18,1) = lossCoeff(17,2) + lossCoeff(18,1);
lossCoeff(18,2) = lossCoeff(18,1) + lossCoeff(18,2);
lossCoeff(19,1) = lossCoeff(18,2) + lossCoeff(19,1);
lossCoeff(19,2) = lossCoeff(19,1) + lossCoeff(19,2);
lgg(8)=lossCoeff(19,2);
lossCoeff(20,1) = lossCoeff(18,2) + lossCoeff(20,1);
lossCoeff(20,2) = lossCoeff(20,1) + lossCoeff(20,2);
lgg(9)=lossCoeff(20,2);
lossCoeff(21,1) = lossCoeff(17,2) + lossCoeff(21,1);
lossCoeff(21,2) = lossCoeff(21,1) + lossCoeff(21,2);
lossCoeff(22,1) = lossCoeff(21,2) + lossCoeff(22,1);
lossCoeff(22,2) = lossCoeff(22,1) + lossCoeff(22,2);
lgg(10)=lossCoeff(22,2);
lossCoeff(23,1) = lossCoeff(21,2) + lossCoeff(23,1);
lossCoeff(23,2) = lossCoeff(23,1) + lossCoeff(23,2);
lgg(11)=lossCoeff(23,2);

Qss = zeros(11,1);%Flow at steady state (vector size is number of downstream fixture points)
%determines the steady state flow at each fixture (0 if closed and
%according to equation below if open)
for i=1:11
    if ss(i)>=0.5 %(ss(i)=0 then fixture starts clkosed if ss(i)=1 then open) 
        Qss(i)=sqrt(2 * g * (H0SS - 0.1) / (lgg(i)));
    else
        Qss(i)=0;
    end
end
Qss

%the following outlines vectors of flow and head with hardcoded connections
%in accordance with the figure in script_MOC
pipe(1,1).Qo = (sum(Qss)) * ones(pipe(1,1).Nx/2+1,1);%flow throughout first pipe at steady
pipe(1,1).Ho = H0SS - [0:pipe(1,1).Nx/2]' * 2 * pipe(1,1).R * (sum(Qss)) ^ 2;%head throughout first pipe at steady state 
pipe(1,2).Qo = (sum(Qss)) * ones(pipe(1,2).Nx/2+1,1);
pipe(1,2).Ho = pipe(1,1).Ho(pipe(1,1).Nx/2+1) - [0:pipe(1,2).Nx/2]' * 2 * pipe(1,2).R * (sum(Qss)) ^ 2;

pipe(2,1).Qo = (Qss(1)+Qss(2)+Qss(3)+Qss(4)) * ones(pipe(2,1).Nx/2+1,1);
pipe(2,1).Ho = pipe(1,2).Ho(pipe(1,2).Nx/2+1) - [0:pipe(2,1).Nx/2]' * 2 * pipe(2,1).R * (Qss(1)+Qss(2)+Qss(3)+Qss(4)) ^ 2;
pipe(2,2).Qo = (Qss(1)+Qss(2)+Qss(3)+Qss(4)) * ones(pipe(2,2).Nx/2+1,1);
pipe(2,2).Ho = pipe(2,1).Ho(pipe(2,1).Nx/2+1) - [0:pipe(2,2).Nx/2]' * 2 * pipe(2,2).R * (Qss(1)+Qss(2)+Qss(3)+Qss(4)) ^ 2;

pipe(3,1).Qo = (Qss(1)) * ones(pipe(3,1).Nx/2+1,1);
pipe(3,1).Ho = pipe(2,2).Ho(pipe(2,2).Nx/2+1) - [0:pipe(3,1).Nx/2]' * 2 * pipe(3,1).R * (Qss(1)) ^ 2;
pipe(3,2).Qo = (Qss(1)) * ones(pipe(3,2).Nx/2+1,1);
pipe(3,2).Ho = pipe(3,1).Ho(pipe(3,1).Nx/2+1) - [0:pipe(3,2).Nx/2]' * 2 * pipe(3,2).R * (Qss(1)) ^ 2;

pipe(4,1).Qo = (Qss(2)+Qss(3)+Qss(4)) * ones(pipe(4,1).Nx/2+1,1);
pipe(4,1).Ho = pipe(2,2).Ho(pipe(2,2).Nx/2+1) - [0:pipe(4,1).Nx/2]' * 2 * pipe(4,1).R * (Qss(2)+Qss(3)+Qss(4)) ^ 2;
pipe(4,2).Qo = (Qss(2)+Qss(3)+Qss(4)) * ones(pipe(4,2).Nx/2+1,1);
pipe(4,2).Ho = pipe(4,1).Ho(pipe(4,1).Nx/2+1) - [0:pipe(4,2).Nx/2]' * 2 * pipe(4,2).R * (Qss(2)+Qss(3)+Qss(4)) ^ 2;

pipe(5,1).Qo = (Qss(2)) * ones(pipe(5,1).Nx/2+1,1);
pipe(5,1).Ho = pipe(4,2).Ho(pipe(4,2).Nx/2+1) - [0:pipe(5,1).Nx/2]' * 2 * pipe(5,1).R * (Qss(2)) ^ 2;
pipe(5,2).Qo = (Qss(2)) * ones(pipe(5,2).Nx/2+1,1);
pipe(5,2).Ho = pipe(5,1).Ho(pipe(5,1).Nx/2+1) - [0:pipe(5,2).Nx/2]' * 2 * pipe(5,2).R * (Qss(2)) ^ 2;

pipe(6,1).Qo = (Qss(3)+Qss(4)) * ones(pipe(6,1).Nx/2+1,1);
pipe(6,1).Ho = pipe(4,2).Ho(pipe(4,2).Nx/2+1) - [0:pipe(6,1).Nx/2]' * 2 * pipe(6,1).R * (Qss(3)+Qss(4)) ^ 2;
pipe(6,2).Qo = (Qss(3)+Qss(4)) * ones(pipe(6,2).Nx/2+1,1);
pipe(6,2).Ho = pipe(6,1).Ho(pipe(6,1).Nx/2+1) - [0:pipe(6,2).Nx/2]' * 2 * pipe(6,2).R * (Qss(3)+Qss(4)) ^ 2;

pipe(7,1).Qo = (Qss(3)) * ones(pipe(7,1).Nx/2+1,1);
pipe(7,1).Ho = pipe(6,2).Ho(pipe(6,2).Nx/2+1) - [0:pipe(7,1).Nx/2]' * 2 * pipe(7,1).R * (Qss(3)) ^ 2;
pipe(7,2).Qo = (Qss(3)) * ones(pipe(7,2).Nx/2+1,1);
pipe(7,2).Ho = pipe(7,1).Ho(pipe(7,1).Nx/2+1) - [0:pipe(7,2).Nx/2]' * 2 * pipe(7,2).R * (Qss(3)) ^ 2;

pipe(8,1).Qo = Qss(4) * ones(pipe(8,1).Nx/2+1,1);
pipe(8,1).Ho = pipe(6,2).Ho(pipe(6,2).Nx/2+1) - [0:pipe(8,1).Nx/2]' * 2 * pipe(8,1).R * Qss(4) ^ 2;
pipe(8,2).Qo = Qss(4) * ones(pipe(8,2).Nx/2+1,1);
pipe(8,2).Ho = pipe(8,1).Ho(pipe(8,1).Nx/2+1) - [0:pipe(8,2).Nx/2]' * 2 * pipe(8,2).R * Qss(4) ^ 2;

pipe(9,1).Qo = (Qss(4)) * ones(pipe(9,1).Nx/2+1,1);
pipe(9,1).Ho = pipe(8,2).Ho(pipe(8,2).Nx/2+1) - [0:pipe(9,1).Nx/2]' * 2 * pipe(9,1).R * (Qss(4)) ^ 2;
pipe(9,2).Qo = (Qss(4)) * ones(pipe(9,2).Nx/2+1,1);
pipe(9,2).Ho = pipe(9,1).Ho(pipe(9,1).Nx/2+1) - [0:pipe(9,2).Nx/2]' * 2 * pipe(9,2).R * (Qss(4)) ^ 2;

pipe(10,1).Qo = (Qss(5)+Qss(6)+Qss(7)+Qss(8)+Qss(9)+Qss(10)+Qss(11)) * ones(pipe(10,1).Nx/2+1,1);
pipe(10,1).Ho = pipe(1,2).Ho(pipe(1,2).Nx/2+1) - [0:pipe(10,1).Nx/2]' * 2 * pipe(10,1).R * (Qss(5)+Qss(6)+Qss(7)+Qss(8)+Qss(9)+Qss(10)+Qss(11)) ^ 2;
pipe(10,2).Qo = (Qss(5)+Qss(6)+Qss(7)+Qss(8)+Qss(9)+Qss(10)+Qss(11)) * ones(pipe(10,2).Nx/2+1,1);
pipe(10,2).Ho = pipe(10,1).Ho(pipe(10,1).Nx/2+1) - [0:pipe(10,2).Nx/2]' * 2 * pipe(10,2).R * (Qss(5)+Qss(6)+Qss(7)+Qss(8)+Qss(9)+Qss(10)+Qss(11)) ^ 2;

pipe(11,1).Qo = (Qss(5)) * ones(pipe(11,1).Nx/2+1,1);
pipe(11,1).Ho = pipe(10,2).Ho(pipe(10,2).Nx/2+1) - [0:pipe(11,1).Nx/2]' * 2 * pipe(2,1).R * (Qss(5)) ^ 2;
pipe(11,2).Qo = (Qss(5)) * ones(pipe(11,2).Nx/2+1,1);
pipe(11,2).Ho = pipe(11,1).Ho(pipe(11,1).Nx/2+1) - [0:pipe(11,2).Nx/2]' * 2 * pipe(11,2).R * (Qss(5)) ^ 2;

pipe(12,1).Qo = (Qss(6)+Qss(7)+Qss(8)+Qss(9)+Qss(10)+Qss(11)) * ones(pipe(12,1).Nx/2+1,1);
pipe(12,1).Ho = pipe(10,2).Ho(pipe(10,2).Nx/2+1) - [0:pipe(12,1).Nx/2]' * 2 * pipe(12,1).R * (Qss(6)+Qss(7)+Qss(8)+Qss(9)+Qss(10)+Qss(11)) ^ 2;
pipe(12,2).Qo = (Qss(6)+Qss(7)+Qss(8)+Qss(9)+Qss(10)+Qss(11)) * ones(pipe(12,2).Nx/2+1,1);
pipe(12,2).Ho = pipe(12,1).Ho(pipe(12,1).Nx/2+1) - [0:pipe(12,2).Nx/2]' * 2 * pipe(12,2).R * (Qss(6)+Qss(7)+Qss(8)+Qss(9)+Qss(10)+Qss(11)) ^ 2;

pipe(13,1).Qo = (Qss(6)+Qss(7)) * ones(pipe(13,1).Nx/2+1,1);
pipe(13,1).Ho = pipe(12,2).Ho(pipe(12,2).Nx/2+1) - [0:pipe(13,1).Nx/2]' * 2 * pipe(13,1).R * (Qss(6)+Qss(7)) ^ 2;
pipe(13,2).Qo = (Qss(6)+Qss(7)) * ones(pipe(13,2).Nx/2+1,1);
pipe(13,2).Ho = pipe(13,1).Ho(pipe(13,1).Nx/2+1) - [0:pipe(13,2).Nx/2]' * 2 * pipe(13,2).R * (Qss(6)+Qss(7)) ^ 2;

pipe(14,1).Qo = (Qss(6)) * ones(pipe(14,1).Nx/2+1,1);
pipe(14,1).Ho = pipe(13,2).Ho(pipe(13,2).Nx/2+1) - [0:pipe(14,1).Nx/2]' * 2 * pipe(14,1).R * (Qss(6)) ^ 2;
pipe(14,2).Qo = (Qss(6)) * ones(pipe(14,2).Nx/2+1,1);
pipe(14,2).Ho = pipe(14,1).Ho(pipe(14,1).Nx/2+1) - [0:pipe(14,2).Nx/2]' * 2 * pipe(14,2).R * (Qss(6)) ^ 2;

pipe(15,1).Qo = (Qss(7)) * ones(pipe(15,1).Nx/2+1,1);
pipe(15,1).Ho = pipe(13,2).Ho(pipe(13,2).Nx/2+1) - [0:pipe(15,1).Nx/2]' * 2 * pipe(15,1).R * (Qss(7)) ^ 2;
pipe(15,2).Qo = (Qss(7)) * ones(pipe(15,2).Nx/2+1,1);
pipe(15,2).Ho = pipe(15,1).Ho(pipe(15,1).Nx/2+1) - [0:pipe(15,2).Nx/2]' * 2 * pipe(15,2).R * (Qss(7)) ^ 2;

pipe(16,1).Qo = (Qss(7)) * ones(pipe(16,1).Nx/2+1,1);
pipe(16,1).Ho = pipe(15,2).Ho(pipe(15,2).Nx/2+1) - [0:pipe(16,1).Nx/2]' * 2 * pipe(16,1).R * (Qss(7)) ^ 2;
pipe(16,2).Qo = (Qss(7)) * ones(pipe(16,2).Nx/2+1,1);
pipe(16,2).Ho = pipe(16,1).Ho(pipe(16,1).Nx/2+1) - [0:pipe(16,2).Nx/2]' * 2 * pipe(16,2).R * (Qss(7)) ^ 2;

pipe(17,1).Qo = (Qss(8)+Qss(9)+Qss(10)+Qss(11)) * ones(pipe(17,1).Nx/2+1,1);
pipe(17,1).Ho = pipe(12,2).Ho(pipe(12,2).Nx/2+1) - [0:pipe(17,1).Nx/2]' * 2 * pipe(17,1).R * (Qss(8)+Qss(9)+Qss(10)+Qss(11)) ^ 2;
pipe(17,2).Qo = (Qss(8)+Qss(9)+Qss(10)+Qss(11)) * ones(pipe(17,2).Nx/2+1,1);
pipe(17,2).Ho = pipe(17,1).Ho(pipe(17,1).Nx/2+1) - [0:pipe(17,2).Nx/2]' * 2 * pipe(17,2).R * (Qss(8)+Qss(9)+Qss(10)+Qss(11)) ^ 2;

pipe(18,1).Qo = (Qss(8)+Qss(9)) * ones(pipe(18,1).Nx/2+1,1);
pipe(18,1).Ho = pipe(17,2).Ho(pipe(17,2).Nx/2+1) - [0:pipe(18,1).Nx/2]' * 2 * pipe(18,1).R * (Qss(8)+Qss(9)) ^ 2;
pipe(18,2).Qo = (Qss(8)+Qss(9)) * ones(pipe(18,2).Nx/2+1,1);
pipe(18,2).Ho = pipe(18,1).Ho(pipe(18,1).Nx/2+1) - [0:pipe(18,2).Nx/2]' * 2 * pipe(18,2).R * (Qss(8)+Qss(9)) ^ 2;

pipe(19,1).Qo = (Qss(8)) * ones(pipe(19,1).Nx/2+1,1);
pipe(19,1).Ho = pipe(18,2).Ho(pipe(18,2).Nx/2+1) - [0:pipe(19,1).Nx/2]' * 2 * pipe(19,1).R * (Qss(8)) ^ 2;
pipe(19,2).Qo = (Qss(8)) * ones(pipe(19,2).Nx/2+1,1);
pipe(19,2).Ho = pipe(19,1).Ho(pipe(19,1).Nx/2+1) - [0:pipe(19,2).Nx/2]' * 2 * pipe(19,2).R * (Qss(8)) ^ 2;

pipe(20,1).Qo = (Qss(9)) * ones(pipe(20,1).Nx/2+1,1);
pipe(20,1).Ho = pipe(18,2).Ho(pipe(18,2).Nx/2+1) - [0:pipe(20,1).Nx/2]' * 2 * pipe(20,1).R * (Qss(9)) ^ 2;
pipe(20,2).Qo = (Qss(9)) * ones(pipe(20,2).Nx/2+1,1);
pipe(20,2).Ho = pipe(20,1).Ho(pipe(20,1).Nx/2+1) - [0:pipe(20,2).Nx/2]' * 2 * pipe(20,2).R * (Qss(9)) ^ 2;

pipe(21,1).Qo = (Qss(10)+Qss(11)) * ones(pipe(21,1).Nx/2+1,1);
pipe(21,1).Ho = pipe(17,2).Ho(pipe(17,2).Nx/2+1) - [0:pipe(21,1).Nx/2]' * 2 * pipe(21,1).R * (Qss(10)+Qss(11)) ^ 2;
pipe(21,2).Qo = (Qss(10)+Qss(11)) * ones(pipe(21,2).Nx/2+1,1);
pipe(21,2).Ho = pipe(21,1).Ho(pipe(21,1).Nx/2+1) - [0:pipe(21,2).Nx/2]' * 2 * pipe(21,2).R * (Qss(10)+Qss(11)) ^ 2;

pipe(22,1).Qo = (Qss(10)) * ones(pipe(22,1).Nx/2+1,1);
pipe(22,1).Ho = pipe(21,2).Ho(pipe(21,2).Nx/2+1) - [0:pipe(22,1).Nx/2]' * 2 * pipe(22,1).R * (Qss(10)) ^ 2;
pipe(22,2).Qo = (Qss(10)) * ones(pipe(22,2).Nx/2+1,1);
pipe(22,2).Ho = pipe(22,1).Ho(pipe(22,1).Nx/2+1) - [0:pipe(22,2).Nx/2]' * 2 * pipe(22,2).R * (Qss(10)) ^ 2;

pipe(23,1).Qo = (Qss(11)) * ones(pipe(23,1).Nx/2+1,1);
pipe(23,1).Ho = pipe(21,2).Ho(pipe(21,2).Nx/2+1) - [0:pipe(23,1).Nx/2]' * 2 * pipe(23,1).R * (Qss(11)) ^ 2;
pipe(23,2).Qo = (Qss(11)) * ones(pipe(23,2).Nx/2+1,1);
pipe(23,2).Ho = pipe(23,1).Ho(pipe(23,1).Nx/2+1) - [0:pipe(23,2).Nx/2]' * 2 * pipe(23,2).R * (Qss(11)) ^ 2;