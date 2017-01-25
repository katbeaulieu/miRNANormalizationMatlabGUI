function f = calculateQuantile(data,libSize,p)
%have to find the quantile down the columns

[nrows,ncols] = size(data);
y = [];

for i = 1:ncols
    y = [y data(:,i)./libSize(i)];
end

f = quantile(y,p,1);

%f should be the same size as the number of samples

