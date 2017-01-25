function dataArray = readFastQ(filename)

%open the file
fileID = fopen(filename,'r');
dataArray = {};

%collect the sequence data
m = 1;
%skip first line
tline = fgetl(fileID);
while ~feof(fileID)
 dataArray{m} = length(fgetl(fileID));
 
 m = m+1;
 %skip 3 line
 for n=1:3
   tline = fgetl(fileID);
 end

end
%close the file
fclose(fileID);