function rs = rs(test,pre)
    [user_size,item_size] = size(pre);
    %���Լ��а������û�
%     test_u = sum(test,2);
    [B,index1] = sort(pre,2);
    clear B;
    %kΪ���Լ���������һ�����ֵ��û�
    [B,index2] = sort(index1,2);
    clear B;
    index2 = item_size - index2 + 1;
    rs = sum((index2.*test)./item_size,2);
end
% function rs = rs(test,pre,train)
%     [user_size,item_size] = size(pre);
%     %���Լ��а������û�
%     %test_u = sum(test,2);
%     [B,index_a] = sort(pre,2);
%     clear B;
%     %kΪ���Լ���������һ�����ֵ��û�
%     [B,index_b] = sort(index_a,2);
%     clear B;
%     index_b = item_size - index_b + 1;
%     train_copy = zeros(size(train));
%     temp = find(train == 0);
%     train_copy(temp) = 1;%���û�δ���������Ʒ����־Ϊ1
%     rs_fenmu = sum(train_copy,2);%rs�ķ�ĸΪ�û�δ���������Ʒ������
%     s1 = length(index_b);
%     s2 = length(test);
%         if(max(s1,s2)==s1)
%             test(s2+1:s1,:) = 0;
%         else
%             index_b(s1+1:s2,:) = 0;
%         end
%     for oo = 1:user_size
%         rs = sum((index_b(oo,:).*test(oo,:))./rs_fenmu(oo),2);
%     end
%         save('rs_test','rs')
% end