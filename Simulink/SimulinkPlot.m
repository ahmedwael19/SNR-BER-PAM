SNR = (0:2:12)';
BER2 = [ 0.072 ,0.04 ,0.01,0.002,0,0,0];

BER4= [0.536,0.46,0.382,0.286,0.192,0.105,0.05];

BER8 = [0.785,0.75,0.698,0.633,0.563,0.483,0.384];
BER2=BER2'
BER4=BER4'
BER8=BER8'

semilogy(SNR,[BER2 BER4 BER8  ])
legend('2-PAM','4-PAM','8-PAM')
xlabel('SNR (log)')
ylabel ('BER ')
title('Simulink 6 samples')

