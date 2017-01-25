function saveThings(fullname, mergedDataOut)
[nrows, ncols] = size(mergedDataOut);
fileID = fopen(fullname,'w');
%formatSpec of the strings
formatSpec = '%s';
i = 0;
while i < ncols - 1
    formatSpec = [formatSpec ',%s'];
    i = i+1;
end
formatSpec = [formatSpec '\n'];

fprintf(fileID,formatSpec,mergedDataOut{1,:});

formatSpec = '%s';
j = 0;
while j< ncols -1
    formatSpec = [formatSpec ',%d'];
    j = j+1;
end
formatSpec = [formatSpec '\n'];

for row = 2:nrows
    fprintf(fileID,formatSpec,mergedDataOut{row,:});
end

fclose(fileID);
end