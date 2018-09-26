function[out]=sigexpand(d,M)
%将输入的序列扩展成间隔为N-1个0的序列
N=length(d);
out=zeros(M,N); %在shuzi_duojing的例子中，M=8，N=1000，产生一个8行1000列的矩阵
out(1,:)=d; %d的每一个元素赋值给out矩阵每列的第一个元素，因为d中共1000个元素（0，-1或者1），且out矩阵共有1000列，所以当然成立
out=reshape(out,1,M*N); %把out这个矩阵重新变成一个1行M*N列的矩阵，即1行8000列的有8000个元素的矩阵，其中每隔7个0就是一个原来的d中的元素
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明


end

