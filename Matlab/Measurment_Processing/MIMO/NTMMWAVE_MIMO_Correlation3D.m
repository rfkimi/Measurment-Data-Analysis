%%
clear all
close all

%---------------------------------------------------------------------
%---------------------------------------------------------------------
%
%   ��ͨMMWAVE MIMO��������Է�����Ƶ��
%
%
%
%---------------------------------------------------------------------
%---------------------------------------------------------------------

Nf=2048;
Nt=4;
Nr=8;
hwait=waitbar(0,'��ȴ�>>>>>>>>');%������

mydir='G:\���Ⱥ��ײ���������\CIR\VV\';
temp=dir([mydir,'*.mat']);
num_temp=length(temp);
steps=num_temp;%������



for z=1:num_temp  %ѭ����ȡ����
filename=[mydir,temp(z).name];
H=importdata(filename);

for d=1:7
    for k=1:Nf
        for m=1:Nt
            for n=1:Nr-d

%                   coef=corrcoef(H{1,4*(j-1)+i}(:,k),H{1,4*(j-1)+i+d}(:,k));
%                   coe(i)=coef(1,2);
                       coe(n)=(mean(H{1,8*(m-1)+n}(:,k).'*((H{1,8*(m-1)+n+d}(:,k)).')')-mean(H{1,8*(m-1)+n}(:,k).')*mean(H{1,8*(m-1)+n+d}(:,k).'))./sqrt...
                      ((mean((H{1,8*(m-1)+n}(:,k)).'*((H{1,8*(m-1)+n}(:,k)).')')-mean((H{1,8*(m-1)+n}(:,k)).')*(mean((H{1,8*(m-1)+n}(:,k)).'))')*...
                      (mean((H{1,8*(m-1)+n+d}(:,k)).'*((H{1,8*(m-1)+n+d}(:,k)).')')-mean((H{1,8*(m-1)+n+d}(:,k)).')*(mean((H{1,8*(m-1)+n+d}(:,k)).'))'));
            end
            coej(m,:)=coe;
        end
%         coek(k)=sum(sum(abs(coej)));
        coek(k)=sum(sum((coej)));
        clear coej
        clear coe
    end

      R(d)=sum(coek)./(Nf*n*m);
    
end
RR(:,z)=abs(R);
%ѭ��������
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

     close(hwait); 
d=0.5:0.5:3.5;
D=5:5:30;
surf(D,d,RR);
shading interp
zlabel('Correlation Magnitude')
xlabel('T-R separation distance [m]')
ylabel('d/\lambda')
