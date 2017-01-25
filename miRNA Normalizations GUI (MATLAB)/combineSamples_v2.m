function mergedData = combineSamples_v2(study_struct)
%combines all samples into one cell array


%each sample has different number of miRNA's
%get all miRNA names into one vector and remve duplicates
allmirnas = [];

for i=1:length(study_struct)
    allmirnas = [allmirnas; study_struct(i).sample(2:end, 1)];
end
%remove duplicates
[~,ind]=unique(allmirnas);
listOfmiRNAs = allmirnas(ind);
listOfmiRNAs = sort(listOfmiRNAs);

mergedData = cell(length(listOfmiRNAs)+1, length(study_struct)+1);
mergedData(:, 1) = ['miRNAnames'; listOfmiRNAs];
mergedData(2:end, 2:end) = {0};
mergedData_rf = mergedData;

%fill in the data from the struct. Assumption, if a sample doesn't have a
%value for an miRNA, its count is 0
for i=1:length(study_struct)
    mergedData(1, i+1) = study_struct(i).sample(1, 2);
    mergedData_rf(1, i+1) = study_struct(i).sample(1, 2);
    currListOfmiRNAs = study_struct(i).sample(2:end, 1);
    %disp(['curr sample ' study_struct(i).sample(1, 2)]);
    for j = 2:length(study_struct(i).sample(1:end, 1))
        curr_mirna = cell2mat(study_struct(i).sample(j, 1));
        ind = find(strcmpi(listOfmiRNAs, curr_mirna)); 
        s = find(strcmpi(currListOfmiRNAs, curr_mirna)); 
        
        count = nanmean(cell2mat(study_struct(i).sample(s+1, 2)));
        if length(s)>1
            %disp(['Same name mirna: ' curr_mirna ' total ' num2str(length(s))]);
        end
        if ~isempty(ind)
            mergedData(ind+1, i+1) = {count};
        else
            disp(['Error, mirna not found' currmirna]);
        end        
    end
    %mergedData(end, i+1) = {sum(cell2mat(mergedData(2:end-1, i+1)))};
%     %check that sums match the original
%     orig = sum(cell2mat(study_struct(i).sample(2:end, 2)));
%     if orig ~= cell2mat(mergedData(end, i+1))
%         disp(['Error, sums do not match for sample, i= ' num2str(i)]);
%     end
    %mergedData_rf(2:end, i+1) = num2cell(cell2mat(mergedData(2:end, i+1))/cell2mat(mergedData(end, i+1)));
end
end