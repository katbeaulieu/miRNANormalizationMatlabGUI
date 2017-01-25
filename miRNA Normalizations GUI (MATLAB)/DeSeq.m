function factors = DeSeq(matrix)
%aka RLE method


if ~iscell(matrix) 
    error('The data type provided must be a cell array')
    return;
end
sampleHeadings = matrix(1,2:end);
miRNAHeadings = matrix(:,1);
data = cell2mat(matrix(2:end,2:end));



libSize = [];
[nrows,ncols] = size(data);
for i = 1:ncols
    libSize = [libSize nansum(data(:,i))];
    
end

factors1 = calcFactorRLE(data);
factors = factors1./libSize;
