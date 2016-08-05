delete(instrfindall)
clear all
close all
s = serial('/dev/ttyUSB1','BaudRate',115200);
fopen(s)
NUM_SENSORS = 6;
maxsizePlot = 10^4
maxsizeHist = 10^6
cnt = 0;
b = [];
tempAccX = [];
tempAccY = [];
tempAccZ = [];
tempGyX = [];
tempGyY = [];
tempGyZ = [];
tempEuler = [];
X = [1;0;0;0];
P = eye(4);
acc = zeros(maxsizePlot,3);
gy = zeros(maxsizePlot,3);
euler = zeros(maxsizePlot,3);
counter = 0;
while 1==1
    b = [b;fscanf(s,'%d')];
    counter = counter + 1;
    if b(end) == -100000
        if size(b,1) == 257
            tempAccX = b(1:NUM_SENSORS:end);
            tempAccY = b(2:NUM_SENSORS:end);
            tempAccZ = b(3:NUM_SENSORS:end);

            tempGyX  = b(4:NUM_SENSORS:end);
            tempGyY  = b(5:NUM_SENSORS:end);
            tempGyZ  = b(6:NUM_SENSORS:end);

            minLen = min([size(tempAccX,1),size(tempAccY,1),size(tempAccZ,1),size(tempGyX,1),size(tempGyY,1),size(tempGyZ,1)]);

            tempGyX = tempGyX(1:minLen);
            tempGyY = tempGyY(1:minLen);
            tempGyZ = tempGyZ(1:minLen);
            tempAccX = tempAccX(1:minLen);
            tempAccY = tempAccY(1:minLen);
            tempAccZ = tempAccZ(1:minLen);
            euler = [tempEuler(end:-1:1,:); euler(1:end-minLen,:)];

            acc(:,1) = [tempAccX(end:-1:1); acc(1:end-(size(tempAccX,1)),1)];  
            acc(:,2) = [tempAccY(end:-1:1); acc(1:end-(size(tempAccY,1)),2)];  
            acc(:,3) = [tempAccZ(end:-1:1); acc(1:end-(size(tempAccZ,1)),3)];  

            gy(:,1) = [tempGyX(end:-1:1); gy(1:end-(size(tempGyX,1)),1)];  
            gy(:,2) = [tempGyY(end:-1:1); gy(1:end-(size(tempGyY,1)),2)];  
            gy(:,3) = [tempGyZ(end:-1:1); gy(1:end-(size(tempGyZ,1)),3)];  
        end
        b = [];
    end
    if counter > 2000
        if(size(acc,1) > 100)

            [tempEuler,X,P] = runKalmanOnSet(acc(),[tempGyX tempGyY tempGyZ],1000, X(:,end),P);
            minLen = min([size(acc,1),size(gy,1)]);
            subplot(311)
            plot(acc)
            axis([0 minLen -2^15 2^15])
            subplot(312)
            plot(gy)
            axis([0 minLen -2^15 2^15])
            subplot(313)
            plot(euler)
            axis([0 minLen -pi pi])
            drawnow();
        end
        counter  = 0;
    end
    
end
fclose(s);
delete(s)
