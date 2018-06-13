%% Random input
f=0;
number_of_bits = 50000;
data_randombits= randi([0 1],number_of_bits,1);
data_randombits2= randi([0 3],number_of_bits,1);
data_randombits3= randi([0 7],number_of_bits,1);
pulse_shape = [1,1,1,1];
N=length(pulse_shape); 
pulse_shape = pulse_shape/sqrt(N);

%% PAM signal
data_upsampled = upsample( data_randombits, N);
data_upsampled2 = upsample( data_randombits2, N);
data_upsampled3 = upsample ( data_randombits3, N);


Tx = conv(pulse_shape, data_upsampled);
Tx2 = conv(pulse_shape, data_upsampled2);
Tx3 = conv(pulse_shape, data_upsampled3);

Tx= Tx(1: N*number_of_bits);
Tx2= Tx2(1: N*number_of_bits);
Tx3= Tx3(1: N*number_of_bits);


%% Matching filter
matching_filter = fliplr(pulse_shape);

for SNR = 0:24
    
    %% Adding AWGN to PAM signal
    pam_AWGN = awgn(Tx,SNR,'measured');
    pam_AWGN2 = awgn(Tx2,SNR,'measured');
    pam_AWGN3 = awgn(Tx3,SNR,'measured');
    
    output = conv(matching_filter, pam_AWGN);
    output2 = conv(matching_filter, pam_AWGN2);
    output3 = conv(matching_filter, pam_AWGN3);
    
    output= output(1:length(Tx));
    output2= output2(1:length(Tx2));
    output3= output3(1:length(Tx3));
    
    output_downsampled = downsample(output,N,3);
    output_downsampled2 = downsample(output2,N,3);
    output_downsampled3 = downsample(output3,N,3);
    
    f=f+1;
    BER(f) = 0;
    BER2(f) = 0;
    BER3(f) = 0;
    
    for i= 1:number_of_bits
        output_downsampled(i)=round(output_downsampled(i));
        output_downsampled2(i)=round(output_downsampled2(i));
        output_downsampled3(i)=round(output_downsampled3(i));
        
        if output_downsampled(i) ~= data_randombits(i)
            BER(f)= BER(f)+1;
        end
        
        if output_downsampled2(i) ~= data_randombits2(i)
            BER2(f)= BER2(f)+1;
        end
        
        if output_downsampled3(i) ~= data_randombits3(i)
            BER3(f)= BER3(f)+1;
        end
    end
    
    BER(f)= (BER(f)/number_of_bits);
    BER2(f)= (BER2(f)/number_of_bits);
    BER3(f)= (BER3(f)/number_of_bits);
    
end

SNR2 = (1:25)';
BER=BER';
BER2=BER2';
BER3=BER3';

semilogy(SNR2,[BER BER2 BER3])

title("Different PAM ")
xlabel('SNR (dB)') % x-axis label
ylabel('BER') % y-axis label
legend('2-PAM','4-PAM','8-PAM')


% % subplot(2,1,1)
% % plot(i,data_randombits)
% % title("Input signal")
% % subplot(2,1,2)
% % plot(i,final_output)
% % % title("Output signal with SNR = 3 ")
% % j= 1:0.1:10;
% % for i = 1:200
% %     k(i)=j(i);
% % end
% % plot(j,BER)
