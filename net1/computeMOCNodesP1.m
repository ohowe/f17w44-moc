function [Hn Qna Qnb1 Qnb2] = computeMOCNodesP1(Ha,Qa,Ba,Ra,Hb1,Qb1,Bb1,Rb1,Hb2,Qb2,Bb2,Rb2)
% Computes the head and flow at the internal nodal points
%ONE UPSTREAM TWO DOWNSTREAM

Cpa = Ha+Qa*Ba; %C upstream
Cmb1 = Hb1-Qb1*Bb1; %C downstrem (pipe 1)
Cmb2 = Hb2-Qb2*Bb2; %C downstream (pipe 2)
Bpa = Ba-Ra*abs(Qa);
Bmb1 = Bb1-Ra*abs(Qb1);
Bmb2 = Bb2-Ra*abs(Qb2);
Hn  = ((Cpa/Bpa)+((Cmb1/Bmb1)+(Cmb2/Bmb2)))/((1/Bpa)+(1/Bmb1)+(1/Bmb2)); %Combining to find head
Qna = -(Hn - Cpa)/Bpa;
Qnb1 = (Hn - Cmb1)/Bmb1;
Qnb2 = (Hn - Cmb2)/Bmb2;