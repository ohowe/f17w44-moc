%script_openCloseEvent

totH=zeros(50000,2);
totT=zeros(50000,1);

[totH(1:10000,:), totT(1:10000), down]=script_seriesPipeSolver_Open;

zzz=totH(9999,2);
for i=1:40000
    totH(10000+i,2)=zzz;
    totT(10000+i)=(10000+i)/500;
end

[totHc(1:10000,:)]=script_seriesPipeSolver_Close(down);

zzzz=totHc(9999,2);

for j=1:10000
    totH(30000+j,:)=totHc(j,:);
    totH(40000+j,2)=zzzz;
end

plot(totT(1:50000),totH(1:50000,2))
hold off