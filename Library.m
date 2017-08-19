%Library
% RUNS EVERY INDIVIDUAL SCENARIO AND STORES VALUES
totT = ones(10000,1);
for i=2:size(totT)
    totT(i) = totT(i)+totT(i-1);
end

detHead = zeros(10000,6);
%fixture 1 open
[detHead(:,1)] = script_MOC([0 0 0],[1 0 0]);
%fixture 1 close
[detHead(:,2)] = script_MOC([1 0 0],[0 0 0]);
%fixture 2 open
[detHead(:,3)] = script_MOC([0 0 0],[0 1 0]);
%fixture 2 close
[detHead(:,4)] = script_MOC([0 1 0],[0 0 0]);
%fixture 3 open
[detHead(:,5)] = script_MOC([0 0 0],[0 0 1]);
%fixture 3 close
[detHead(:,6)] = script_MOC([0 0 1],[0 0 0]);

%plot(totT,detHead(:,2));
%hold on
%plot(totT,detHead(:,2));
%plot(totT,detHead(:,3));
%plot(totT,detHead(:,4));
%plot(totT,detHead(:,5));
%plot(totT,detHead(:,6));
%hold off

%[meas] = script_MOC([0 0 0],[0 1 0]);
%noise = wgn(10000,1,0);
%meas = noise + meas;

%diff = zeros(10000,1);
%ssr = zeros(6,1);
%for i=1:6
%    for j=1:10000
%        diff(j)=(detHead(j,i)-meas(j))^2;
%    end
%    ssr(i)=sum(diff);
%end
%plot(totT,detHead(:,3));
%hold on
%plot(totT,meas);