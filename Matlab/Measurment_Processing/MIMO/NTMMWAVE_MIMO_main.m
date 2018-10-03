%%
clear all
close all
%---------------------------------------------------
%---------------------------------------------------
%  ��ͨ����1.8GHz MIMO��������
%
%---------------------------------------------------
%---------------------------------------------------



%-----------------generate m sequence-----------------------------------
g = 529;     % G = 1000010001
state = 511;% state=111111111
L = 511;
mq = mgen(g,state,L);
N_sample=2;
Tc = 20e-9;
dt = Tc/N_sample;
gt = ones(1,N_sample);
st=sigexpand(2*mq(1:511)-1,N_sample);
s=conv(st,gt);
st=s(1:length(st));%m sequence
%-----------end---------------------------------------------------------

NN=4096;%FFT����
hwait=waitbar(0,'���ȴ�>>>>>>>>');%������

% foldername=dir('F:\MMWAVE\NTMMWAVE\MIMO');% ���ڵó��������ļ��е�����
% steps=length(foldername)-2;%������

% for index=1:length(foldername)-2
% mydir=strcat('F:\MMWAVE\NTMMWAVE\MIMO\',foldername(index+2).name,'\');% ��ȡ���ļ��е����ֺ�·��
mydir='I:\�½��ļ���\';
temp=dir([mydir,'*.csv']);
num_temp=length(temp);
steps=num_temp;

% SNR=10;%������Ϊ10dB



for z=1:num_temp  %ѭ����ȡ����
filename=[mydir,temp(z).name];
data=csvread(filename,9,0);


I=data(1:2:end,1);%I·����
Q=data(2:2:end,1);%Q·����
% I=I.';
% Q=Q.';
%---------------------end-----------------------------

%----I·��Q·�źŷֱ���m�������أ�ƽ�����͵õ�PDP---------
hti=conv(I,st(end:-1:1))/(511*2); %I·�ŵ��弤��Ӧ
htq=conv(Q,st(end:-1:1))/(511*2); %Q·�ŵ��弤��Ӧ
ht=sqrt(hti.*hti+htq.*htq);%�ܵ��ŵ��弤��Ӧ
pdp=10*log10(ht.*ht); %PDP,��λdBm
pdp_L=ht.*ht;  %PDP����ֵ

%-----------end------------------------------------------------------




%--------�ҵ�PDP������ֵ,�����ҵ���һ��PDP�ķ�ֵ��Ȼ��ȥ����һ��PDP-----
[pdpmax, m]=max(pdp);
 n=mod(m,1022);
 n=n+1022;

hti=hti(n-50:end);
htq=htq(n-50:end);
ht=ht(n-50:end);
pdp=pdp(n-50:end);
pdp_L=pdp_L(n-50:end);
%-------------------------end----------------------------------------



%----------------����ѡȡ����ȡ�ྶ------------------------------------

%���޵�ȡֵ
N=2050;%2050������
Lh=1022*N;
for kk=1:Lh
    [pdpmax(fix((kk-1)/1022)+1), m(fix((kk-1)/1022)+1)]=max(pdp((fix((kk-1)/1022)*1022+1):(fix((kk-1)/1022)+1)*1022));%�ҵ�ÿ֡���źŵ�����ֵ��ÿ֡������ֵ��λ��
end

for k=1:N
    M(k)=m(k)+1022*(k-1);%MΪÿһ֡����������ֵ��λ��
end

for k=1:N
    nse(k)=mean(pdp_L(M(k)+500:M(k)+900));%��k��PDP�����޶ྶ�źŲ��ֵ������ľ�ֵ
    thre(k)=10*log10(nse(k))+5;%   5dB SNR����
end
%-------------end---------------------------------------------------------
X=pdp(1:55);%��ȡ��һ֡���ݵ�ǰ55����
[pks,locs] = findpeaks(X,'MINPEAKHEIGHT',pdpmax(1)-10);
pdp=pdp(locs(1):end);
hti=hti(locs(1):end);
htq=htq(locs(1):end);

%---------------��ͼPDP------------
plot(pdp,'-k')
xlim([0 2000])
hold on
gg=thre(1)+zeros(1,2000);
plot(gg)
str1='I:\pdp\PDP';
str=[str1 num2str(z) '.png'];
saveas(gcf,str);
hold off
%--------------end-----------------



for kk=1:Lh

    if pdp(kk)>=thre(fix((kk-1)/1022)+1)
        hti(kk)=hti(kk);
        htq(kk)=htq(kk);
    else
        hti(kk)=0;
        htq(kk)=0;
    end
end





% %----------��ÿһ֡����ֵǰ5������ֵ��70��ֵ���ھ���������
htt=hti+1i*htq;
htt=htt(1:N*1022);
for k=1:N
%     htt_matrix(k,:)=htt(M(k)-5:M(k)+70);
%       htt_matrix(k,:)=htt(M(1)+1022*(k-1):M(1)+80+1022*(k-1));
       htt_matrix(k,:)=htt(1+1022*(k-1):1+160+1022*(k-1));
end
htt_m=zeros(N,1000);
htt_m(1:N,1:161)=htt_matrix;

for k=1:N
    H(k,:)=fft(htt_m(k,:),NN)./sqrt(NN);
end


HH{1,z}=H;


%----------------end-------------------------------------------------


%ѭ��������
 if steps-z<=1
        waitbar(z/steps,hwait,'��������');
        pause(0.05);
    else
        str=['����������',num2str(z),'%'];
        waitbar(z/steps,hwait,str);
        pause(0.05);
 end
    %___________ѭ��������

end




    %--------�����ļ�------------
    eval(['save F:\���ݴ���\MIMO\',foldername,'.mat HH'])


    close(hwait);
