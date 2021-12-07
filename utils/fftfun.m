function [fq,my,py] = fftfun(y,Fs)
y=y-mean(y);%sin(-10*pi:.1:10*pi);
if isempty(Fs)
    Fs = 2;
end
NFFT = 2^nextpow2(length(y)); %pow2(nextpow2(length(y)));%length(y);
Y = fft(y,NFFT);
fq = Fs/2*linspace(0,1,NFFT/2+1);

my = abs(Y);        % Magnitude of the FFT
py = unwrap(angle(Y));  % Phase of the FFT
figure(10);hold all
plot(fq,2*abs(my(1:(NFFT/2+1))))