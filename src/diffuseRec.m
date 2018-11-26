function [ recList ] = diffuseRec( ii,train,lambda,beta_matrix,sigma_matrix)

% save('sigma_matrix','sigma_matrix','-v7.3');
% w = (beta_matrix').^(lambda) .* beta_matrix.^(lambda) .* sigma_matrix;
if ii == 1
    w = (beta_matrix) .* sigma_matrix;
elseif ii == 2
    w = (beta_matrix') .* sigma_matrix;
end
if ii == 3
    %HHP
    w = (beta_matrix').^(1-lambda) .* beta_matrix.^(lambda) .* sigma_matrix; 
elseif ii == 4
    %BHC
    w = (beta_matrix').^(lambda) .* sigma_matrix;
elseif ii == 5
    %BD
    w = (beta_matrix' .* beta_matrix).^(lambda) .*sigma_matrix;    
end
pre = sparse(train) * w .* (~train);
recList = pre;
% [~,sat] = sort(pre,2,'descend');
% recList = sat;
% clear sat;
end

