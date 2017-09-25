%Library2
% RUNS EVERY INDIVIDUAL SCENARIO AND STORES VALUES
totT = ones(10000,1);
for i=2:size(totT)
    totT(i) = totT(i)+totT(i-1);
end
for k=1:12
    fix(k).event=zeros(10000,1);
end
detHead = zeros(10000,12);
%fixture 1 open
[fix(1).event] = script_MOC5([0 0 0 0 0 0],[1 0 0 0 0 0]);
%fixture 1 close
[fix(2).event] = script_MOC5([1 0 0 0 0 0],[0 0 0 0 0 0]);
%fixture 2 open
[fix(3).event] = script_MOC5([0 0 0 0 0 0],[0 1 0 0 0 0]);
%fixture 2 close
[fix(4).event] = script_MOC5([0 1 0 0 0 0],[0 0 0 0 0 0]);
%fixture 3 open
[fix(5).event] = script_MOC5([0 0 0 0 0 0],[0 0 1 0 0 0]);
%fixture 3 close
[fix(6).event] = script_MOC5([0 0 1 0 0 0],[0 0 0 0 0 0]);
%fixture 4 open
[fix(7).event] = script_MOC5([0 0 0 0 0 0],[0 0 0 1 0 0]);
%fixture 4 close
[fix(8).event] = script_MOC5([0 0 0 1 0 0],[0 0 0 0 0 0]);
%fixture 5 open
[fix(9).event] = script_MOC5([0 0 0 0 0 0],[0 0 0 0 1 0]);
%fixture 5 close
[fix(10).event] = script_MOC5([0 0 0 0 1 0],[0 0 0 0 0 0]);
%fixture 6 open
[fix(11).event] = script_MOC5([0 0 0 0 0 0],[0 0 0 0 0 1]);
%fixture 6 close
[fix(12).event] = script_MOC5([0 0 0 0 0 1],[0 0 0 0 0 0]);



for k=1:16
    for i=1:10000
    if abs(fix(k).event(i+1)-fix(k).event(i))>0.001
        fix(k).event(1:i+1)=[];
        break
    end
    end
end


