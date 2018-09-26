
clear all
close all
%---------------------------------------------------
%---------------------------------------------------
%  ��ͨ���ײ����߿����������
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
hwait=waitbar(0,'��ȴ�>>>>>>>>');%������

mydir='I:\�½��ļ��� (2)\2X2\';
temp=dir([mydir,'*.csv']);
% temp=dir([mydir,'*.asc']);
num_temp=length(temp);
steps=num_temp;%������

Pt=23;%���书��
G=20;%��������



for z=1:num_temp  %ѭ����ȡ����
filename=[mydir,temp(z).name];
data=csvread(filename,9,0);
% data=importdata(filename);

I=data(1:2:end,1);%I·����
Q=data(2:2:end,1);%Q·����
% I=I.';
% Q=Q.';
%---------------------end-----------------------------
Pr(z)=10*log10((mean((I.*I+Q.*Q)*1000/50)));%powers�ǵ�ѹV��ƽ�������㹦��ʱҪ����50ŷķ������أ��ٳ���1000����ɺ��ߣ�PrΪ���չ��ʣ���λΪ��
%----I·��Q·�źŷֱ��m������أ�ƽ����͵õ�PDP---------
hti=conv(I,st(end:-1:1))/(511*2); %I·�ŵ��弤��Ӧ
htq=conv(Q,st(end:-1:1))/(511*2); %Q·�ŵ��弤��Ӧ
ht=sqrt(hti.*hti+htq.*htq);%�ܵ��ŵ��弤��Ӧ
pdp=10*log10(ht.*ht); %PDP,��λdBm
pdp_L=ht.*ht;  %PDP����ֵ

%-----------end------------------------------------------------------




%--------�ҵ�PDP�����ֵ,�����ҵ���һ��PDP�ķ�ֵ��Ȼ��ȥ����һ��PDP-----
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

%���޵�ȡֵ�����ڷ�ֵ�ķ���
N=2050;%2050������
% N=2000;%2050������
Lh=1022*N;
for kk=1:Lh
    [pdpmax(fix((kk-1)/1022)+1), m(fix((kk-1)/1022)+1)]=max(pdp((fix((kk-1)/1022)*1022+1):(fix((kk-1)/1022)+1)*1022));%�ҵ�ÿ֡���źŵ����ֵ��ÿ֡�����ֵ��λ��   
end

for k=1:N
    M(k)=m(k)+1022*(k-1);%MΪÿһ֡���������ֵ��λ��
end

for k=1:N
    nse(k)=mean(pdp_L(M(k)+500:M(k)+900));%��k��PDP�����޶ྶ�źŲ��ֵ������ľ�ֵ
    thre(k)=10*log10(nse(k))+5;%   5dB SNR����
end
%-----------------------end----------------------------------------------
X=pdp(1:55);%��ȡ��һ֡���ݵ�ǰ55����
[pks,locs] = findpeaks(X,'MINPEAKHEIGHT',pdpmax(1)-10);
pdp=pdp(locs(1):end);
hti=hti(locs(1):end);
htq=htq(locs(1):end);
ht=ht(locs(1):end);
% %---------------��ͼPDP------------
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


%-------�Ӵ�ȥ��PDP�е�һ��β�ͣ�ȥ����I·��Q·�弤��Ӧ��β�ͣ�----------
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

%���ŵ��弤��Ӧ��PDP��������ۼ�
  htCI=zeros(1,1022);
  for i=1:1022
      for j=1:N

           htCI(i)=htCI(i)+ht(i+1022*(j-1));
      end
  end
   htCI=htCI/N;%����ۼƺ���ŵ��弤��Ӧ
   PDP=htCI.*htCI;%����ۼƺ��PDP(����ֵ)
   PDPdB=10*log10(PDP);
  %________________________________________________________
  
  %����ۼƺ������
  nse_CI=mean(PDP(500:1000));%��k��PDP�����޶ྶ�źŲ��ֵ������ľ�ֵ
  thre_CI=10*log10(nse_CI)+2.5;%   5dB SNR����
  
  
%   ---------------��ͼPDP------------
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

%  %RMS����       

  for i=1:length(PDP)

      if (PDPdB(i))>thre_CI

         powers(i)=PDP(i);
         PDPdB(i)=PDPdB(i);
      else
         powers(i)=0;
         PDPdB(i)=thre_CI;
      end
  end
powers_index=find(powers);%�ҵ�����PDP�Ĳ�Ϊ���Ԫ��λ��
powers=powers(powers_index(1):end);


powers=powers(1:160);
PDPdB=PDPdB(1:160);
%---------------��ͼPDP------------
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

RMS(z)=S;%RMSʱ����չ
ED(z)=D;  %ƽ������ʱ��




%ѭ��������
 if steps-z<=1
        waitbar(z/steps,hwait,'�������');
        pause(0.05);
    else
        str=['����������',num2str(z*100/steps),'%'];
        waitbar(z/steps,hwait,str);
        pause(0.05);
 end
    %___________ѭ��������


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
