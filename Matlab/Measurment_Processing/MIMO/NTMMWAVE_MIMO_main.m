%%
clear all
close all
%---------------------------------------------------
%---------------------------------------------------
%  南通隧道1.8GHz MIMO容量估计
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

NN=4096;%FFT点数
hwait=waitbar(0,'请等待>>>>>>>>');%进度条

% foldername=dir('F:\MMWAVE\NTMMWAVE\MIMO');% 用于得出所有子文件夹的名字
% steps=length(foldername)-2;%进度条

% for index=1:length(foldername)-2
% mydir=strcat('F:\MMWAVE\NTMMWAVE\MIMO\',foldername(index+2).name,'\');% 读取子文件夹的名字和路径
mydir='I:\新建文件夹\';
temp=dir([mydir,'*.csv']);
num_temp=length(temp);
steps=num_temp;

% SNR=10;%信噪比为10dB



for z=1:num_temp  %循环读取数据
filename=[mydir,temp(z).name];
data=csvread(filename,9,0);


I=data(1:2:end,1);%I路数据
Q=data(2:2:end,1);%Q路数据
% I=I.';
% Q=Q.';
%---------------------end-----------------------------

%----I路和Q路信号分别和m序列相关，平方求和得到PDP---------
hti=conv(I,st(end:-1:1))/(511*2); %I路信道冲激响应
htq=conv(Q,st(end:-1:1))/(511*2); %Q路信道冲激响应
ht=sqrt(hti.*hti+htq.*htq);%总的信道冲激响应
pdp=10*log10(ht.*ht); %PDP,单位dBm
pdp_L=ht.*ht;  %PDP线性值

%-----------end------------------------------------------------------




%--------找到PDP的最大值,进而找到第一个PDP的峰值，然后去掉第一个PDP-----
[pdpmax, m]=max(pdp);
 n=mod(m,1022);
 n=n+1022;

hti=hti(n-50:end);
htq=htq(n-50:end);
ht=ht(n-50:end);
pdp=pdp(n-50:end);
pdp_L=pdp_L(n-50:end);
%-------------------------end----------------------------------------



%----------------门限选取后提取多径------------------------------------

%门限的取值
N=2050;%2050个周期
Lh=1022*N;
for kk=1:Lh
    [pdpmax(fix((kk-1)/1022)+1), m(fix((kk-1)/1022)+1)]=max(pdp((fix((kk-1)/1022)*1022+1):(fix((kk-1)/1022)+1)*1022));%找到每帧中信号的最大值及每帧中最大值的位置   
end

for k=1:N
    M(k)=m(k)+1022*(k-1);%M为每一帧数据中最大值的位置
end

for k=1:N
    nse(k)=mean(pdp_L(M(k)+500:M(k)+900));%第k个PDP后面无多径信号部分的噪声的均值
    thre(k)=10*log10(nse(k))+5;%   5dB SNR门限
end
%-------------end---------------------------------------------------------
X=pdp(1:55);%提取第一帧数据的前55个点
[pks,locs] = findpeaks(X,'MINPEAKHEIGHT',pdpmax(1)-10);
pdp=pdp(locs(1):end);
hti=hti(locs(1):end);
htq=htq(locs(1):end);

%---------------存图PDP------------
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





% %----------将每一帧最大值前5到最大值后70个值放于矩阵的列中
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


%循环进度条
 if steps-z<=1
        waitbar(z/steps,hwait,'即将完成');
        pause(0.05);
    else
        str=['正在运行中',num2str(z),'%'];
        waitbar(z/steps,hwait,str);
        pause(0.05);
 end
    %___________循环进度条

end

    
    
    
    %--------保存文件------------
    eval(['save F:\数据处理\MIMO\',foldername,'.mat HH'])

     
    close(hwait); 