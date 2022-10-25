function h=fir_lowpass_filter(wp,ws,As)
deltaw=abs(ws-wp);% ���ɴ����
if As<=21
    width=1.8*pi;
    N0=ceil(width/deltaw); % �������˥��ֵ��ѡ����δ�
    N=N0+mod(N0+1,2);  % modȡģ����(�������ȡ������)
    windows=boxcar(N);
    else if As>21&As<=25
        width=6.1*pi;
        N0=ceil(width/deltaw); % �������˥��ֵ��ѡ�����Ǵ�
        N=N0+mod(N0+1,2);   % modȡģ����(�������ȡ������)
        windows=triang(N);
        else if As>25&As<=44
                width=6.2*pi;
                N0=ceil(width/deltaw);% �������˥��ֵ��ѡ��hanning��
                N=N0+mod(N0+1,2);% modȡģ����(�������ȡ������)
                windows=hanning(N);
                else if As>44&As<=53
                        width=6.6*pi;
                        N0=ceil(width/deltaw);% �������˥��ֵ��ѡ�������
                        N=N0+mod(N0+1,2);% modȡģ����(�������ȡ������)
                        windows=hamming(N);
                else
                    width=11*pi;
                    N0=ceil(width/deltaw); % �������˥��ֵ��ѡ��blackman��
                    N=N0+mod(N0+1,2)  % modȡģ����(�������ȡ������)
                    windows=blackman(N);
               end
         end
    end
end
wc=(ws+wp)/(2*pi);  % �����ֹƵ��
if wp<ws
    h=fir1(N-1,wc,windows);
elseif wp>ws
    h=fir1(N-1,wc,'high',windows);% ��Ƴ��˲�����h(n)
end


[H,w]=freqz(h,1,1000,'whole');
H=(H(1:501))';
w=(w(1:501))';
mag=abs(H);
db=20*log10((mag+eps)/max(mag));
pha=angle(H);
n=0:N-1;
% dw=2*pi/1000;
% Rp=-(min(db(1:wp/dw+1)))
% As=-round(max(db(ws/dw+1:501)))
figure
subplot(2,2,1);
stem(n,h);
title('ʵ��������Ӧ');
xlabel('n');
ylabel('h(n)');
subplot(2,2,2)
plot(w(1:501)/pi,db(1:501));
xlabel('Ƶ�ʣ�\pi��');
ylabel('(dB)');
title('����˥��');
subplot(2,2,3);
plot(w(1:501)/pi,mag(1:501));
title('����Ƶ����Ӧ');
xlabel('Ƶ��(��λ:\pi)');
ylabel('H(e^{j\omega})');
subplot(2,2,4);
plot(w(1:501)/pi,pha(1:501));
title('��λƵ����Ӧ');
xlabel('Ƶ��(��λ:\pi)');
ylabel('\phi(\omega)');