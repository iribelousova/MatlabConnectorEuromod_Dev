function license(tlbx)
% Open the file in read mode
fileID = fopen('Licence.txt', 'r');

% Check if the file was opened successfully
if fileID == -1
    error('File could not be opened. Check the file path and try again.');
end

% Read the file line by line and print each line to the console
while ~feof(fileID)
    line = fgetl(fileID);
    disp(line);
end

% Close the file
fclose(fileID);
end



