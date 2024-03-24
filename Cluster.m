filename = "Marcel OK.xlsx";
[XC,textXls,both] = xlsread(filename);
X=XC(:,2:3);
XE=XC(:,5);
[noofSamp,noofchan]=size(X);
noofClusters = 20;
meanT = zeros(noofClusters+1,3);
meanT1 = zeros(noofClusters+1,3);
indCluster = linspace(1,noofClusters+1,noofClusters+1)';
strCluster = string(1:noofClusters);

dataczas = datetime(textXls(:,1));
dataczasnum = datenum(dataczas);
minmaxDays = minmax(dataczasnum');
dataczasnum = datenum(dataczas-minmaxDays(1));
stddataczas = std(dataczasnum);
stdXY = std(X);
stdCoefficient = (stdXY(1).^2+stdXY(2).^2).^0.5/stddataczas;
dataczasnumDays = dataczasnum;
dataczasnum = stdCoefficient*dataczasnum;

X = horzcat(X,dataczasnum);

T1 = clusterdata(X,'Linkage','ward','SaveMemory','on','Maxclust',noofClusters); 
for i = 1:noofClusters+1
if i==noofClusters+1    
meanT1(i,1:3) = mean(X(:,1:3));
else
meanT1(i,1:3) = mean(X(T1(:,1)==i,1:3));    
end
end
meanT1(:,3) = meanT1(:,3)/stdCoefficient;

maxTE1 = zeros(noofClusters+1,1);
meanTE1 = zeros(noofClusters+1,1);
medianTE1 = zeros(noofClusters+1,1);

dataczasminT1 = (datetime('now')+seconds(1:noofClusters+1))';
dataczasmaxT1 = (datetime('now')+seconds(1:noofClusters+1))';
numelT1 = zeros(noofClusters+1,1);
for i = 1:noofClusters+1
 if i==noofClusters+1   
 dataczasminT1(i) = min(dataczas(:,1));
 dataczasmaxT1(i) = max(dataczas(:,1));
 numelT1(i) = numel(dataczas(:,1));
 else
 dataczasminT1(i) = min(dataczas(T1(:,1)==i,1));
 dataczasmaxT1(i) = max(dataczas(T1(:,1)==i,1));
 numelT1(i) = numel(dataczas(T1(:,1)==i,1));     
 end    
end
dataczasDaysT1 = datenum(dataczasmaxT1-dataczasminT1);

xlswrite("MarcelXYT.xlsx",[datestr(dataczas,'dd.mm.yyyy HH:MM:SS') string(XC) string(dataczasnumDays) string(T1)]);

xlswrite("MarcelXYTMean.xlsx",[string(horzcat(meanT1,indCluster)) string(numelT1) datestr(dataczasminT1,'dd.mm.yyyy HH:MM:SS') datestr(dataczasmaxT1,'dd.mm.yyyy HH:MM:SS') string(dataczasDaysT1) string(maxTE1) string(meanTE1) string(medianTE1)],'7');
