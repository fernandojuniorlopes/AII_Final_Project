data = readtable('data_malignant.txt');
data = removevars(data,"Var1");
head(data)
data.Var5 = categorical(data.Var5);
data.Var5 = categorical(data.Var5, ...
    ["M","B"],"Ordinal",true);

rng(4) % For reproducibility of the partition
c = cvpartition(data.Var5,"Holdout",0.11);
%0.33 - 0.59 accuracy
trainingIndices = training(c); % Indices for the training set
testIndices = test(c); % Indices for the test set
creditTrain = data(trainingIndices,:);
creditTest = data(testIndices,:);
Mdl = fitcnet(creditTrain,"Var5")
testAccuracy = 1 - loss(Mdl,creditTest,"Var5", ...
    "LossFun","classiferror")
confusionchart(creditTest.Var5,predict(Mdl,creditTest))