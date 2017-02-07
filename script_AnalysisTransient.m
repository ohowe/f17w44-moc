% script_AnalysisTransient
datTemp = zeros(Nt,2);
datTemp(:,1) = datH(:,1) - mean(datH(:,1));
datTemp(:,2) = datH(:,2) - mean(datH(:,2));

% Reoranising Rxy such that Rxy(1) corresponds to lag 0;
N = Nt;
dt = 2*Dt;
t = dt * [0:N-1]';

% Computing spectrums
datfft = fft(datTemp);
Nf = floor(N/2)+1;
omega = 2 * pi * [0:N-1]' / N / dt;

% Transfer functions
% Determining s to align with the fourier frequencies
s  = sqrt(-1) * omega;
for i = 1:N-Nf
    s(Nf+i) = conj(s(Nf-i));
end

mDt = 5 * dt;
ro  = pipe(1).f * Qss / pipe(1).A / pipe(1).D;

Go = s * mDt;
Gs = mDt * sqrt(s .* (s + ro));

H1o = 1 ./ (1 - exp(-Go)); H1o(1) = 0;
H2o = -exp(-Go) .* H1o;

H1s = 1 ./ (1 - exp(-Gs)); H1s(1) = 0;
H2s = -exp(-Gs) .* H1s;

pA = H1s.*datfft(:,1)+H2s.*datfft(:,2);
pB = H1s.*datfft(:,2)+H2s.*datfft(:,1);
rBA = pB ./ pA; rBA(1) = 0;
rBAs = pB ./ pA ./ s; rBAs(1) = 0;
ipA = ifft(pA); 
ipB = ifft(pB); 
irBA  = ifft(rBA); 
irBAs = ifft(rBAs); 

ifftH1o = ifft(H1o.*datfft(:,1)+H2o.*datfft(:,2));
ifftH2o = ifft(H2o.*datfft(:,1));
ifftH1s = ifft(H1s.*datfft(:,1));
ifftH2s = ifft(H2s.*datfft(:,1));

ipAt = zeros(Nt,1);
for i = 6:Nt
    ipAt(i) = datTemp(i,1) + ipAt(i-5) - datTemp(i-5,2);
end