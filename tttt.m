%node(1).LambdaU = [1 4 6 8];
%node(1).LambdaD = [3 2 7];

%for i = 1:length(node)
% Construct US & DS vectors, H, Q, B, R
%QU = zeros(length(node(i).LambdaU),1);
%for j = 1:length(node(i).LambdaU);
%    QU(j) = pipe(node(i).LambdaU(j)).Q(2);
%end
%end




node(1).idU = [1];
node(1).idD = [2 3];

k = 1; j = 1;
for cct = 1:size(node(idN).idU)
    node(1).Hu = pipe(node(idN).idU(1)

    Hu = pipe(k,j+1).Hi(pipe(k,j+1).Nx/2); Qu = pipe(k,j+1).Qi(pipe(k,j+1).Nx/2); %Upstream head and flow
    Bu = pipe(k,j+1).B;                Ru = pipe(k,j+1).R; %Upstream B and R
    Hd1 = pipe(k+1,j).Hi(1);          Qd1 = pipe(k+1,j).Qi(1); %Downstream pipe 1 properties at junction
    Bd1 = pipe(k+1,j).B;              Rd1 = pipe(k+1,j).R;
    Hd2 = pipe(k+2,j).Hi(1);          Qd2 = pipe(k+2,j).Qi(1); %Downstream pipe 2 properties at junction (error here; I dont know what the problem is)
    Bd2 = pipe(k+2,j).B;              Rd2 = pipe(k+2,j).R;
        
    [Hn Qnd Qnu1 Qnu2] = computeMOCNodesP1(Hu,Qu,Bu,Ru,Hd1,Qd1,Bd1,Rd1,Hd2,Qd2,Bd2,Rd2); %computes head and flow at junction 
    
        function [Hn Qna Qnb1 Qnb2] = computeMOCNodesP1(Ha,Qa,Ba,Ra,Hb1,Qb1,Bb1,Rb1,Hb2,Qb2,Bb2,Rb2)
        % Computes the head and flow at the internal nodal points

        Cpa = Ha+Qa*(Ba-Ra*abs(Qa)); %C upstream
        Cmb1 = Hb1-Qb1*(Bb1-Rb1*abs(Qb1)); %C downstrem (pipe 1)
        Cmb2 = Hb2-Qb2*(Bb2-Rb2*abs(Qb2)); %C downstream (pipe 2)
        Hn  = ((Cpa/Ba)+((Cmb1/Bb1)+(Cmb2/Bb2)))/((1/Ba)+(1/Bb1)+(1/Bb2)); %Combining to find head
        Qna = -(Hn - Cpa)/Ba;
        Qnb1 = (Hn - Cmb1)/Bb1;
        Qnb2 = (Hn - Cmb2)/Bb2;
    
    
    
    pipe(k,j+1).HoD   = Hn; 
    pipe(k,j+1).QoD   = Qnd;
    pipe(k+1,j).HoU = Hn;
    pipe(k+1,j).QoU = Qnu1;
    pipe(k+2,j).HoU = Hn;
    pipe(k+2,j).QoU = Qnu2;