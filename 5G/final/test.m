
M=24;
Nc=21;
IFR_N=7;
k=1;
l=2;
r=1;
D=sqrt((k*sqrt(3)*r)^2+(l*sqrt(3)*r)^2+k*l*3*r^2);

    NC=zeros(1,IFR_N+1);
    NC(1)=0;
    NC(2)=round(Nc/IFR_N);
    for n=3:IFR_N
        NC(n)=NC(2);
    end
    NC(IFR_N+1)=Nc-sum(NC(1:IFR_N));
    
    
    f=zeros(IFR_N,round(Nc/IFR_N)+2);
    for t=1:IFR_N
        f(t,1:NC(t+1))=1+sum(NC(1:t)):sum(NC(1:t+1));
    end

f


load('Dist.mat')
% start_point: ���ó�ʼ��
% D���趨�����D��ֵ
% Dist: ��ֱ�ӵ��õ�Dist����

start_point = 2;
D=3;

%�������������Ľڵ㼯��
result_point=[];

%����������ڵ�����
%ATTENTION���Ҳ�ȷ��N�ǲ��ǵ���number_of_cells
N = size(Dist,1);

%�ȶ���һ�����������Dist������󣬱���ı�ԭʼֵ
Dist_mat = Dist;

Dist_mat=vpa(Dist_mat,5)

%��Dist_mat������Ϊ0��ֵ����Ϊinf
Dist_mat(Dist_mat == 0)=inf;

%������Ҫ�����Ľڵ㼯��
temple_search_mat = [start_point];
charge = size(temple_search_mat);

cir = 0;

while(charge ~= 0)
    cir= cir+1;
    cir
    Dist_mat(:,result_point)=inf; %�����ڽ�������ڵĽڵ㻥���ľ�������Ϊinf,�����ظ���ȡ
    [m,n]=find(  Dist_mat(:,temple_search_mat)== D );
    result_point = unique([result_point;temple_search_mat]);
    
    disp('result_point')
    result_point'
    
    temple_search_mat = m;
    
    disp('temple_search_mat')
    temple_search_mat'
    
    charge = size(temple_search_mat);
end

%����������
disp('���ս��')
result_point




