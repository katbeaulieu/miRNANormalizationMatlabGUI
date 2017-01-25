function dataout = computeRF(datain)
%computes relative frequency of the input data
%data format: rows - miRNAs, collumns - samples
%data is double

dataout = datain;

totals = nansum(datain);

for i=1:size(datain, 2)
   dataout(:, i) = datain(:, i)./totals(i);
end