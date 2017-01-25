function factors = Tmm (matrix)
class(matrix)
if ~iscell(matrix) 
    error('The data type provided must be a cell array')
    return;
end
sampleHeadings = matrix(1,2:end);
miRNAHeadings = matrix(:,1);
data = cell2mat(matrix(2:end,2:end));

assignin('base','data',data)
libSize = [];
[nrows,ncols] = size(data);
for i = 1:ncols
    
    libSize = [libSize nansum(data(:,i))];
    
end


quantileVal = calculateQuantile(data,libSize,0.75);
quantileVal

[minVal,refCol] = nanmin(abs(quantileVal - nanmean(quantileVal)));

if refCol == 0 || refCol < 1 || refCol > ncols
    refCol = 1;
end

toBeNormal = zeros(1,ncols); %number of normalization factors
toBeNormal(:,:) = NaN;
for j = 1:ncols
    
    toBeNormal(j) = weightedFactor(data(:,j),data(:,refCol),0.3,0.05,1,-1e10);
end

factors = toBeNormal;

factors = factors/exp(nanmean(log(factors)));


