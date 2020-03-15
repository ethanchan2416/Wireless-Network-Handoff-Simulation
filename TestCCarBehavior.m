%% Try 1
clear; clc; close all;
Init_Coordinates = [750, 750, 1] .* [0, 1, 2; 0, 2, 2; 0, 3, 2;
                                     1, 4, 3; 2, 4, 3; 3, 4, 3;
                                     4, 3, 4; 4, 2, 4; 4, 1, 4;
                                     3, 0, 1; 2, 0, 1; 1, 0, 1;];  %... clockwise

for i=1:length(Init_Coordinates)
    CarRoster(i) = CCar(Init_Coordinates(i,1), Init_Coordinates(i,2), Init_Coordinates(i,3));
end

for t=1:300
    CarRoster = stepDrive(CarRoster);
    CarRoster = isInbounds(CarRoster);
end

%% Try 2
clear; clc; close all;
tic
square_length = 750;
Length_Scalar = [square_length, square_length, 1];
Init_X_Y_Direction = [0, 1, 2; 0, 2, 2; 0, 3, 2;
                      1, 4, 3; 2, 4, 3; 3, 4, 3;
                      4, 3, 4; 4, 2, 4; 4, 1, 4;
                      3, 0, 1; 2, 0, 1; 1, 0, 1;];
Init_Coordinates = Length_Scalar .* Init_X_Y_Direction;  %... clockwise

carNum = 0;
for t=1:60
    newAdded = 0;
    for i=1:length(Init_Coordinates)
        if poissonGenerateCar
            newAdded = newAdded + 1;
            carNum = carNum + 1;
            CarRoster(carNum) = CCar(Init_Coordinates(i,1), Init_Coordinates(i,2), Init_Coordinates(i,3));
        else
            continue
        end
    end
    
    if carNum > 0
        CarRoster = stepDrive(CarRoster);
%         CarRoster = BestSigMethod(CarRoster);
    end
    
    if newAdded > 0
        grid on; hold on;
        plot(CarRoster(carNum-newAdded+1:carNum).x, CarRoster(carNum-newAdded+1:carNum).y, 'o', 'LineWidth',2)
        pause(0.5);
%         hold off;
        xticks(0:750:3000);   xlim([0 3000]);
        yticks(0:750:3000);   ylim([0 3000]);
    end
    
end
toc

%% Try 3
clear; clc; close all;
tic
Init_Coordinates = [750, 750, 1] .* [0, 1, 2; 0, 2, 2; 0, 3, 2;
                                     1, 4, 3; 2, 4, 3; 3, 4, 3;
                                     4, 3, 4; 4, 2, 4; 4, 1, 4;
                                     3, 0, 1; 2, 0, 1; 1, 0, 1;];  %... clockwise
carNum = 0;
for t=1:750
    newAdded = 0;
    for i=1:length(Init_Coordinates)
        if poissonGenerateCar
            carNum = carNum + 1;
            newAdded = newAdded + 1;
            CarRoster(carNum) = CCar(Init_Coordinates(i,1), Init_Coordinates(i,2), Init_Coordinates(i,3));
        else
            continue
        end
    end

    if carNum > 0
        CarRoster = stepDrive(CarRoster);
        CarRoster = isInbounds(CarRoster);
        X_Cars = [CarRoster(:).x];   Y_Cars = [CarRoster(:).y];
        plot(X_Cars, Y_Cars, 'squareb', 'LineWidth',1)
        grid on;
        xticks(0:750:3000);   xlim([0 3000]);
        yticks(0:750:3000);   ylim([0 3000]);
        pause(0.01);
        carNum = numel(CarRoster);
    end
end
toc
%% functions
function ObjArray = stepDrive(ObjArray)
    for i=1:numel(ObjArray)
        ObjArray(i).stepDrive;
    end
end

function ObjArray = bestSigMethod(ObjArray)
    for i=1:numel(ObjArray)
        ObjArray(i).bestSigMethod;
    end
end

function ObjArray = isInbounds(ObjArray)
    car_num = numel(ObjArray);
    for i=car_num:-1:1
        if ObjArray(i).status == 0
            ObjArray(i) = [];
        end
    end
end