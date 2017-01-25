function Trimmedregionreport = importMerged(dirname,filename)
class(filename)
[~, ~, Trimmedregionreport] = xlsread([dirname '/' filename]);
Trimmedregionreport(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),Trimmedregionreport)) = {''};