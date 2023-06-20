close all; clear; clc;

SNRdB=0:1:30;
SNR=10.^(SNRdB/10);
Eb=1;

nBits=1e6;
ber_awgn = zeros(1,length(SNR));
ber_rayleigh = zeros(1,length(SNR));
ber_df = zeros(1,length(SNR));

for i=1:length(SNR)
    N0=Eb./SNR(i);
    m = rand(1,nBits)>0.5;
    x = 2*m-1;  
    n = sqrt(.5*N0)*(randn(1,nBits)+1i*randn(1,nBits));
    y_awgn = x + n;
    err_awgn = sum((y_awgn>0)~= m);
    ber_awgn(i) = err_awgn/nBits;

    h = sqrt(.5)*(randn(1,nBits)+1i*randn(1,nBits));
    y_rayleigh = x.*h+n;
    y_decoded=y_rayleigh./h>0;
    err_rayleigh = sum((y_decoded)~= m);
    ber_rayleigh(i) = err_rayleigh/nBits;
    
    n2 = sqrt(.5*N0)*(randn(1,nBits)+1i*randn(1,nBits));
    h2 = sqrt(.5)*(randn(1,nBits)+1i*randn(1,nBits));
    
    y2 = x.*h2 + n2;
    x2 = (y2./h2)>0;

    n3 = sqrt(.5*N0)*(randn(1,nBits)+1i*randn(1,nBits));
    h3 = sqrt(.5)*(randn(1,nBits)+1i*randn(1,nBits));

    y3= x.*h3+n3;
    x3 = (y3./h3)>0;

    vect_error1=(y_decoded)~=m;
    vect_error2=(x2)~=m;
    vect_error3=(x3)~=m;

    vect_error4=false(1,nBits);
    
    for j=1:nBits
        if vect_error1(j)==true
            if vect_error2(j)==true
                vect_error4(j)=true;
            else
                if vect_error3(j)==true
                    vect_error4(j)=true;
                end
            end
        end
    end
    
    err_df=sum(vect_error4 == true);
    ber_df(i)=err_df/nBits;
    
end

semilogy(SNRdB,ber_awgn,".",SNRdB,ber_rayleigh,"+",SNRdB,ber_df,"o")
legend("AWGN","Rayleigh","Decode and Forward")
grid on