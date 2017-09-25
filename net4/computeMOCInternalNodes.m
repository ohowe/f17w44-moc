function [Hp Qp] = computeMOCInternalNodes(B,R,Ho,Qo)
% Computes internal nodes

N = length(Ho);
Cp = Ho(1:N-1) + Qo(1:N-1) .* (B - R * abs(Qo(1:N-1)));
Cm = Ho(2:N)   - Qo(2:N)   .* (B - R * abs(Qo(2:N)));
Hp = (Cp + Cm) / 2;
Qp = (Cp - Cm) / (2 * B);
