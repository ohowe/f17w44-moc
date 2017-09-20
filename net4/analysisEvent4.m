%Analysis
%sSEND THROUGH JUNCTION NOTES!!!!!!
cc=2;
event=0;
ssr=zeros(22,22);
while cc<320000
    if abs(totH(cc)-totH(cc-1))>0.01
        event=event+1;
        diff = zeros(10000,1);

        %ssr = zeros(6,event);
        %data = totH((cc-1):(cc-2)+10000);
        for i=1:22
            for j=1:size(fix(i).event)
                data = totH((cc-1):(cc-1)+size(fix(i).event));
                diff(j)=(fix(i).event(j)-data(j))^2;
            end
            ssr(i,event)=sum(diff);
        end
        cc=cc+10000;
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