stocknames_all = unique(stockpricecombined.assetName);
%dates = datetime(2016,10,6,'Format','dd-MMM-yyyy'):caldays(1):datetime(2016,12,30);
%data = table;

% for i = 1:numel(stocknames_all)
%     for j = 1:numel(dates)
%         stocknames = stocknames_all(i);
%         date = dates(j);
%         [predictors] = preprocess(date,stocknames,news_raw);
%         data = [data;predictors];
%     end
% end
%%
news_date = news.time;
for i = 1:length(news_date)
    news_date{i} = strsplit(news_date{i});
    news_date{i} = news_date{i,1}(1);
end
news_date = cellfun(@datetime,news_date);
news.time = news_date;

assetCodes = news.assetName;
for i = 1:length(assetCodes)
    assetCodes{i} = strsplit(assetCodes{i},',');
    assetCodes{i} = erase(assetCodes{i},{' ','{','}'});
    assetCodes{i} = strrep(assetCodes{i},'''','');
end
news.assetName = assetCodes;

%%
FinalNewsTable = table;
days = unique(news.time);
for s = 1:numel(stocknames_all)
    stock = stocknames_all(s);
    stock = erase(stock,{' ',''''});
    stock = repmat(stock,height(news),1);
    idx1 = cellfun(@strcmp,news.assetName,stock);
    sub_table = news(idx1,:);
    days = unique(sub_table.time);
    temp = [];
    for d = 1:length(days)
        day = days(d);
        idx2 = sub_table.time == day;
        temp = [temp;sum(sub_table{idx2,[6, 7, 11, 12, 15, 16, 19:35]},1)];
    end
    if s == 1
        FinalNewsTable.time = days;
        FinalNewsTable.assetName = repmat(stocknames_all(s),numel(days),1);
        FinalNewsTable.urgency = temp(:,1);
        FinalNewsTable.takeSequence = temp(:,2);
        FinalNewsTable.bodySize = temp(:,3);
        FinalNewsTable.companyCount = temp(:,4);
        FinalNewsTable.sentenceCount = temp(:,5);
        FinalNewsTable.wordCount = temp(:,6);
        FinalNewsTable.firstMentionSentence = temp(:,7);
        FinalNewsTable.relevance = temp(:,8);
        FinalNewsTable.sentimentClass = temp(:,9);
        FinalNewsTable.sentimentNegative = temp(:,10);
        FinalNewsTable.sentimentNeutral = temp(:,11);
        FinalNewsTable.sentimentPositive = temp(:,12);
        FinalNewsTable.sentimentWordCount = temp(:,13);
        FinalNewsTable.noveltyCount12H = temp(:,14);
        FinalNewsTable.noveltyCount24H = temp(:,15);
        FinalNewsTable.noveltyCount3D = temp(:,16);
        FinalNewsTable.noveltyCount5D = temp(:,17);
        FinalNewsTable.noveltyCount7D = temp(:,18);
        FinalNewsTable.volumeCounts12H = temp(:,19);
        FinalNewsTable.volumeCounts24H = temp(:,20);
        FinalNewsTable.volumeCounts3D = temp(:,21);
        FinalNewsTable.volumeCounts5D = temp(:,22);
        FinalNewsTable.volumeCounts7D = temp(:,23);
    else     
        tempT = table;
        tempT.time = days;
        tempT.assetName = repmat(stocknames_all(s),numel(days),1);
        tempT.urgency = temp(:,1);
        tempT.takeSequence = temp(:,2);
        tempT.bodySize = temp(:,3);
        tempT.companyCount = temp(:,4);
        tempT.sentenceCount = temp(:,5);
        tempT.wordCount = temp(:,6);
        tempT.firstMentionSentence = temp(:,7);
        tempT.relevance = temp(:,8);
        tempT.sentimentClass = temp(:,9);
        tempT.sentimentNegative = temp(:,10);
        tempT.sentimentNeutral = temp(:,11);
        tempT.sentimentPositive = temp(:,12);
        tempT.sentimentWordCount = temp(:,13);
        tempT.noveltyCount12H = temp(:,14);
        tempT.noveltyCount24H = temp(:,15);
        tempT.noveltyCount3D = temp(:,16);
        tempT.noveltyCount5D = temp(:,17);
        tempT.noveltyCount7D = temp(:,18);
        tempT.volumeCounts12H = temp(:,19);
        tempT.volumeCounts24H = temp(:,20);
        tempT.volumeCounts3D = temp(:,21);
        tempT.volumeCounts5D = temp(:,22);
        tempT.volumeCounts7D = temp(:,23);
        
        FinalNewsTable = vertcat(FinalNewsTable,tempT);
    end
    
end
    
%save('FinalNewsTable','FinalNewsTable') 
%% 
price_date = stockpricecombined.time;
for i = 1:length(price_date)
    strTemp = strsplit(price_date(i));
    price_date(i) = strTemp(1);
end
price_date = cellfun(@datetime,price_date);
stockpricecombined.time = price_date;
%%
assetCodes = stockpricecombined.assetName;
for i = 1:length(assetCodes)
%     assetCodes(i) = strsplit(assetCodes(i),',');
    assetCodes(i) = erase(assetCodes(i),{' ','{','}'});
    assetCodes(i) = strrep(assetCodes(i),'''','');
end
stockpricecombined.assetName = assetCodes;

%% 
% CombinedStockNews = stockpricecombined;
for s = 1:numel(stocknames_all)
    stockname = stocknames_all(s);
    idx1 = strcmp(stockpricecombined.assetName,stockname);
    temp1 = stockpricecombined(idx1,:);
    idx2 = strcmp(FinalNewsTable.assetName,stockname);
    temp2 = FinalNewsTable(idx2,:);
    date1 = temp1.time;
    date2 = temp2.time;
    date3 = datetime(date2,'Format','eeee');
    idx_weekend = isweekend(date3);
    idx_Fri = find(isweekend(date3))-1;
    temp3 = [];    
    for t = 1:numel(date1)
        n = 0;
        cdate = date1(t);
        if find(date2==cdate)
            temp3 = [temp3;temp2{find(date2==cdate),3:end}];
        else
            temp4 = zeros(1,size(temp2,2)-2);
            temp3 = [temp3;temp4];
        end
%         if t > 1
            if t<numel(date1) && duration(date1(t)-date1(t+1)) > 1
                temp5 = [];
                while cdate+1<date1(t+1)
                    cdate = cdate+1;
                    temp5 = [temp5;temp2{find(date2==cdate),3:end}];
                end
                temp5 = mean([temp3(end,:);temp5],2);
                temp3(end,:) = temp5;
            end            
%         end
    end
    stock = temp1;
    stock.urgency = temp3(:,1);
    stock.takeSequence = temp3(:,2);
    stock.bodySize = temp3(:,3);
    stock.companyCount = temp3(:,4);
    stock.sentenceCount = temp3(:,5);
    stock.wordCount = temp3(:,6);
    stock.firstMentionSentence = temp3(:,7);
    stock.relevance = temp3(:,8);
    stock.sentimentClass = temp3(:,9);
    stock.sentimentNegative = temp3(:,10);
    stock.sentimentNeutral = temp3(:,11);
    stock.sentimentPositive = temp3(:,12);
    stock.sentimentWordCount = temp3(:,13);
    stock.noveltyCount12H = temp3(:,14);
    stock.noveltyCount24H = temp3(:,15);
    stock.noveltyCount3D = temp3(:,16);
    stock.noveltyCount5D = temp3(:,17);
    stock.noveltyCount7D = temp3(:,18);
    stock.volumeCounts12H = temp3(:,19);
    stock.volumeCounts24H = temp3(:,20);
    stock.volumeCounts3D = temp3(:,21);
    stock.volumeCounts5D = temp3(:,22);
    stock.volumeCounts7D = temp3(:,23);
    
    %% save matrix
    save(strcat(stockname,'.mat'),'stock')
end

%%
CombinedStockNews = table;
for s = 1:numel(stocknames_all)
stockname = stocknames_all(s);
stock_tmp = load(strcat(stockname,'.mat'));
CombinedStockNews = vertcat(CombinedStockNews,stock_tmp.stock);
end

%% PCA
X = CombinedStockNews{:,3:end};
X = zscore(X,0,1);
[COEFF,SCORE] = pca(X);

%%
save('CombinedStockNews','CombinedStockNews')