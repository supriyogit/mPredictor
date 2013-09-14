clear;

treasuryData = getFredData([],[]);

len = length(treasuryData.Data(:,1));

data{:,1} = treasuryData.Data(:,1);
data{:,2} = datestr(datenum(treasuryData.Data(:,1)),'yyyymmdd');
data{:,3} = treasuryData.Data(:,2);

% Write to file
display('Writing data to file');
fid = fopen('treasuryData.csv','w+');

for i=1:len
    fprintf(fid, '%d,%s,%f\n', data{1,1}(i), data{1,2}(i,:), data{1,3}(i));
end

fclose(fid);