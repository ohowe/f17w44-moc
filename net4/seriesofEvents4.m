%seriesOfEvents2

totH = 25*ones(320000,1);
totT = ones(320000,1);

for i=2:size(totT)
    totT(i) = totT(i)+totT(i-1);
end

%generate measured signal
[meas] = script_MOC2([0 0 0 0 0 0 0 0 0 0 0],[1 0 0 0 0 0 0 0 0 0 0]);
noise =randn(n);
meas = noise + meas;
totH(1:10000) = meas;

[meas2] = script_MOC2([1 0 0 0 0 0 0 0 0 0 0],[0 0 0 0 0 0 0 0 0 0 0]);
meas2=noise + meas2;
totH(20001:30000) = meas2;

[meas3] = script_MOC2([0 0 0 0 0 0 0 0 0 0 0],[0 1 0 0 0 0 0 0 0 0 0]);
meas3=noise + meas3;
totH(40001:50000) = meas3;

[meas4] = script_MOC2([0 1 0 0 0 0 0 0 0 0 0],[0 0 0 0 0 0 0 0 0 0 0]);
meas4=noise + meas4;
totH(60001:70000) = meas4;

[meas5] = script_MOC2([0 0 0 0 0 0 0 0 0 0 0],[0 0 1 0 0 0 0 0 0 0 0]);
meas5=noise + meas5;
totH(80001:90000) = meas5;

[meas6] = script_MOC2([0 0 1 0 0 0 0 0 0 0 0],[0 0 0 0 0 0 0 0 0 0 0]);
meas6=noise + meas6;
totH(100001:110000) = meas6;

[meas7] = script_MOC2([0 0 0 0 0 0 0 0 0 0 0],[0 0 0 1 0 0 0 0 0 0 0]);
meas7=noise + meas7;
totH(120001:130000) = meas7;

[meas8] = script_MOC2([0 0 0 1 0 0 0 0 0 0 0],[0 0 0 0 0 0 0 0 0 0 0]);
meas8=noise + meas8;
totH(140001:150000) = meas8;

[meas9] = script_MOC2([0 0 0 0 0 0 0 0 0 0 0],[0 0 0 0 1 0 0 0 0 0 0]);
meas9=noise + meas9;
totH(160001:170000) = meas9;

[meas10] = script_MOC2([0 0 0 0 1 0 0 0 0 0 0],[0 0 0 0 0 0 0 0 0 0 0]);
meas10=noise + meas10;
totH(180001:190000) = meas10;

[meas11] = script_MOC2([0 0 0 0 0 0 0 0 0 0 0],[0 0 0 0 0 1 0 0 0 0 0]);
meas11=noise + meas11;
totH(200001:210000) = meas11;

[meas12] = script_MOC2([0 0 0 0 0 1 0 0 0 0 0],[0 0 0 0 0 0 0 0 0 0 0]);
meas12=noise + meas12;
totH(220001:230000) = meas12;


[meas13] = script_MOC2([0 0 0 0 0 0 0 0 0 0 0],[0 0 0 0 0 0 1 0 0 0 0]);
meas13=noise + meas13;
totH(240001:250000) = meas13;

[meas14] = script_MOC2([0 0 0 0 0 0 1 0 0 0 0],[0 0 0 0 0 0 0 0 0 0 0]);
meas14=noise + meas14;
totH(260001:270000) = meas14;

[meas15] = script_MOC2([0 0 0 0 0 0 0 0 0 0 0],[0 0 0 0 0 0 0 1 0 0 0]);
meas15=noise + meas15;
totH(280001:290000) = meas15;

[meas16] = script_MOC2([0 0 0 0 0 0 0 1 0 0 0],[0 0 0 0 0 0 0 0 0 0 0]);
meas16=noise + meas16;
totH(300001:310000) = meas16;

[meas17] = script_MOC2([0 0 0 0 0 0 0 0 0 0 0],[0 0 0 0 0 0 0 0 1 0 0]);
meas17=noise + meas17;
totH(320001:330000) = meas17;

[meas18] = script_MOC2([0 0 0 0 0 0 0 0 1 0 0],[0 0 0 0 0 0 0 0 0 0 0]);
meas18=noise + meas18;
totH(340001:350000) = meas18;

[meas19] = script_MOC2([0 0 0 0 0 0 0 0 0 0 0],[0 0 0 0 0 0 0 0 0 1 0]);
meas19=noise + meas19;
totH(360001:370000) = meas19;

[meas20] = script_MOC2([0 0 0 0 0 0 0 0 0 1 0],[0 0 0 0 0 0 0 0 0 0 0]);
meas20=noise + meas20;
totH(380001:390000) = meas20;

[meas21] = script_MOC2([0 0 0 0 0 0 0 0 0 0 0],[0 0 0 0 0 0 0 0 0 0 1]);
meas21=noise + meas21;
totH(400001:410000) = meas21;

[meas22] = script_MOC2([0 0 0 0 0 0 0 0 0 0 1],[0 0 0 0 0 0 0 0 0 0 0]);
meas22=noise + meas22;
totH(420001:430000) = meas22;




plot(totT,totH);