clear;
clc;
datasets = {'MovieLens', 'Netflix', 'RYM'};
for yy = 1:3
    train = load(['../data/',datasets{yy} ,'/train.txt']);
    test = load(['../data/',datasets{yy} ,'/test.txt']);
    train(:,3) = 1;
    test(:,3) = 1;
    train(:,4) = 1;
    test(:,4) = 1;
    train(:,4) = [];
    test(:,4) = [];
    train_data = full(spconvert(train));
    test_data = full(spconvert(test));
    [m,n] = size(train_data);
    [m1,n1] = size(train_data);
    [m2,n2] = size(test_data);
    if(max(m1,m2)==m1)
        test_data(m2+1:m1,:) = 0;
    else
        test_data(m1+1:m2,:) = [];
    end
    if(max(n1,n2)==n1)
        test_data(:,n2+1:n1) = 0;
    else
        test_data(:,n1+1:n2) = [];
    end
    clear train test m1 m2 n1 n2;
    
    %测试集与训练集处理成相同规模的矩阵XXXXX
    train_row_du = sum(train_data,2);%用户所选择过的商品数目
    test_row_du = sum(test_data,2);
    train_col_du = sum(train_data,1);%商品的流行度
    
    index1 = find(train_row_du~=0);
    index2 = find(test_row_du~=0);
    UserExistsBoth = intersect(index1,index2);%%%用于评价指标的计算，训练集测试集共有的用户
    
    index3 = find(train_row_du==0);
    index4 = find(test_row_du==0);
    index_ = unique([index3;index4]);
    index5 = find(train_col_du ~= 0);%%%训练集包含的实际商品数目
    
    clear index1 index2 index3 index4;
    PrandL = (length(index5)-train_row_du)./test_row_du;%%训练集中所有未选择过的商品数/测试集中该用户选择过的商品数
    PrandL(isnan(PrandL)) = 0;
    PrandL(isinf(PrandL)) = 0;
    
    beta_matrix = 1 ./ repmat(train_col_du',[1,n]);
    beta_matrix(isinf(beta_matrix)) = 0;
    beta_matrix(isnan(beta_matrix)) = 0;
    
    temp_ = 1 ./ repmat(train_row_du,[1,n]);
    sigma_matrix = full(sparse(train_data') * sparse(train_data .* temp_));
    clear temp_;
    sigma_matrix(isinf(sigma_matrix)) = 0;
    sigma_matrix(isnan(sigma_matrix)) = 0;
    %********************************************************************%
    algorithms = {'MD','HC','HHP','BHC','BD'};
    for ii = 1:1:5
        file_out_path = ['../result/', datasets{yy}, '/', algorithms{ii}, '/'];
        
        line = 1;
        if ii == 1
            a = [1,1,1];
        elseif ii == 2
            a = [0,1,0];
        else
            a = [0.1,0.1,1];
        end
        for lambda = a(1):a(2):a(3)
            t1 = clock;
            recList = diffuseRec( ii,train_data,lambda,beta_matrix,sigma_matrix );%排序前的预测列表
            [m1,n1] = size(recList);
            [m2,n2] = size(test_data);
            if(max(m1,m2)==m1)
                test_data(m2+1:m1,:) = 0;
            else
                test_data(m1+1:m2,:) = [];
            end
            if(max(n1,n2)==n1)
                test_data(:,n2+1:n1) = 0;
            else
                test_data(:,n1+1:n2) = [];
            end
            clear  m1 m2 n1 n2;
            [~,itemSize] = size(test_data);
            
            r = 0;
            number = 0;
            %遍历训练集中的用户
            for i = 1:m
                if(any(index_==i)==0) %非零元素
                    temp = find(train_data(i,:) == 0);
                    r = r+rs(test_data(i,temp),recList(i,temp));
                    number = number+nnz(test_data(i,temp));
                end
            end
            score = r/number;
            rankScore(line,1) = lambda;
            rankScore(line,2) = score;
                        
            for L = 10:10:50  %recommendation length
                [precision,recall,I,HD]=cnFun(train_data,UserExistsBoth,itemSize,test_data(UserExistsBoth,:),recList(UserExistsBoth,:),L,PrandL(UserExistsBoth,:),train_col_du);
                precision_L(line,1) = lambda;
                precision_L(line,int32(L/10+1)) = precision;
                recall_L(line,1) = lambda;
                recall_L(line,int32(L/10+1)) = recall;
                HD_L(line,1) = lambda;
                HD_L(line,int32(L/10+1)) = HD;
                I_L(line,1) = lambda;
                I_L(line,int32(L/10+1)) = I;
            end
            line = line + 1;
            t2 = clock;
            run_time = etime(t2,t1);
            disp([ 'Running ',datasets{yy},' of ', algorithms{ii}, ' and lambda = ', num2str(lambda), ' ... Spent ', num2str(run_time), ' seconds.' ]);
        end
        dlmwrite([file_out_path,'rankingScore.txt'],rankScore,'delimiter','\t','precision',12);
        dlmwrite([file_out_path,'precision.txt'],precision_L,'delimiter','\t','precision',12);
        dlmwrite([file_out_path,'recall.txt'],recall_L,'delimiter','\t','precision',12);
        dlmwrite([file_out_path,'hammingdistance.txt'],HD_L,'delimiter','\t','precision',12);
        dlmwrite([file_out_path,'novelty.txt'],I_L,'delimiter','\t','precision',12);
    end
end
