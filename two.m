clc;
clear all;
close all;

fid = fopen('2.ffs', 'r');

data = [];
while ~feof(fid)
    line = fgetl(fid);
    if contains(line, 'Phi, Theta, Re(E_Theta), Im(E_Theta), Re(E_Phi), Im(E_Phi)')
        break;
    end
end
while ~feof(fid)
    line = fgetl(fid);
    values = sscanf(line, '%f %f %f %f %f %f')';
    if numel(values) == 6
        data = [data; values];
    end
end
fclose(fid);

save('converted_data.mat', 'data');
disp('Check .ffs file header for frequency');
