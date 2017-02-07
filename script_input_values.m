% script_input_values

% Other inputs HL = 0
g = 9.81;
rho = 1000;
Nt = 10000;
HoSS = 50;
HL = 0;

% Healthy sections of pipe (SI units)
c = 1000;
dt = 0.001;
dx = c * dt;
N1 = 40; L1 = N1 * dx;
N2 = 40;  L2 = N2 * dx;
N3 = 40; L3 = N3 * dx;
D = 0.2;
B = c / g / (pi*D^2/4);

% Non healthy sections
c1 = 700; dD1x = c1 * dt; ND1 = 2; LD1 = ND1 * dD1x;
c2 = 700; dD2x = c2 * dt; ND2 = 2;  LD2 = ND2 * dD2x;
D1 = 0.01; B1 = c1 / g / (pi*D1^2/4);
D2 = 0.15; B2 = c2 / g / (pi*D2^2/4);

eta = 1/1000;

% States for pipes
H1o = zeros(N1/2+1,1); H2o = zeros(N2/2+1,1);  H3o = zeros(N3/2+1,1);
H1i = zeros(N1/2,1);   H2i = zeros(N2/2,1);    H3i = zeros(N3/2,1); 
Q1o = eta* ones(N1/2+1,1); Q2o = eta* ones(N2/2+1,1);  Q3o = eta* ones(N3/2+1,1);
Q1i = zeros(N1/2,1);   Q2i = zeros(N2/2,1);    Q3i = zeros(N3/2,1); 

% States for damaged sections
HD1o = zeros(N1/2+1,1); HD2o = zeros(N2/2+1,1);
HD1i = zeros(N1/2,1);   HD2i = zeros(N2/2,1);  
QD1o = eta* ones(N1/2+1,1); QD2o = eta* ones(N2/2+1,1);
QD1i = zeros(N1/2,1);   QD2i = zeros(N2/2,1);  

H1 = zeros(Nt,1);
Q1 = zeros(Nt,1);
H2 = zeros(Nt,1);
Q2 = zeros(Nt,1);

for i = 1: Nt
    
   H1(i) = H1o(N1/2);
   Q1(i) = Q1o(N1/2); 
   
   H2(i) = H3o(N3/2+1);
   Q2(i) = Q3o(N3/2+1); 
    
% Computing internal node states for pipe 1
% Inner nodes
Qa = Q1o(1:N1/2);   Ha = H1o(1:N1/2);
Qb = Q1o(2:N1/2+1); Hb = H1o(2:N1/2+1);
Q1i = -1/(2*B)*(-B*Qa-Ha+B*Qb-Hb);
H1i = -1/(2*B)*(-B*(B*Qa+Ha)+B*(B*Qb-Hb));
% Outer Nodes
Qa = Q1i(1:N1/2-1); Ha = H1i(1:N1/2-1);
Qb = Q1i(2:N1/2);   Hb = H1i(2:N1/2);
Q1oi = -1/(2*B)*(-B*Qa-Ha+B*Qb-Hb);
H1oi = -1/(2*B)*(-B*(B*Qa+Ha)+B*(B*Qb-Hb));
% Computing inner states for pipe 2
% Inner nodes
Qa = Q2o(1:N2/2);   Ha = H2o(1:N2/2);
Qb = Q2o(2:N2/2+1); Hb = H2o(2:N2/2+1);
Q2i = -1/(2*B)*(-B*Qa-Ha+B*Qb-Hb);
H2i = -1/(2*B)*(-B*(B*Qa+Ha)+B*(B*Qb-Hb));
% Outer Nodes
Qa = Q2i(1:N2/2-1); Ha = H2i(1:N2/2-1);
Qb = Q2i(2:N2/2);   Hb = H2i(2:N2/2);
Q2oi = -1/(2*B)*(-B*Qa-Ha+B*Qb-Hb);
H2oi = -1/(2*B)*(-B*(B*Qa+Ha)+B*(B*Qb-Hb));
% Computing inner states for pipe 3
%Inner nodes
Qa = Q3o(1:N3/2);   Ha = H3o(1:N3/2);
Qb = Q3o(2:N3/2+1); Hb = H3o(2:N3/2+1);
Q3i = -1/(2*B)*(-B*Qa-Ha+B*Qb-Hb);
H3i = -1/(2*B)*(-B*(B*Qa+Ha)+B*(B*Qb-Hb));
% Outer Nodes
Qa = Q3i(1:N3/2-1); Ha = H3i(1:N3/2-1);
Qb = Q3i(2:N3/2);   Hb = H3i(2:N3/2);
Q3oi = -1/(2*B)*(-B*Qa-Ha+B*Qb-Hb);
H3oi = -1/(2*B)*(-B*(B*Qa+Ha)+B*(B*Qb-Hb));

% Computing internal node states for damaged sections 1
% Inner nodes
Qa = QD1o(1:ND1/2);   Ha = HD1o(1:ND1/2);
Qb = QD1o(2:ND1/2+1); Hb = HD1o(2:ND1/2+1);
QD1i = -1/(2*B)*(-B*Qa-Ha+B*Qb-Hb);
HD1i = -1/(2*B)*(-B*(B*Qa+Ha)+B*(B*Qb-Hb));
% Outer Nodes
Qa = QD1i(1:ND1/2-1); Ha = HD1i(1:ND1/2-1);
Qb = QD1i(2:ND1/2);   Hb = HD1i(2:ND1/2);
QD1oi = -1/(2*B)*(-B*Qa-Ha+B*Qb-Hb);
HD1oi = -1/(2*B)*(-B*(B*Qa+Ha)+B*(B*Qb-Hb));
% Dammafed section 2
% Inner nodes
Qa = QD2o(1:ND2/2);   Ha = HD2o(1:ND2/2);
Qb = QD2o(2:ND2/2+1); Hb = HD2o(2:ND2/2+1);
QD2i = -1/(2*B)*(-B*Qa-Ha+B*Qb-Hb);
HD2i = -1/(2*B)*(-B*(B*Qa+Ha)+B*(B*Qb-Hb));
% Outer Nodes
Qa = QD2i(1:ND2/2-1); Ha = HD2i(1:ND2/2-1);
Qb = QD2i(2:ND2/2);   Hb = HD2i(2:ND2/2);
QD2oi = -1/(2*B)*(-B*Qa-Ha+B*Qb-Hb);
HD2oi = -1/(2*B)*(-B*(B*Qa+Ha)+B*(B*Qb-Hb));

% Computing upstream BC for pipe 1
H1oUBC = 1; ... rand('Normal',0,1);
Q1oUBC = (H1oUBC-H1i(1))/B + Q1i(1);
% COmputing downstream BC for pipe 1 (it connects to th deteriorated section1)
Qa = Q1i(N1/2); Ha = H1i(N1/2); Ba = B; Qb = QD1i(1); Hb = HD1i(1); Bb = B1;
Q1oDBC = -1/(Ba+Bb)*(-Ba*Qa-Ha+Bb*Qb-Hb);
H1oDBC = -1/(Ba+Bb)*(-Bb*(Ba*Qa+Ha)+Ba*(Bb*Qb-Hb));

% computing USBC for pipe 2
Qa = QD1i(ND1/2); Ha = HD1i(ND1/2); Ba = B1; Qb = Q2i(1); Hb = H2i(1); Bb = B;
Q2oUBC = -1/(Ba+Bb)*(-Ba*Qa-Ha+Bb*Qb-Hb);
H2oUBC = -1/(Ba+Bb)*(-Bb*(Ba*Qa+Ha)+Ba*(Bb*Qb-Hb));
% computing DSBC for pipe 2
Qa = Q2i(N2/2); Ha = H2i(N2/2); Ba = B; Qb = QD2i(1); Hb = HD2i(1); Bb = B2;
Q2oDBC = -1/(Ba+Bb)*(-Ba*Qa-Ha+Bb*Qb-Hb);
H2oDBC = -1/(Ba+Bb)*(-Bb*(Ba*Qa+Ha)+Ba*(Bb*Qb-Hb));

% computing USBC for pipe 3
Qa = QD2i(ND2/2); Ha = HD2i(ND2/2); Ba = B2; Qb = Q3i(1); Hb = H3i(1); Bb = B;
Q3oUBC = -1/(Ba+Bb)*(-Ba*Qa-Ha+Bb*Qb-Hb);
H3oUBC = -1/(Ba+Bb)*(-Bb*(Ba*Qa+Ha)+Ba*(Bb*Qb-Hb));
% computing DSBC for pipe 2
%H3oDBC = HL;
%Q3oDBC = -(HL-H3i(1))/B + Q3i(1);
Q3oDBC = 0;
H3oDBC = H3i(1) + B * Q3i(1);

% Constructing state vectors
Q1o = [Q1oUBC ; Q1oi ; Q1oDBC];
H1o = [H1oUBC ; H1oi ; H1oDBC];
Q2o = [Q2oUBC ; Q2oi ; Q2oDBC];
H2o = [H2oUBC ; H2oi ; H2oDBC];
Q3o = [Q3oUBC ; Q3oi ; Q3oDBC];
H3o = [H3oUBC ; H3oi ; H3oDBC];

% For damaged sections
QD1o = [Q1oDBC; QD1oi ; Q2oUBC];
HD1o = [H1oDBC; HD1oi ; H2oUBC];
QD2o = [Q2oDBC; QD2oi ; Q3oUBC];
HD2o = [H2oDBC; HD2oi ; H3oUBC];

if i == 267
    g = g;
end

end
