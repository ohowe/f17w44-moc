% script_Analysis
datTemp = zeros(Nt-Nt/5,2);
datTemp(:,1) = datH(Nt/5+1:Nt,1) - mean(datH(Nt/5+1:Nt,1));
datTemp(:,2) = datH(Nt/5+1:Nt,2) - mean(datH(Nt/5+1:Nt,2));

[R11raw lags] = xcorr(datTemp(:,1),'biased');
R12raw = xcorr(datTemp(:,1),datTemp(:,2),'biased');
R21raw = xcorr(datTemp(:,2),datTemp(:,1),'biased');
R22raw = xcorr(datTemp(:,2),'biased');
N = length(lags);

% Reoranising Rxy such that Rxy(1) corresponds to lag 0;
% [temp I] = min(abs(lags));
% N = min(I, length(R11raw) - I + 1);
% R11 = zeros(N,1); R12 = zeros(N,1); R21 = zeros(N,1); R22 = zeros(N,1);
% R11(1) = R11raw(I); 
% R12(1) = R12raw(I); 
% R21(1) = R21raw(I); 
% R22(1) = R22raw(I);
% for i = 1:N-1
%     R11(i+1) = 0.5 * (R11raw(I-i) + R11raw(I+i));
%     R12(i+1) = 0.5 * (R12raw(I-i) + R12raw(I+i));
%     R21(i+1) = 0.5 * (R21raw(I-i) + R21raw(I+i));
%     R22(i+1) = 0.5 * (R22raw(I-i) + R22raw(I+i));
% end
% clear R11raw R12raw R21raw R22raw lags
 dt = 2*Dt;
% lags = dt * [0:length(R11)-1]';

%Computing power spectrums
S11 = fft(R11raw);
S12 = fft(R12raw);
S21 = fft(R21raw);
S22 = fft(R22raw);
Nf = floor(N/2)+1;
% S11 = 2 * real(S11raw(1:Nf)) * dt;
% S12 = 2 * real(S12raw(1:Nf)) * dt;
% S21 = 2 * real(S21raw(1:Nf)) * dt;
% S22 = 2 * real(S22raw(1:Nf)) * dt;
% clear S11raw S12raw S21raw S22raw
omega = 2 * pi * [0:N-1]' / N / dt;