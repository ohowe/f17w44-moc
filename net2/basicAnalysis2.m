%basicAnalysis

diff = zeros(10000,1);
ssr = zeros(16,16);

for c=1:16
    cc=c*20000-20000;
    for i=1:16
        for j=1:10000
            diff(j)=(totH(cc+j)-fix(i).event(j))^2;
        end
        ssr(i,c)=sum(diff);
    end
end
ssr
    
        
        
    
    
%for i=1:16
%    for j=1:10000
%        diff(j)=(detHead(j,i)-meas(j))^2;
%    end
%    ssr(i)=sum(diff);
%end
%ssr