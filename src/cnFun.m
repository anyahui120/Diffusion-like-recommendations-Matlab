%m�û�������n��Ʒ������pre����δѡ��ƷԤ�����־���recomLength�Ƽ��б���
function [precision,recall,I,HD] = cnFun(train_data,UserExistsBoth,itemSize,test,pre,recomLength,PrandL,item_du)
[result,sat] = sort(pre,2);  %sat��Ԥ�������������Ʒid��Ӧ��λ��(�±�) sat(i,j)��ʾ�û�i����Ʒsat(i,j)��Ԥ���ֵ���ڵ�jλ
clear result pre;
test_01 = spones(test);%��1�û�����Ԫ��
%recall=zeros(userSize,1);
UserSize  = length(UserExistsBoth'); 
precision = zeros(UserSize,1);%����m��n�������
recall = zeros(UserSize,1);
I = zeros(UserSize,1);
% HD = zeros(UserSize,1);
k_item = zeros(UserSize,recomLength);
[UserNumAll,llll] = size(train_data);
clear 1111 test;  
recommList = zeros(UserSize,itemSize);
clear ItemNumAll result;
for i = 1:UserSize
    temp = sat(i,itemSize - recomLength + 1 : itemSize);%�Ƽ��б�
    k_item(i,:) = item_du(1,temp);
    recommList(i,temp) = 1;
    Like_count = sum(test_01(i,temp));%ƥ����Լ�����Ʒ���Ƽ��б��г��ֵĸ���
    precision(i,1) = Like_count / recomLength;
    recall(i,1) = Like_count / sum(test_01(i,:));
    for j = 1:recomLength
        I(i,1) = I(i,1) + log2(UserNumAll / k_item(i,j));%��ѵ�����е������û���/����Ʒ�Ķȣ�
    end
%     I(i,1) = I(i,1) / recomLength;
end
clear test_01 sat k_item;
%����precision��ƽ��ֵ
ep =  precision.*PrandL;
precision=mean(ep);
recall = mean(recall);
%����I��ƽ��ֵ
I = full(sum(I) / (recomLength * UserSize));
%����HD��ֵ
interItem = 1 - (sparse(recommList) * (recommList)') / recomLength;
interItem = interItem - interItem .* eye(UserSize,UserSize);
HD = sum(sum(interItem,1),2);
clear interItem;
HD = HD / (UserSize*(UserSize -1));