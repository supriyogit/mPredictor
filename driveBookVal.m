clear all;

% Update the book value of S&P500

load 'bookValuePerShare.csv';
[row col] = size(bookValuePerShare);
lastDate = bookValuePerShare(row,1);
lastDateNum = datenum(num2str(lastDate), 'yyyymmdd');
currDateNum = datenum(date);

if( currDateNum > lastDateNum )
    d = addtodate(lastDateNum,1,'month');
    d = addtodate(d,1,'day'); % same as eom date
    searchDate = datestr(d,'mmm. dd, yyyy');
    dataRow = 2;
    dataCol = 2;
    currBookVal = getBookVal(searchDate, dataRow, dataCol);
    if( currBookVal == -1 )
        disp('YChart does not have the value listed');
    else
        fid = fopen('bookValuePerShare.csv','a');
        for i = 1:12
            d = addtodate(datenum(num2str(lastDate),'yyyymmdd'),i,'month');
            
            if(month(d) <= 9)
                monthStr = strcat(num2str(0), num2str(month(d)));
            else
                monthStr = num2str(month(d));
            end
            f1 = str2double(strcat(num2str(year(d)), monthStr, num2str(eomday(year(d), month(d)))));
            fprintf(fid, '%d,%7.4f\n', f1, currBookVal);
        end
        fclose(fid);
    end
else
    disp('No Update needed');
end
