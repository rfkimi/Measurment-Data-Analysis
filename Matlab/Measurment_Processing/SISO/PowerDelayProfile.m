
clear all
close all
%---------------------------------------------------
%---------------------------------------------------
%  南通毫米波沿线宽带测试数据
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
hwait=waitbar(0,'请等待>>>>>>>>');%进度条

mydir='I:\新建文件夹 (2)\2X2\';
temp=dir([mydir,'*.csv']);
% temp=dir([mydir,'*.asc']);
num_temp=length(temp);
steps=num_temp;%进度条

Pt=23;%发射功率
G=20;%天线增益



for z=1:num_temp  %循环读取数据
filename=[mydir,temp(z).name];
data=csvread(filename,9,0);
% data=importdata(filename);

I=data(1:2:end,1);%I路数据
Q=data(2:2:end,1);%Q路数据
% I=I.';
% Q=Q.';
%---------------------end-----------------------------
Pr(z)=10*log10((mean((I.*I+Q.*Q)*1000/50)));%powers是电压V的平方，计算功率时要除以50欧姆变成瓦特，再乘以1000换算成毫瓦（Pr为接收功率，单位为）
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

%门限的取值，低于峰值的幅度
N=2050;%2050个周期
% N=2000;%2050个周期
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
%-----------------------end----------------------------------------------
X=pdp(1:55);%提取第一帧数据的前55个点
[pks,locs] = findpeaks(X,'MINPEAKHEIGHT',pdpmax(1)-10);
pdp=pdp(locs(1):end);
hti=hti(locs(1):end);
htq=htq(locs(1):end);
ht=ht(locs(1):end);
% %---------------存图PDP------------
plot(pdp,'-k')
xlim([0 1500])
hold on
gg=thre(1)+zeros(1,1500);
plot(gg)
% str1='D:\PDP\PDP'; 
% str=[str1 num2str(z) '.png'];
% saveas(gcf,str);
hold off
%--------------end-----------------


%-------加窗去掉PDP中的一个尾巴（去掉了I路和Q路冲激响应的尾巴）----------
% for k=1:length(ht)
%     if mod(k,1022)>=1 && mod(k,1022)<=133
%       hti(k)=hti(k);
%       htq(k)=htq(k);
%       ht(k)=ht(k);
%     else
%       hti(k)=0;
%       htq(k)=0;
%       ht(k)=0;
%     end
% end
%------------------end------------------------------------------------

% _________________________________________________________

%对信道冲激响应和PDP进行相参累计
  htCI=zeros(1,1022);
  for i=1:1022
      for j=1:N

           htCI(i)=htCI(i)+ht(i+1022*(j-1));
      end
  end
   htCI=htCI/N;%相参累计后的信道冲激响应
   PDP=htCI.*htCI;%相参累计后的PDP(线性值)
   PDPdB=10*log10(PDP);
  %________________________________________________________
  
  %相参累计后的门限
  nse_CI=mean(PDP(500:1000));%第k个PDP后面无多径信号部分的噪声的均值
  thre_CI=10*log10(nse_CI)+2.5;%   5dB SNR门限
  
  
%   ---------------存图PDP------------
plot(PDPdB,'-*k')
xlim([0 200])
hold on
gg=thre_CI+zeros(1,200);
plot(gg)
% str1='D:\PDP\pdpdB'; 
% str=[str1 num2str(z) '.png'];
% saveas(gcf,str);
hold off
%--------------end-----------------

%  %RMS计算       

  for i=1:length(PDP)

      if (PDPdB(i))>thre_CI

         powers(i)=PDP(i);
         PDPdB(i)=PDPdB(i);
      else
         powers(i)=0;
         PDPdB(i)=thre_CI;
      end
  end
powers_index=find(powers);%找到所有PDP的不为零的元素位置
powers=powers(powers_index(1):end);


powers=powers(1:160);
PDPdB=PDPdB(1:160);
%---------------存图PDP------------
% plot(PDPdB,'-*k')
% xlim([0 200])
% hold on
% gg=thre_CI+zeros(1,200);
% plot(gg)
% str1='D:\PDP\PDP'; 
% str=[str1 num2str(z) '.png'];
% saveas(gcf,str);
% hold off
% %--------------end-----------------


times=0:(length(powers)-1);
delays=5.*times;
delays=delays(1:160);
[D,S]=PDPparameters(delays,powers);
      fprintf('\28GHz\n Excess delay \t %g\n Delay spread \t %g\n\n',D,S);    

RMS(z)=S;%RMS时延扩展
ED(z)=D;  %平均附加时延




%循环进度条
 if steps-z<=1
        waitbar(z/steps,hwait,'即将完成');
        pause(0.05);
    else
        str=['正在运行中',num2str(z*100/steps),'%'];
        waitbar(z/steps,hwait,str);
        pause(0.05);
 end
    %___________循环进度条


end

     close(hwait); 
     

plot(RMS(end:-1:1))
xlabel('T-R separation distance[m]')
ylabel('RMS delay spread')

figure
PL=Pt+G+G-Pr;
plot(PL(end:-1:1))
xlabel('T-R separation distance[m]')
ylabel('Path Loss')

figure
plot(ED(end:-1:1))
xlabel('T-R separation distance[m]')
ylabel('mean excess delay')
