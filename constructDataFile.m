function dataArr = constructDataFile(cutOffDate)

load 'bookValuePerShare.csv';
load 'SandPPriceData.csv';
load 'treasuryData.csv';

closePriceCol = 5;
treasuryCol = 3;
dataArr(:,1) = bookValuePerShare(:,1);
numEle = length(dataArr(:,1));

i = 0;
isCutOff = 0;

while ((isCutOff == 0) && (i < numEle))
    i = i + 1;
    if( datenum(num2str(dataArr(i,1)),'yyyymmdd') >= datenum(cutOffDate,'yyyymmdd'))
        isCutOff = 1;
        sprintf('isCutOff is True at %s-date',num2str(dataArr(i,1)))
    else
        isCutOff = 0;
    end

    [dayNum dayName] = weekday(datenum(num2str(dataArr(i,1)),'yyyymmdd'));    
    % Logic to check for sunday or saturday and check for that
    index = [];
    goBack = -1;
    toCheckDate = dataArr(i,1);
   
    while((isempty(index)) && (toCheckDate >= dataArr(1,1)))
        goBack = goBack + 1;
        toCheckDate = dataArr(i,1) - goBack;
        index = find(SandPPriceData(:,1) == toCheckDate);         
    end
    if(~isempty(index))
        closePrice = SandPPriceData(index(1), closePriceCol);
        
        % Compute the SandPPrice data
        dataArr(i,2) = closePrice;
        
        % Compute the earnings price ratio
        %dataArr(i,3) = log(getEarnings(toCheckDate)/closePrice);
        
        dataArr(i,3) = log(Run_EPS(toCheckDate)/closePrice);
        
        % Compute booktomarket ratio as below
        dataArr(i,4) = bookValuePerShare(i,2)/closePrice;
        
        % Compute the treasury rate
        indexTBL = find(treasuryData(:,2) == toCheckDate);
        if(~isempty(indexTBL))
            dataArr(i,5) = treasuryData(indexTBL,treasuryCol)/100;
        end   
    end
end
dataArr = dataArr(1:i,:);
sprintf('Number of actual elements = %d\n',i)
% Write to file
display('Writing data to file');
fid = fopen('constructedData.csv','w+');

for j=1:i
    [row col] = size(dataArr(j,:));
    if( col == 5 )
        fprintf(fid, '%d, %f, %f, %f, %f\n', dataArr(j,1), dataArr(j,2), dataArr(j,3),dataArr(j,4), dataArr(j,5));
    end
end

fclose(fid);
end
