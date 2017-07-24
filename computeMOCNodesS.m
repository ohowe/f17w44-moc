function [Hn Qn] = computeMOCNodesS(Ha,Qa,Ba,Ra,Hb,Qb,Bb,Rb)
% Computes the head and flow at the internal nodal points

Cpa = Ha+Qa*(Ba-Ra*abs(Qa));
Cmb = Hb-Qb*(Bb-Rb*abs(Qb));
Hn  = (Bb * Cpa + Ba * Cmb) / (Bb + Ba);
Qn  = (Cpa - Cmb) / (Bb + Ba); 