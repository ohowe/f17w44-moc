function [Hn Qna Qnb1 Qnb2] = computeMOCNodesP1(Ha,Qa,Ba,Ra,Hb1,Qb1,Bb1,Rb1,Hb2,Qb2,Bb2,Rb2)
% Computes the head and flow at the internal nodal points

Cpa = Ha+Qa*(Ba-Ra*abs(Qa)); %C upstream
Cmb1 = Hb1-Qb1*(Bb1-Rb1*abs(Qb1)); %C downstrem (pipe 1)
Cmb2 = Hb2-Qb2*(Bb2-Rb2*abs(Qb2)); %C downstream (pipe 2)
Hn  = ((Cpa/Ba)+((Cmb1/Bb1)+(Cmb2/Bb2)))/((1/Ba)+(1/Bb1)+(1/Bb2)); %Combining to find head
Qna = -(Hn - Cpa)/Ba;
Qnb1 = (Hn - Cmb1)/Bb1;
Qnb2 = (Hn - Cmb2)/Bb2;