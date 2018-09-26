%%
clear all
close all

%---------------------------------------------------------------------
%---------------------------------------------------------------------
%
%   南通MMWAVE MIMO测量相关性分析（频域）
%
%
%
%---------------------------------------------------------------------
%---------------------------------------------------------------------

Nf=2048;
Nt=4;
Nr=8;
hwait=waitbar(0,'请等待>>>>>>>>');%进度条

mydir='G:\走廊毫米波测试数据\CIR\VV\';
temp=dir([mydir,'*.mat']);
num_temp=length(temp);
steps=num_temp;%进度条



for z=1:num_temp  %循环读取数据
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

     close(hwait); 
d=0.5:0.5:3.5;
D=5:5:30;
surf(D,d,RR);
shading interp
zlabel('Correlation Magnitude')
xlabel('T-R separation distance [m]')
ylabel('d/\lambda')
