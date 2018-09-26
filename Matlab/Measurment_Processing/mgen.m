%m���з�����
function [out,pState] = mgen(g,state,N)
%���� g: m�������ɶ���ʽ (10�������룩
%  state: �Ĵ�����ʼ״̬ ��10�������룩
%     N: ������г���
% test g =11; state=3; N=15;
gen = dec2bin(g) - 48;
M = length(gen);                
curState = dec2bin(state,M-1) - 48;

for k=1:N
    out(k) = curState(M-1);
    a = rem( sum( gen(2:end).*curState ),2 );
    curState = [a curState(1:M-2)];
end
pState = bin2dec( char(curState+48) );