clear
clc
load('Dist.mat')
load D
D=roundn(D,-4)
% start_point: ���ó�ʼ��
% D���趨�����D��ֵ
% Dist: ��ֱ�ӵ��õ�Dist����

start_point = 1;


%�������������Ľڵ㼯��
result_point=[];

%����������ڵ�����
%ATTENTION���Ҳ�ȷ��N�ǲ��ǵ���number_of_cells
N = size(Dist,1);

%�ȶ���һ�����������Dist������󣬱���ı�ԭʼֵ
Dist_mat = Dist;

Dist_mat=roundn(Dist_mat,-4)

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