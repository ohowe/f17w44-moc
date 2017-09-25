function [Hn Qna1 Qna2 Qnb] = computeMOCNodesP2(Ha1,Qa1,Ba1,Ra1,Ha2,Qa2,Ba2,Ra2,Hb1,Qb1,Bb1,Rb1)
% Computes the head and flow at the internal nodal points
% TWO UPSTREAM ONE DOWNSTREAM

Cpa1 = Ha1+Qa1*Ba1;
Cpa2 = Ha1+Qa2*Ba2;
Cmb1 = Hb1-Qb1*Bb1;
Bpa1 = Ba1-Ra1*abs(Qa1);
Bpa2 = Ba2-Ra2*abs(Qa2);
Bmb1 = Bb1-Rb1*abs(Qb1);
Hn = ((Cpa1/Bpa1)+(Cpa2/Bpa2)+(Cmb1/Bmb1))/((1/Bpa1)+(1/Bpa2)+(1/Bmb1));
Qna1 = -(Hn - Cpa1)/Bpa1;
Qna2 = -(Hn - Cpa2)/Bpa2;
Qnb = (Hn - Cmb1)/Bmb1;
