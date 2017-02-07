% script_waveAnalysis
% uses omega, dt from script_Analysis

% Frictionless transfer functions
mDt = 5 * dt;
ro  = pipe(1).f * Qss / pipe(1).A / pipe(1).D;
s  = sqrt(-1) * omega;
Nf = floor(N/2)+1;
for i = 1:N-Nf
    s(Nf+i) = conj(s(Nf-i));
end
Go = s * mDt;
Gs = mDt * sqrt(s .* (s + ro));

H1o = 1 ./ (1 - exp(-Go));
H2o = -exp(-Go) .* H1o;

H1s = 1 ./ (1 - exp(-Gs));
H2s = -exp(-Gs) .* H1s;

SAA =    H1s .* conj(H1s) .* S11 ... 
       + H1s .* conj(H2s) .* S12 ...
       + H2s .* conj(H1s) .* S21 ...
       + H2s .* conj(H2s) .* S22; SAA(1) = 0; SAA(N) = 0;

SBA =    H2s .* conj(H1s) .* S11 ... 
       + H2s .* conj(H2s) .* S12 ...
       + H1s .* conj(H1s) .* S21 ...
       + H1s .* conj(H2s) .* S22; SBA(1) = 0; SBA(N) = 0;
   
SR = SBA ./ SAA; SR(1) = 0; SR(N) = 0;
% for i = 1:N-Nf
%     SAA(Nf+i) = conj(SAA(Nf-i));
%     SBA(Nf+i) = conj(SBA(Nf-i));
% end
   
RAA = ifft(SAA);
RBA = ifft(SBA);
TR  = ifft(SR);

% H = SBA ./ SAA ./ s;   
% 
% dw = omega(2) - omega(1);
% 
% fs = 0;
% for i = 1:Nt / 10;
%     t = (i - 1) * dt;
%     f = 0;
%     for j = 1:length(omega)
%         f = H(j) * exp(s*t);
%     end
%     f = dw / pi * real(f);
%     fs = fs + dt * f;
% end