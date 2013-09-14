clear all;

symbol = '^GSPC';
startYear = '1982';

[hist_date, hist_high, hist_low, hist_open, hist_close, hist_vol] = get_hist_SandP(symbol,startYear);

len = length(hist_date);

data{:,1} = hist_date;
data{:,2} = hist_high;
data{:,3} = hist_low;
data{:,4} = hist_open;
data{:,5} = hist_close;
data{:,6} = hist_vol;

% Write to file
display('Writing data to file');
fid = fopen('SandPPriceData.csv','w+');

for i=1:len
    fprintf(fid, '%s, %f, %f, %f, %f, %f\n', strrep(data{1,1}{i},'-',''), data{1,2}(i), data{1,3}(i), data{1,4}(i), data{1,5}(i), data{1,6}(i));
end

fclose(fid);