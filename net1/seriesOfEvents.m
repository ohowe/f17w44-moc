%seriesOfEvents

totH = 25*ones(120000,1);
totT = ones(120000,1);

for i=2:size(totT)
    totT(i) = totT(i)+totT(i-1);
end

%generate measured signal
[meas] = script_MOC([0 0 0],[1 0 0]);
noise = 1*rand(10000,1);
meas = noise + meas;
totH(1:10000) = meas;

[meas2] = script_MOC([1 0 0],[0 0 0]);
meas2=noise + meas2;
totH(20001:30000) = meas2;

[meas3] = script_MOC([0 0 0],[0 1 0]);
meas3=noise + meas3;
totH(40001:50000) = meas3;

[meas4] = script_MOC([0 1 0],[0 0 0]);
meas4=noise + meas4;
totH(60001:70000) = meas4;

[meas5] = script_MOC([0 0 0],[0 0 1]);
meas5=noise + meas5;
totH(80001:90000) = meas5;

[meas6] = script_MOC([0 0 1],[0 0 0]);
meas6=noise + meas6;
totH(100001:110000) = meas6;

plot(totT,totH);