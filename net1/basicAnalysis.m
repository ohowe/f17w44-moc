%basicAnalysis

diff = zeros(10000,1);
ssr = zeros(6,6);

for c=1:6
    cc=c*20000-20000;
    for i=1:6
        for j=1:10000
            diff(j)=(totH(cc+j)-fix(i).event(j))^2;
        end
        ssr(i,c)=sum(diff);
    end
end
ssr
    