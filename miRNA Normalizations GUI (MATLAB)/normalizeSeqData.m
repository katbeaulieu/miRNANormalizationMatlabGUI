function dataout = normalizeSeqData(datain, method, denominator)
%computes normalization of the input data:
%datain format: rows - miRNAs, collumns - samples, datain is double
%method: rf: relative frequency of the input data, divide each count by the
%               total count in each sample (default)
%        uq: upper quantile, divide each count by the upper quantile (75)
%               of non-zero counts in each sample
%        med: Median , divide each count by the median of non-zero counts
%                in each sample
%denominator: if not empty, then it is used to divide each count in each
%sample, the denominator must be a vector the same length as the number of
%samples

dataout = datain;
if ~isempty(denominator) && length(denominator) == size(datain, 2)
    factor = denominator;
else
    switch lower(method)
        case 'rf'
            factor = nansum(datain);
            for i=1:size(datain, 2)
                dataout(:, i) = datain(:, i)./factor(i);
            end
        case 'uq'
            flag = datain>0; %use only data greater than 0 to compute upper quantile    
            factor = zeros(size(datain, 2),1);
            for i=1:size(datain, 2)
                factor(i) = quantile(datain(flag(:, i), i), .75);
            end
        case 'med'
            flag = datain>0; %use only data greater than 0 to compute median    
            factor = zeros(size(datain, 2),1);
            for i=1:size(datain, 2)
                factor(i) = nanmedian(datain(flag(:, i), i));
            end
        otherwise
            factor = nansum(datain);
    end
end

for i=1:size(datain, 2)
    dataout(:, i) = datain(:, i)./factor(i);
end