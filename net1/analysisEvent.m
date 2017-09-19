%Analysis

cc=2;
event=0;
ssr=zeros(6,6);
while cc<120000
    if abs(totH(cc)-totH(cc-1))>0.01
        event=event+1;
        diff = zeros(10000,6);

        %ssr = zeros(6,event);
        %data = totH((cc-1):(cc-2)+10000);
        for i=1:6
            for j=1:size(fix(i).event)
                data = totH((cc) + (10000-fix(i).len):(cc)+10000);
                diff(j,i)=(fix(i).event(j)-data(j))^2;
            end
            ssr(i,event)=sum(diff(:,i));
        end
        cc=cc+10001;
    else
        cc=cc+1;
    end

end
ssr

%diff = zeros(10000,1);
%ssr = zeros(6,1);
%for i=1:6
%    for j=1:10000
%        diff(j)=(detHead(j,i)-meas(j))^2;
%    end
%    ssr(i)=sum(diff);
%end
%ssr