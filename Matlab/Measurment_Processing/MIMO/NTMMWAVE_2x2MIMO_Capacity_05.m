%% 
clear all
close all



 M=2048;%FFT bins
 NTx=2;
 NRx=2;

 N=2040;

 

hwait=waitbar(0,'请等待>>>>>>>>');%进度条

SNR=10;%信噪比为10dB
foldername=dir('H:\15VV');% 用于得出所有子文件夹的名字
steps=length(foldername)-2;%进度条

for index=1:length(foldername)-2
mydir=strcat('H:\15VV\',foldername(index+2).name,'\');% 读取子文件夹的名字和路径

temp=dir([mydir,'*.mat']);
num_temp=length(temp);

for z=1:num_temp  %循环读取数据
filename=[mydir,temp(z).name];
HH=importdata(filename);
for n=1:2
    for p=1:3
     for m=1:7
         for k=1:M
             Hh=[HH{1,m+32*(n-1)+8*(p-1)}(:,k).';HH{1,m+1+32*(n-1)+8*(p-1)}(:,k).';...
                 HH{1,m+8+32*(n-1)+8*(p-1)}(:,k).';HH{1,m+9+32*(n-1)+8*(p-1)}(:,k).'];
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
             
             C(idx) = log2(det(eye(NRx) + 10^(0.1*SNR)/NTx.*HHH*HHH'));%容量
             end
             C_mx(k,:)=C;
         end

             CC(m,:)= sum(C_mx)/M;
     end      
             
             CCC(p,:)=mean(CC);
               
%          Ca(z)=mean(CCC);%计算每个位置的平均容量
    end
    CCCC(n,:)=mean(CCC);
end
data = mean(CCCC);
h=cdfplot(data);
set(h,'color','g','linewidth',2)
 xlabel('Capacity[bit/s/Hz]');
   ylabel('CDF');
       hold on
       
       
end

% str1='G:\2X2_05_Capacity\'; 
% str=[str1 foldername(index+2).name '.fig'];
% saveas(gcf,str);
%        hold off
       
 if steps-index<=1
        waitbar(index/steps,hwait,'即将完成');
        pause(0.05);
    else
        str=['正在运行中',num2str(z),'%'];
        waitbar(index/steps,hwait,str);
        pause(0.05);
 end
    %___________循环进度条

end

    close(hwait); 





