%m用户个数，n商品个数，pre所有未选商品预测评分矩阵，recomLength推荐列表长度
function [precision,recall,I,HD] = cnFun(train_data,UserExistsBoth,itemSize,test,pre,recomLength,PrandL,item_du)
[result,sat] = sort(pre,2);  %sat是预测评分排序后，商品id对应的位置(下标) sat(i,j)表示用户i对商品sat(i,j)的预测分值排在第j位
clear result pre;
test_01 = spones(test);%用1置换非零元素
%recall=zeros(userSize,1);
UserSize  = length(UserExistsBoth'); 
precision = zeros(UserSize,1);%产生m×n的零矩阵
recall = zeros(UserSize,1);
I = zeros(UserSize,1);
% HD = zeros(UserSize,1);
k_item = zeros(UserSize,recomLength);
[UserNumAll,llll] = size(train_data);
clear 1111 test;  
recommList = zeros(UserSize,itemSize);
clear ItemNumAll result;
for i = 1:UserSize
    temp = sat(i,itemSize - recomLength + 1 : itemSize);%推荐列表
    k_item(i,:) = item_du(1,temp);
    recommList(i,temp) = 1;
    Like_count = sum(test_01(i,temp));%匹配测试集中商品在推荐列表中出现的个数
    precision(i,1) = Like_count / recomLength;
    recall(i,1) = Like_count / sum(test_01(i,:));
    for j = 1:recomLength
        I(i,1) = I(i,1) + log2(UserNumAll / k_item(i,j));%（训练集中的所有用户数/该商品的度）
    end
%     I(i,1) = I(i,1) / recomLength;
end
clear test_01 sat k_item;
%计算precision的平均值
ep =  precision.*PrandL;
precision=mean(ep);
recall = mean(recall);
%计算I的平均值
I = full(sum(I) / (recomLength * UserSize));
%计算HD的值
interItem = 1 - (sparse(recommList) * (recommList)') / recomLength;
interItem = interItem - interItem .* eye(UserSize,UserSize);
HD = sum(sum(interItem,1),2);
clear interItem;
HD = HD / (UserSize*(UserSize -1));