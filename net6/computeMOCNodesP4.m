function [Hn Qna1 Qna2 Qnb1 Qnb2] = computeMOCNodesP4(Ha1,Qa1,Ba1,Ra1,Ha2,Qa2,Ba2,Ra2,Hb1,Qb1,Bb1,Rb1,Hb2,Qb2,Bb2,Rb2)
% Computes the head and flow at the internal nodal points
%ONE UPSTREAM TWO DOWNSTREAM

Cpa1 = Ha1+Qa1*(Ba1-Ra1*abs(Qa1)); %C upstream
Cpa2 = Ha2+Qa2*(Ba2-Ra2*abs(Qa2)); %C upstream
Cmb1 = Hb1-Qb1*(Bb1-Rb1*abs(Qb1)); %C downstrem (pipe 1)
Cmb2 = Hb2-Qb2*(Bb2-Rb2*abs(Qb2)); %C downstream (pipe 2)
Hn  = ((Cpa1/Ba1)+(Cpa2/Ba2)+((Cmb1/Bb1)+(Cmb2/Bb2)))/((1/Ba1)+(1/Ba2)+(1/Bb1)+(1/Bb2)); %Combining to find head
Qna1 = -(Hn - Cpa1)/Ba1;
Qna2 = -(Hn - Cpa2)/Ba2;
Qnb1 = (Hn - Cmb1)/Bb1;
Qnb2 = (Hn - Cmb2)/Bb2;