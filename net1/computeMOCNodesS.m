function [Hn Qna Qnb] = computeMOCNodesS(Ha,Qa,Ba,Ra,Hb,Qb,Bb,Rb)
% Computes the head and flow at the internal nodal points
%ONE UPSTREAM ONE DOWNSTREAM

Cpa = Ha+Qa*(Ba-Ra*abs(Qa));
Cmb = Hb-Qb*(Bb-Rb*abs(Qb));
Hn  = (Bb * Cpa + Ba * Cmb) / (Bb + Ba);
Qna = -(Hn - Cpa)/Ba;
Qnb = (Hn - Cmb)/Bb;
