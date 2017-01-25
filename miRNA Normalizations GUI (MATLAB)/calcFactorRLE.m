function retSomething = calcFactorRLE(data)
gm = exp(nanmean((log(data)).'));

%this should be the length of the number of miRNA
%takes log of every value, then the mean of the columns then means are put
%to the power of 'e'. 

%Used R file to get this algorithm, calcNormFactors, used 

[nrows,ncols] = size(data);
flag = gm >0;
t = data(flag,:);
tt = gm(flag);
retSomething = [];
for i = 1:size(data,2)
    ttt = t(:,i)./tt';
    retSomething = [retSomething nanmedian(ttt)];
end

            
         
            
    