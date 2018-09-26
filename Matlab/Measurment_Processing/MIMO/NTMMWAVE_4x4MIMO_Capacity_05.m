%% 
clear all
close all



 M=4096;%FFT bins
 NTx=4;
 NRx=4;

 N=2150;

 

hwait=waitbar(0,'��ȴ�>>>>>>>>');%������

SNR=10;%�����Ϊ10dB
% foldername=dir('F:\���ݴ���\MIMO');% ���ڵó��������ļ��е�����
% steps=length(foldername)-2;%������

% for index=1:length(foldername)-2
% mydir=strcat('F:\���ݴ���\MIMO\',foldername(index+2).name,'\');% ��ȡ���ļ��е����ֺ�·��
mydir='F:\���ݴ���\MIMO\28HH\';
temp=dir([mydir,'*.mat']);
num_temp=length(temp);
steps=num_temp;%������
% temp=dir([mydir,'*.mat']);
% num_temp=length(temp);



for z=1:num_temp  %ѭ����ȡ����
filename=[mydir,temp(z).name];
HH=importdata(filename);
for n=1:2
     for m=1:5
         for k=1:M
             Hh=[HH{1,m+32*(n-1)}(:,k).';HH{1,m+1+32*(n-1)}(:,k).';HH{1,m+2+32*(n-1)}(:,k).';HH{1,m+3+32*(n-1)}(:,k).';...
                 HH{1,m+8+32*(n-1)}(:,k).';HH{1,m+9+32*(n-1)}(:,k).';HH{1,m+10+32*(n-1)}(:,k).';HH{1,m+11+32*(n-1)}(:,k).';...
                 HH{1,m+16+32*(n-1)}(:,k).';HH{1,m+17+32*(n-1)}(:,k).';HH{1,m+18+32*(n-1)}(:,k).';HH{1,m+19+32*(n-1)}(:,k).';...
                 HH{1,m+24+32*(n-1)}(:,k).';HH{1,m+25+32*(n-1)}(:,k).';HH{1,m+26+32*(n-1)}(:,k).';HH{1,m+27+32*(n-1)}(:,k).'];
             Hhh=reshape(Hh,[NRx,NTx,N]);  
             for idx = 1:N
             HHH = Hhh(:,:,idx);
             HF2(idx)=sum(sum(HHH.*conj(HHH))); %��һ������
             end
             HF(k,:)=HF2;
         end
         HF2=sum(HF);
         clear Hh
         clear Hhh
         for k=1:M
             Hh=[HH{1,m+32*(n-1)}(:,k).';HH{1,m+1+32*(n-1)}(:,k).';HH{1,m+2+32*(n-1)}(:,k).';HH{1,m+3+32*(n-1)}(:,k).';...
                 HH{1,m+8+32*(n-1)}(:,k).';HH{1,m+9+32*(n-1)}(:,k).';HH{1,m+10+32*(n-1)}(:,k).';HH{1,m+11+32*(n-1)}(:,k).';...
                 HH{1,m+16+32*(n-1)}(:,k).';HH{1,m+17+32*(n-1)}(:,k).';HH{1,m+18+32*(n-1)}(:,k).';HH{1,m+19+32*(n-1)}(:,k).';...
                 HH{1,m+24+32*(n-1)}(:,k).';HH{1,m+25+32*(n-1)}(:,k).';HH{1,m+26+32*(n-1)}(:,k).';HH{1,m+27+32*(n-1)}(:,k).'];
             Hhh=reshape(Hh,[NRx,NTx,N]); 
             for idx = 1:N
             HHH = Hhh(:,:,idx);
             
             HHH=HHH.*sqrt(M*NTx*NRx./HF2(idx));  %��һ��
             
             C(idx) = log2(det(eye(NRx) + 10^(0.1*SNR)/NTx.*HHH*HHH'));%����
             end
             C_mx(k,:)=C;
         end

             CC(m,:)= sum(C_mx)/M;
     end      
             
             CCC(n,:)=mean(CC);
               
%          Ca(z)=mean(CCC);%����ÿ��λ�õ�ƽ������
end
data = mean(CCC);
h=cdfplot(data);
set(h,'color','g','linewidth',2)
 xlabel('Capacity[bit/s/Hz]');
   ylabel('CDF');
       hold on
Capacity(z)=mean(data);

 if steps-z<=1
        waitbar(z/steps,hwait,'�������');
        pause(0.05);
    else
        str=['����������',num2str(z),'%'];
        waitbar(z/steps,hwait,str);
        pause(0.05);
 end
    %___________ѭ��������

end

% str1='F:\���ݴ���\MIMO_Fig\CapacityCDF'; 
% str=[str1 foldername(index+2).name '.fig'];
% saveas(gcf,str);
%        hold off
%  eval(['save F:\���ݴ���\MIMO_Fig\',foldername(index+2).name,'Capacity_d','.mat Capacity']);
%  clear Capacity
%  %ѭ��������
    close(hwait); 





