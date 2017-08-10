%seriesOfEvents

totH = 25*ones(100000,1);
totT = ones(100000,1);

for i=2:size(totT)
    totT(i) = totT(i)+totT(i-1);
end

diH = 25*ones(3904,1);

[totH(10001:40000,1), headkeep, ddH] = script_MOC(diH,[0 0 0],[0 0 1]);
totH(40001:100000,1)= headkeep*ones(60000,1);
diH = ddH;

[totH(50001:80000,1), headkeep, ddH] = script_MOC(diH,[0 0 0],[0 0 0]);
totH(80001:100000,1)= headkeep*ones(20000,1);


plot(totT,totH);
hold on