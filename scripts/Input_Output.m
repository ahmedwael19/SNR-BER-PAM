% Random input
f=0;
number_of_bits = 50;
data_randombits= randi([0 3],number_of_bits,1);
pulse_shape = [1,1,1,1];
N=length(pulse_shape); %% length of pulse shape


% PAM signal
data_upsampled = upsample( data_randombits, N);
pulse_shape = pulse_shape/sqrt(N);
Tx = conv(pulse_shape, data_upsampled);
Tx= Tx(1: N*number_of_bits);
matching_filter = fliplr(pulse_shape);


% Adding AWGN to PAM signal
pam_AWGN = awgn(Tx,1,'measured');

output = conv(matching_filter, pam_AWGN);
output= output(1:length(Tx));
output_downsampled = downsample(output,N,3);
BER= 0;

for i= 1:number_of_bits
    output_downsampled(i)=round(output_downsampled(i));
    if output_downsampled(i) ~= data_randombits(i)
        BER= BER+1;
    end
end

    BER= (BER/number_of_bits);

            
i= 1:number_of_bits;
subplot(2,1,1)
stem(i,data_randombits)
title("Input signal")
subplot(2,1,2)
stem(i,output_downsampled)
title("Output signal with SNR = 1")