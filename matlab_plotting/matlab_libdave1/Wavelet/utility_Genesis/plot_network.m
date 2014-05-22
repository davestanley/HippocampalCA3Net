

% % Plot pyrs
ds = 10;
name = 'pyr2_soma'; smartload;
name = 'pyr7_soma'; smartload;
name = 'pyr12_soma'; smartload;
name = 'pyr17_soma'; smartload;
name = 'pyr22_soma'; smartload;
name = 'pyr27_soma'; smartload;
name = 'pyr32_soma'; smartload;
name = 'pyr37_soma'; smartload;
name = 'pyr42_soma'; smartload;
name = 'pyr47_soma'; smartload;
name = 'pyr48_soma'; smartload;



figure;
m = 0.1; ds = 1;
hold on; s = pyr17_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-0*m),'b',ds);
hold on; s = pyr22_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-1*m),'r',ds);
hold on; s = pyr27_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-2*m),'g',ds);
hold on; s = pyr32_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-3*m),'m',ds);
hold on; s = pyr37_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-4*m),'b',ds);
hold on; s = pyr42_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-5*m),'r',ds);
hold on; s = pyr47_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-6*m),'g',ds);
hold on; s = pyr48_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-7*m),'m',ds);



% % Plot Fb
ds = 10;
name = 'fb0_soma'; smartload;
name = 'fb1_soma'; smartload;
name = 'fb2_soma'; smartload;
name = 'fb3_soma'; smartload;
name = 'fb4_soma'; smartload;
name = 'fb5_soma'; smartload;
name = 'fb6_soma'; smartload;
name = 'fb7_soma'; smartload;
name = 'fb8_soma'; smartload;


figure;
m = 0.1; ds = 1;
hold on; s = fb0_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-0*m),'b',ds);
hold on; s = fb1_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-1*m),'r',ds);
hold on; s = fb2_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-2*m),'g',ds);
hold on; s = fb3_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-3*m),'c',ds);
hold on; s = fb4_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-4*m),'m',ds);
hold on; s = fb5_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-5*m),'b',ds);
hold on; s = fb6_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-6*m),'r',ds);
hold on; s = fb7_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-7*m),'g',ds);
hold on; s = fb8_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-8*m),'c',ds);



% % Plot FF
ds = 10;
name = 'ff0_soma'; smartload;
name = 'ff1_soma'; smartload;
name = 'ff2_soma'; smartload;
name = 'ff3_soma'; smartload;
name = 'ff4_soma'; smartload;
name = 'ff5_soma'; smartload;
name = 'ff6_soma'; smartload;
name = 'ff7_soma'; smartload;
name = 'ff8_soma'; smartload;


figure;
m = 0.1; ds = 1;
hold on; s = ff0_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-0*m),'b',ds);
hold on; s = ff1_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-1*m),'r',ds);
hold on; s = ff2_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-2*m),'g',ds);
hold on; s = ff3_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-3*m),'c',ds);
hold on; s = ff4_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-4*m),'m',ds);
hold on; s = ff5_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-5*m),'b',ds);
hold on; s = ff6_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-6*m),'r',ds);
hold on; s = ff7_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-7*m),'g',ds);
hold on; s = ff8_soma; plotds (s(:,1), s(:,2) - mean(s(:,2)-8*m),'c',ds);


% % Plot extracellular 90
ds = 10;
name = 'e90_2'; smartload;
% name = 'e90_3'; smartload;
name = 'e90_4'; smartload;
% name = 'e90_5'; smartload;
name = 'e90_6'; smartload;
% name = 'e90_7'; smartload;
name = 'e90_8'; smartload;
name = 'e90_9'; smartload;

figure;
m-0.1; ds = 1;
hold on; s = e90_2; plotds (s(:,1), s(:,2) - mean(s(:,2)-0*m),'b',ds);
hold on; s = e90_4; plotds (s(:,1), s(:,2) - mean(s(:,2)-1*m),'r',ds);
hold on; s = e90_6; plotds (s(:,1), s(:,2) - mean(s(:,2)-2*m),'g',ds);
hold on; s = e90_8; plotds (s(:,1), s(:,2) - mean(s(:,2)-3*m),'c',ds);
hold on; s = e90_9; plotds (s(:,1), s(:,2) - mean(s(:,2)-4*m),'m',ds);






% % Plot extracellular 90
ds = 10;
name = 'e180_0'; smartload;
name = 'e180_2'; smartload;
name = 'e180_4'; smartload;
name = 'e180_6'; smartload;
name = 'e180_8'; smartload;
name = 'e180_10'; smartload;
name = 'e180_12'; smartload;


figure;
m-0.1; ds = 1;
hold on; s = e180_0; plotds (s(:,1), s(:,2) - mean(s(:,2)-0*m),'b',ds);
hold on; s = e180_2; plotds (s(:,1), s(:,2) - mean(s(:,2)-1*m),'r',ds);
hold on; s = e180_4; plotds (s(:,1), s(:,2) - mean(s(:,2)-2*m),'g',ds);
hold on; s = e180_6; plotds (s(:,1), s(:,2) - mean(s(:,2)-3*m),'c',ds);
hold on; s = e180_8; plotds (s(:,1), s(:,2) - mean(s(:,2)-4*m),'m',ds);
hold on; s = e180_10; plotds (s(:,1), s(:,2) - mean(s(:,2)-5*m),'b',ds);
hold on; s = e180_12; plotds (s(:,1), s(:,2) - mean(s(:,2)-6*m),'r',ds);





