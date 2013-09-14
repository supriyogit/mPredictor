clear all;

%load '/Data/selectedFields.csv';
load 'selectedFields.csv'
[numRows numCols] = size(selectedFields);
originalIndexValues = zeros(numRows,1);

for r = 1:numRows
    if( r ~= 1)
        originalIndexValues(r-1) = (selectedFields(r,2) - selectedFields(r-1,2))/selectedFields(r-1,2);
        if(originalIndexValues(r-1) >= 0)
            selectedFields(r-1,2) = 1;
        else
            selectedFields(r-1,2) = -1;
        end
    end
    if(r ~= numRows)
        for colIndex = 3:4
            selectedFields(r,colIndex) = (selectedFields(r+1,colIndex) - selectedFields(r, colIndex))/selectedFields(r,colIndex);
        end
    end
end

selectedFields = selectedFields(2:numRows-1,:);
originalIndexValues = originalIndexValues(2:numRows-1);

% Adding an extra dummy line for the prediction

[numRows numCols] = size(selectedFields);
selectedFields(numRows+1, :) = selectedFields(numRows, :);

[numRows numCols] = size(selectedFields);
X = selectedFields(:,3:numCols);
Y = selectedFields(:,2);

% Randomly partitions observations into a training set and a test
% set using stratified holdout
% P = cvpartition(Y,'Holdout',0.20);
% Use a linear support vector machine classifier
initialTrain = ceil(0.6*numRows);
testVector = zeros(numRows,1,'int8');
trainVector = zeros(numRows,1,'int8');
trainVector(1:initialTrain-1) = ones(1,initialTrain-1,'int8');
%trainVector(initialTrain+1) = 1;
predictionAcc = zeros(numRows-initialTrain,3,'int8');

j = 1;
for k = initialTrain:numRows-1
    sprintf('Iteration Number = %d',j);
    trainVector(k) = 1;
    testVector(k+1) = 1;
    
    sprintf('Test Vector Size = %d',length(find(testVector == 1)))
    sprintf('Train Vector Size = %d',length(find(trainVector == 1)))
    
    svmStruct = svmtrain(X(logical(trainVector),:),Y(logical(trainVector)),'kernel_function','rbf');
    C = svmclassify(svmStruct,X(logical(testVector),:));
    predictionAcc(j,1) = Y(k+1);
    predictionAcc(j,2) = C;
    if(Y(k+1) ~= C)
        predictionAcc(j,3) = -1;
    else
        predictionAcc(j,3) = 1;
    end
    j = j + 1;
    
    testVector(k+1) = 0;    
end

%svmStruct = svmtrain(X(P.training,:),Y(P.training),'kernel_function','rbf');
%C = svmclassify(svmStruct,X(P.test,:));
errRate = sum(predictionAcc(:,1)~= predictionAcc(:,2))/(numRows-initialTrain);  %mis-classification rate
plot(originalIndexValues(initialTrain:numRows-1), predictionAcc(:,3),'*--');
axis([-0.5 0.5 -1.5 1.5]);
%conMat = confusionmat(Y(P.test),C); % the confusion matrix
