function combinedStruct = readAllFiles( dirname )
%readAllFiles goes through all xls files in the directory and creates table
%from each file containing miRNA name and reads

% get the names of all files. dirListing is a struct array.
%dirListing = dir(dirname);
dirnamesall = struct2cell(dir(dirname)); %get filename from the directory
dirnamesall = dirnamesall(1, :)';
%regular expression to extract only .xls or .xlsx files
%tmp1 = (regexpi(dirnamesall, '(\w*LBK\w*\.xls)|(\w*LBK\w*\.xlsx)', 'match')); 
tmp1 = (regexpi(dirnamesall, '(\w*\.xls)|(\w*\.xlsx)|(\w*\.tsv)|(\w*\.txt)|(\w*\.normalized_results)|(\w*\.mirna.quantification.txt)', 'match')); 
filenames = sort(dirnamesall(~cellfun(@isempty,tmp1)));
combinedStruct = struct('sample', {});

h = waitbar(0,'Please wait...');
for i = 1:length(filenames)
    waitbar(i/length(filenames));
     %place sample name as the title for read count
    f = filenames(i); f = cell2mat(f);
    k1 = strfind(f, '.xlsx');
    k2 = strfind(f, '.tsv');
    k3 = strfind(f, '.normalized_results');
    k4 = strfind(f, '.mirna.quantification.txt');
    k5 = strfind(f, '.txt');
    k6 = strfind(f, '.xls');
    if ~isempty(k1)
        %import miRNA names and reads from the xls file
        
        tableout = importxlsxSpecific(dirname,  cell2mat(filenames(i)));
        k = k1;
    elseif ~isempty(k2)
        %import miRNA names and reads from the tsv file
        tableout = importfile_tsv([dirname '\' cell2mat(filenames(i))]);
        k = k2;
    elseif ~isempty(k3)
        %import data from .results file
        tableout = importfile_res([dirname '\' cell2mat(filenames(i))]);
        k = k3;
    elseif ~isempty(k4)
        %import data from .results file
        tableout = importfile_mir([dirname '\' cell2mat(filenames(i))]);
        k = k4;
    elseif ~isempty(k5)
        %import miRNA names and reads from the tsv file
        %class(dirname)
        tableout = txtImport((dirname), cell2mat(filenames(i)));  %this is where you go to change it back
        k = k5;    
    else
        %import miRNA names and reads from the xls file
        filenames(i)
        tableout = importGeneral(dirname, filenames(i));
        k = k6;
    end  
   
    sample_name = f(1:k-1);
    %sample_name = regexp(filenames(i),'\w+(?=\w*\.[xlsx])','match');
   
    tableout(1,2) = {sample_name};
    %add table to struct
    combinedStruct(i).sample = tableout;
end
close(h);
end

