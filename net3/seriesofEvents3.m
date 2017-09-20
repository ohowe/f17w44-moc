%seriesOfEvents2

totH = 25*ones(280000,1);
totT = ones(280000,1);

for i=2:size(totT)
    totT(i) = totT(i)+totT(i-1);
end

%generate measured signal
[meas] = script_MOC3([0 0 0 0 0 0 0],[1 0 0 0 0 0 0]);
noise =0;%randn(n);
meas = noise + meas;
totH(1:10000) = meas;

[meas2] = script_MOC3([1 0 0 0 0 0 0],[0 0 0 0 0 0 0]);
meas2=noise + meas2;
totH(20001:30000) = meas2;

[meas3] = script_MOC3([0 0 0 0 0 0 0],[0 1 0 0 0 0 0]);
meas3=noise + meas3;
totH(40001:50000) = meas3;

[meas4] = script_MOC3([0 1 0 0 0 0 0],[0 0 0 0 0 0 0]);
meas4=noise + meas4;
totH(60001:70000) = meas4;

[meas5] = script_MOC3([0 0 0 0 0 0 0],[0 0 1 0 0 0 0]);
meas5=noise + meas5;
totH(80001:90000) = meas5;

[meas6] = script_MOC3([0 0 1 0 0 0 0],[0 0 0 0 0 0 0]);
meas6=noise + meas6;
totH(100001:110000) = meas6;

[meas7] = script_MOC3([0 0 0 0 0 0 0],[0 0 0 1 0 0 0]);
meas7=noise + meas7;
totH(120001:130000) = meas7;

[meas8] = script_MOC3([0 0 0 1 0 0 0],[0 0 0 0 0 0 0]);
meas8=noise + meas8;
totH(140001:150000) = meas8;

[meas9] = script_MOC3([0 0 0 0 0 0 0],[0 0 0 0 1 0 0]);
meas9=noise + meas9;
totH(160001:170000) = meas9;

[meas10] = script_MOC3([0 0 0 0 1 0 0],[0 0 0 0 0 0 0]);
meas10=noise + meas10;
totH(180001:190000) = meas10;

[meas11] = script_MOC3([0 0 0 0 0 0 0],[0 0 0 0 0 1 0]);
meas11=noise + meas11;
totH(200001:210000) = meas11;

[meas12] = script_MOC3([0 0 0 0 0 1 0],[0 0 0 0 0 0 0]);
meas12=noise + meas12;
totH(220001:230000) = meas12;


[meas13] = script_MOC3([0 0 0 0 0 0 0],[0 0 0 0 0 0 1]);
meas13=noise + meas13;
totH(240001:250000) = meas13;

[meas14] = script_MOC3([0 0 0 0 0 0 1],[0 0 0 0 0 0 0]);
meas14=noise + meas14;
totH(260001:270000) = meas14;


plot(totT,totH);