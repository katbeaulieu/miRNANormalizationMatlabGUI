function dataset = cpm(matrix,method)
if isequal(method,'TMM')
    factors = Tmm(matrix);
elseif isequal(method,'DESeq')
    factors = DeSeq(matrix)
end

class(matrix)
if ~iscell(matrix) 
    error('The data type provided must be a cell array')
    return;
end
sampleHeadings = matrix(1,2:end);
miRNAHeadings = matrix(:,1);
data = cell2mat(matrix(2:end,2:end));
size(data)
libSizes = [];
for i = 1:size(data,2)
    libSize = sum(data(:,i));
    libSizes = [libSizes libSize*factors(i)];
end

libSizes = libSizes*1e-6

dataset = zeros(size(data));
for i = 1:size(data,2)
    for j = 1:size(data,1)
        dataset(j,i) = data(j,i)/libSizes(i);
    end
end
    

end