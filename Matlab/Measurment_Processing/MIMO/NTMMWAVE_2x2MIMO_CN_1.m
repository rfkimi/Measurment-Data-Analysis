%% 
clear all
close all



 M=4096;%FFT bins
 NTx=2;
 NRx=2;

 N=2150;

 

hwait=waitbar(0,'请等待>>>>>>>>');%进度条

SNR=10;%信噪比为10dB
% foldername=dir('F:\数据处理\MIMO');% 用于得出所有子文件夹的名字
% steps=length(foldername)-2;%进度条

% for index=1:length(foldername)-2
% mydir=strcat('F:\数据处理\MIMO\',foldername(index+2).name,'\');% 读取子文件夹的名字和路径
mydir='F:\数据处理\MIMO\28HH\';
temp=dir([mydir,'*.mat']);
num_temp=length(temp);
steps=num_temp;%进度条
% temp=dir([mydir,'*.mat']);
% num_temp=length(temp);



for z=1:num_temp  %循环读取数据
filename=[mydir,temp(z).name];
HH=importdata(filename);
for n=1:2
    for p=1:2
     for m=1:6
         for k=1:M
             Hh=[HH{1,m+32*(n-1)+8*(p-1)}(:,k).';HH{1,m+2+32*(n-1)+8*(p-1)}(:,k).';...
                 HH{1,m+16+32*(n-1)+8*(p-1)}(:,k).';HH{1,m+17+32*(n-1)+8*(p-1)}(:,k).'];
             Hhh=reshape(Hh,[NRx,NTx,N]);  
             for idx = 1:N
             HHH = Hhh(:,:,idx);
             HF2(idx)=sum(sum(HHH.*conj(HHH))); %归一化因子
             end
             HF(k,:)=HF2;
         end
         HF2=sum(HF);
         clear Hh
         clear Hhh
         for k=1:M
            Hh=[HH{1,m+32*(n-1)+8*(p-1)}(:,k).';HH{1,m+1+32*(n-1)+8*(p-1)}(:,k).';...
                 HH{1,m+8+32*(n-1)+8*(p-1)}(:,k).';HH{1,m+9+32*(n-1)+8*(p-1)}(:,k).'];
             Hhh=reshape(Hh,[NRx,NTx,N]); 
             for idx = 1:N
             HHH = Hhh(:,:,idx);
             
             HHH=HHH.*sqrt(M*NTx*NRx./HF2(idx));  %归一化
             CN(idx)=cond(HHH);
%              C(idx) = log2(det(eye(NRx) + 10^(0.1*SNR)/NTx.*HHH*HHH'));%容量
             end
             CN_mx(k,:)=CN;
         end

             CNN(m,:)= sum(CN_mx)/M;
     end      
             
             CNNN(p,:)=mean(CNN);
               
%          Ca(z)=mean(CCC);%计算每个位置的平均容量
    end
    CNNNN(n,:)=mean(CNNN);
end
CN_d(z)=mean(mean(CNNNN));
data = 20*log10(mean(CNNNN));
h=cdfplot(data);
set(h,'color','g','linewidth',2)
 xlabel('CN[dB]');
   ylabel('CDF');
       hold on

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

% str1='F:\数据处理\MIMO_Fig\CapacityCDF'; 
% str=[str1 foldername(index+2).name '.fig'];
% saveas(gcf,str);
%        hold off
%  eval(['save F:\数据处理\MIMO_Fig\',foldername(index+2).name,'Capacity_d','.mat Capacity']);
%  clear Capacity
%  %循环进度条
    close(hwait); 

figure

CN_dmean=CN_d;
CN_d_dB=20*log10(CN_dmean);
d=15:15:75;
% figure(2)
plot(d,CN_d_dB,'-*k')
 xlabel('T-R separation distance [m]');
ylabel('CN [dB]');



