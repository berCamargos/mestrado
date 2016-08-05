delete(instrfindall)
clear all
close all
s = serial('/dev/ttyUSB0','BaudRate',115200);
fopen(s)
maxsize = 1000
a = zeros(maxsize,3)';
cnt = 0;
b = [];
real = [];
counter = 0;
while 1==1
    b = [b;fscanf(s,'%d')];
    counter = counter + 1;
    if b(end) == -100000
        real = [real;b(1:end-1)];
        if size(real,1)>3*1000
            real = real(end-3*1000:end);
        end
        b = [];
    end
    if counter > 100
        if(size(real,1) > 100)
            a = [real(1:3:end) real(2:3:end) real(3:3:end)];
            plot(a)
            axis([0 floor(size(real,1)/3) -2^15 2^15])
            drawnow();
        end
        counter  = 0;
    end
    
end
fclose(s);
delete(s)
