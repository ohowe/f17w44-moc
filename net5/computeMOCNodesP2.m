function [Hn Qna1 Qna2 Qnb] = computeMOCNodesP2(Ha1,Qa1,Ba1,Ra1,Ha2,Qa2,Ba2,Ra2,Hb1,Qb1,Bb1,Rb1)
% Computes the head and flow at the internal nodal points
% TWO UPSTREAM ONE DOWNSTREAM

Cpa1 = Ha1+Qa1*(Ba1-Ra1*abs(Qa1));
Cpa2 = Ha1+Qa2*(Ba2-Ra2*abs(Qa2));
Cmb1 = Hb1-Qb1*(Bb1-Rb1*abs(Qb1));
Hn = ((Cpa1/Ba1)+(Cpa2/Ba2)+(Cmb1/Bb1))/((1/Ba1)+(1/Ba2)+(1/Bb1));
Qna1 = -(Hn - Cpa1)/Ba1;
Qna2 = -(Hn - Cpa2)/Ba2;
Qnb = (Hn - Cmb1)/Bb1;
