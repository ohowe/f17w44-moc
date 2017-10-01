%seriesOfEvents2

totH = 25*ones(280000,1);
totT = ones(280000,1);

for i=2:size(totT)
    totT(i) = totT(i)+totT(i-1);
end

%noise=randn(280000,1);

%generate measured signal
[meas] = script_MOC3([0 0 0 0 0 0 0],[1 0 0 0 0 0 0]);
totH(1:10000) = meas;
%totH(10001:20000) = resH*ones(10000,1);


[meas2] = script_MOC3([1 0 0 0 0 0 0],[0 0 0 0 0 0 0]);
totH(20001:30000) = meas2;
%totH(30001:40000) = resH*ones(10000,1);

[meas3] = script_MOC3([0 0 0 0 0 0 0],[0 1 0 0 0 0 0]);
totH(40001:50000) = meas3;
%totH(50001:60000) = resH*ones(10000,1);

[meas4] = script_MOC3([0 1 0 0 0 0 0],[0 0 0 0 0 0 0]);
totH(60001:70000) = meas4;
%totH(70001:80000) = resH*ones(10000,1);

[meas5] = script_MOC3([0 0 0 0 0 0 0],[0 0 1 0 0 0 0]);
totH(80001:90000) = meas5;
%totH(90001:100000) = resH*ones(10000,1);

[meas6] = script_MOC3([0 0 1 0 0 0 0],[0 0 0 0 0 0 0]);
totH(100001:110000) = meas6;
%totH(110001:120000) = resH*ones(10000,1);

[meas7] = script_MOC3([0 0 0 0 0 0 0],[0 0 0 1 0 0 0]);
totH(120001:130000) = meas7;
%totH(130001:140000) = resH*ones(10000,1);

[meas8] = script_MOC3([0 0 0 1 0 0 0],[0 0 0 0 0 0 0]);
totH(140001:150000) = meas8;
%totH(150001:160000) = resH*ones(10000,1);

[meas9] = script_MOC3([0 0 0 0 0 0 0],[0 0 0 0 1 0 0]);
totH(160001:170000) = meas9;
%totH(170001:180000) = resH*ones(10000,1);

[meas10] = script_MOC3([0 0 0 0 1 0 0],[0 0 0 0 0 0 0]);
totH(180001:190000) = meas10;
%totH(190001:200000) = resH*ones(10000,1);

[meas11] = script_MOC3([0 0 0 0 0 0 0],[0 0 0 0 0 1 0]);
totH(200001:210000) = meas11;
%totH(210001:220000) = resH*ones(10000,1);

[meas12] = script_MOC3([0 0 0 0 0 1 0],[0 0 0 0 0 0 0]);
totH(220001:230000) = meas12;
%totH(230001:240000) = resH*ones(10000,1);


[meas13] = script_MOC3([0 0 0 0 0 0 0],[0 0 0 0 0 0 1]);
totH(240001:250000) = meas13;
%totH(250001:260000) = resH*ones(10000,1);

[meas14] = script_MOC3([0 0 0 0 0 0 1],[0 0 0 0 0 0 0]);
totH(260001:270000) = meas14;
%totH(10000:20000) = resH*ones(10000,1);

%totH = totH + noise;
plot(totT,totH);