function [Hn Qn] = computeMOCNodesP2(Ha1,Qa1,Ba1,Ra1,Ha2,Qa2,Ba2,Ra2,Hb,Qb,Bb,Rb)
% Computes the head and flow at the internal nodal points

Cpa1 = Ha1+Qa1*(Ba1-Ra1*abs(Qa1));
Cpa2 = Ha1+Qa2*(Ba2-Ra2*abs(Qa2));
Cmb = Hb-Qb*(Bb-Rb*abs(Qb));
Hn = (((Cpa1/Ba1)+(Cpa2/Ba2))+(Cmb/Bb))/((1/Ba1)+(1/Ba2)+(1/Bb));
Qn = (Cpa1+Cpa2-Cmb)/(Ba1+Ba2+Bb);
%Cpa = Ha+Qa*(Ba-Ra*abs(Qa)); %C upstream
%Cmb1 = Hb1-Qb1*(Bb1-Rb1*abs(Qb1)); %C downstrem (pipe 1)
%Cmb2 = Hb2-Qb2*(Bb2-Rb2*abs(Qb2)); %C downstream (pipe 2)
%Hn  = ((Cpa/Ba)+((Cmb1/Bb1)+(Cmb2/Bb2)))/((1/Ba)+(1/Bb1)+(1/Bb2)); %Combining to find head
%Qn  = (Cpa - Cmb1 - Cmb2) / (Bb1 + Bb2 + Ba); %Combining to find flow