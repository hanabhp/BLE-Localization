clc;
clear;
format long
%% Input Data 
data1 = xlsread('Dataset/RSSI-dataset.xlsx');
%% It has 4 columns (Beacon1, Beacon2, Beacon3, Cell num)
i=1;
k=1;
%% Computing the fingerprint for each cell
while i<size(data1,1)-16
    ave=0;
    count1=0;
    count2=0;
    count3=0;
    RSSI1=0;
    RSSI2=0;
    RSSI3=0;
    for j=i:size(data1)
        if data1(j,5)~=k
            break;
        end
%         if data1(i,2)~=0 
            RSSI1=RSSI1+data1(j,2); 
            count1=count1+1;
%         end
%         if data1(i,3)~=0 
            RSSI2=RSSI2+data1(j,3); 
            count2=count2+1;
%         end
%         if data1(i,4)~=0
            RSSI3=RSSI3+data1(j,4);
            count3=count3+1;
%         end
    end
    finger(k,1)=RSSI1/count1;
    finger(k,2)=RSSI2/count2;
    finger(k,3)=RSSI3/count3;
%% Computing and storing the average of measured RSSI of Beacons for each cell
    RSSI1=0;
    RSSI2=0;
    RSSI3=0;
    for j=i:size(data1)
        if data1(j,5)~=k
            break;
        end
%         if data1(i,2)~=0
        RSSI1=RSSI1+abs(data1(j,2)-finger(k,1));
%         end
%         if data1(i,3)~=0
        RSSI2=RSSI2+abs(data1(j,3)-finger(k,2));
%         end
%         if data1(i,4)~=0
        RSSI3=RSSI3+abs(data1(j,4)-finger(k,3));
%         end
    end
    finger(k,4)=RSSI1/count1;
    finger(k,5)=RSSI2/count2;
    finger(k,6)=RSSI3/count3;
%% Computing and storing the Variance of measured RSSI of Beacons for each cell
    i=j;
    k=k+1;
end


K = 10;
CrossValIndices = crossvalind('Kfold', size(data1,1), K);

for i = 1: K
display(['Cross validation, folds ' num2str(i)])
IndicesI = CrossValIndices==i;
TempInd = CrossValIndices;
TempInd(IndicesI) = [];
xTraining = data1(CrossValIndices~=i,:);
tTrain = xTraining(:,5);
xTest = data1(CrossValIndices ==i,:);
tTest = xTest(:,5);

xTraining=transpose(xTraining);
tTrain=transpose(tTrain);
xTest=transpose(xTest);
tTest=transpose(tTest);

net0=fitnet(20);
[net0,tr0]=train(net0,xTraining(2:4,:),tTrain);
f_out=net0(xTest(2:4,:));
for j=1:size(f_out,2)
    x1=Xcordinate(f_out(1,j));
    y1=Ycordinate(f_out(1,j));
    x2=Xcordinate(xTest(5,j));
    y2=Ycordinate(xTest(5,j));
    tabl2(i,j)=sqrt(abs(x1-x2)^2+abs(y1-y2)^2);
end
end
kh=0;
i=1;
while i<16
    temp=0;
    temp1=0;
    for j=1:size(tabl2,2)
        if tabl2(1,j)>=kh && tabl2(1,j)<kh+0.5
            temp=temp+1;
        end
%         if tabl2(j,2)>=kh && tabl2(j,2)<kh+0.5
%             temp1=temp1+1;
%         end
    end
    table(i,1)=temp;
    table(i,2)=temp1;
    kh=kh+0.5;
    i=i+1;
end
table=table/53;
% options = fcmOptions(NumClusters=9);
% [centers,U] = fcm(xTraining,options);
finger_dist=0;
proposed_dist=0;




normal=zeros(2,10);
for i=1:size(xTest)
    all=0;
    for j=1:size(finger,1)
        dis(i,j)=sqrt((abs(xTest(i,2)-finger(j,1))^2)+(abs(xTest(i,3)-finger(j,2))^2)+(abs(xTest(i,4)-finger(j,3))^2));
        all=all+dis(i,j);
        %p_distance=pdist(X,'euclidean');
    end
    for j=1:size(finger,1)
        dis(i,j)=dis(i,j)/all;
    end
    bigest1=0;
    bigest2=0;
    bigest3=0;
    kh1=0;
    kh2=0;
    kh3=0;
    for j=1:size(dis,2)
        if dis(i,j)>bigest1
            bigest3=bigest2;
            bigest2=bigest1;
            bigest1=dis(i,j);
            kh3=kh2;
            kh2=kh1;
            kh1=j;
        else
            if dis(i,j)>bigest2
                bigest3=bigest2;
                bigest2=dis(i,j);
                kh3=kh2;
                kh2=j;
            else
                if dis(i,j)>bigest3
                    bigest3=dis(i,j);
                    kh3=j;
                end
            end
        end
    end
    %% Computing the location of three location with the highest probability
    x1=Xcordinate(kh1);
    y1=Ycordinate(kh1);
    
    x2=Xcordinate(kh2);
    y2=Ycordinate(kh2);
    
    x3=Xcordinate(kh3);
    y3=Ycordinate(kh3);
    num=0;
%% Checking the position of point compare to wall to consider acceptable value
    if kh1==9 || kh1==8 || kh1==7
        num=num+1;
    end
    if kh2==9 || kh2==8 || kh2==7
        num=num+1;
    end
    if kh3==9 || kh3==8 || kh3==7
        num=num+1;
    end
    
    if num >1
        if kh1==9 || kh1==8 || kh1==7
            bigest1=bigest1+bigest1/10;
        else
            bigest1=bigest1-bigest1/10;
        end
        if kh2==9 || kh2==8 || kh2==7
            bigest2=bigest2+bigest2/10;
        else
            bigest2=bigest2-bigest2/10;
        end
        if kh3==9 || kh3==8 || kh3==7
            bigest3=bigest3+bigest3/10;
        else
            bigest3=bigest3-bigest3/10;
        end

    end
    
 %% Computing the Location Estimation error
        finalx=(x1*bigest1)+(x2*bigest2)+(x3*bigest3);
        finaly=(y1*bigest1)+(y2*bigest2)+(y3*bigest3);
        erroe(i,1)=sqrt(abs(Xcordinate(bigest1)-Xcordinate(xTest(i,5)))^2+abs(Ycordinate(bigest1)-Ycordinate(xTest(i,5)))^2);
        finger_dist=finger_dist+erroe(i,1);
        erroe(i,2)=sqrt(abs(finalx-Xcordinate(xTest(i,5)))^2+abs(finaly-Ycordinate(xTest(i,5)))^2);
        proposed_dist=proposed_dist+erroe(i,2);
        
        normal(1,kh1)=normal(1,kh1)+erroe(i,2);
        normal(2,kh1)=normal(2,kh1)+1;
    
end

for i=1:10
    normal(1,i)=normal(1,i)/normal(2,i);
end

finger_dist=finger_dist/53;
proposed_dist=proposed_dist/53;

%% ERROR Figures


kh=0;
i=1;
while i<8
    temp=0;
    temp1=0;
    for j=1:size(erroe,1)
        if erroe(j,1)>=kh && erroe(j,1)<kh+0.5
            temp=temp+1;
        end
        if erroe(j,2)>=kh && erroe(j,2)<kh+0.5
            temp1=temp1+1;
        end
    end
    table(i,1)=temp;
    table(i,2)=temp1;
    kh=kh+0.5;
    i=i+1;
end




