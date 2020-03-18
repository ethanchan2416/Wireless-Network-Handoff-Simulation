clear; clc; close all;
tic
T = 1:1:600;
Init_Coors = [750, 750, 1] .* [0, 1, 2; 0, 2, 2; 0, 3, 2;
                               1, 4, 3; 2, 4, 3; 3, 4, 3;
                               4, 3, 4; 4, 2, 4; 4, 1, 4;
                               3, 0, 1; 2, 0, 1; 1, 0, 1;];  %... clockwise

nCar = 0;
nHandoffArray = zeros(86400, 4);
Psum = zeros(86400, 5);
nXBoundHandoff = 0;
for t=1:length(T)
    % 1. add new cars
    nNew = 0;
    for i=1:length(Init_Coors)
        if poissonGenerateCar
            nCar = nCar + 1;
            nNew = nNew + 1;
            CarRoster(nCar) = CCar(Init_Coors(i,1), Init_Coors(i,2), Init_Coors(i,3));
        else
            continue
        end
    end

    if nCar > 0
        % 2. car stepdrive
        stepDrive(CarRoster);
        
        % 2. get nHandoff from cars that exceeded bounds in this sec
        nXBoundHandoff = getNXBoundHandoff(CarRoster, nXBoundHandoff);
        
        % 3. if car exceed bounds remove car
        CarRoster = isInbounds(CarRoster);
        nCar = numel(CarRoster);
        
        % 4. calculate handoff methods
        bestSigMethod(CarRoster);
        thresholdMethod(CarRoster);
        entropyMethod(CarRoster);
        myMethod(CarRoster);
        
        % plot simulation
        plotCCar(CarRoster, nCar, "my");
        pause(0.01);
    end
    
    % 5. tally total handoffs until t sec
    if nCar == 0
        nHandoffArray(t,:) = 0;
    else
        nHandoffArray(t,:) = tallyHandoff(CarRoster, nXBoundHandoff);
    end
    
    % 6. record Paverage at t sec
    if nCar == 0
        Psum(t,:) = 0;
    else
        Psum(t,:) = getPsumPerSec(CarRoster);
    end
    
end

Pavg = sum(Psum(:,2:5)) / sum(Psum(:,1));
toc

%% plot
figure
grid on; hold on;
lgn_txt = sprintf('Best, Pavg = %.3f dBm', Pavg(1));
plot(T, nHandoffArray(1:length(T), 1), 'DisplayName',lgn_txt, 'LineWidth',0.75);
lgn_txt = sprintf('Threshold, Pavg = %.3f dBm', Pavg(2));
plot(T, nHandoffArray(1:length(T), 2), 'DisplayName',lgn_txt, 'LineWidth',0.75);
lgn_txt = sprintf('Entropy, Pavg = %.3f dBm', Pavg(3));
plot(T, nHandoffArray(1:length(T), 3), 'DisplayName',lgn_txt, 'LineWidth',0.75);
lgn_txt = sprintf('Mine, Pavg = %.3f dBm', Pavg(4));
plot(T, nHandoffArray(1:length(T), 4), 'DisplayName',lgn_txt, 'LineWidth',0.75);
lgn = legend; lgn.FontSize = 16;
xlabel('Time (Sec)', 'FontSize',16);
ylabel('Num of Handoff', 'FontSize',16);

%% functions
function stepDrive(ObjArray)
    for i=1:numel(ObjArray)
        ObjArray(i).stepDrive;
    end
end

function new_nXBoundHandoff = getNXBoundHandoff(ObjArray, nXBoundHandoff)
    car_num = numel(ObjArray);
    nXBoundHandoffThisSec = 0;
    for i=car_num:-1:1
        if ObjArray(i).status == 0
            nXBoundHandoffThisSec = nXBoundHandoffThisSec + ObjArray(i).Handoff;
        end
    end
    new_nXBoundHandoff = nXBoundHandoff + nXBoundHandoffThisSec;
end

function ObjArray = isInbounds(ObjArray)
    car_num = numel(ObjArray);
    for i=car_num:-1:1
        if ObjArray(i).status == 0
            ObjArray(i) = [];
        end
    end
end

function bestSigMethod(ObjArray)
    for i=1:numel(ObjArray)
        ObjArray(i).bestSigMethod;
    end
end

function thresholdMethod(ObjArray)
    for i=1:numel(ObjArray)
        ObjArray(i).thresholdMethod;
    end
end

function entropyMethod(ObjArray)
    for i=1:numel(ObjArray)
        ObjArray(i).entropyMethod;
    end
end

function myMethod(ObjArray)
    for i=1:numel(ObjArray)
        ObjArray(i).myMethod;
    end
end

function nHandoff = tallyHandoff(ObjArray, nXBoundHandoff)
    nInBoundHandoff = 0;
    for i=1:numel(ObjArray)
        nInBoundHandoff = nInBoundHandoff + ObjArray(i).Handoff;
    end
    nHandoff = nInBoundHandoff + nXBoundHandoff;
end

function PsumPerSec = getPsumPerSec(ObjArray)
    PsumPerSec = zeros(5, 1);
    PsumPerSec(1) = numel(ObjArray);
    for i=1:numel(ObjArray)
        PsumPerSec(2:5) = PsumPerSec(2:5) + ObjArray(i).Signal_power;
    end
end

function plotCCar(CarRoster, nCar, method)
    if method == "best"
        type = 1;
    elseif method == "threshold"
        type = 2;
    elseif method == "entropy"
        type = 3;
    elseif method == "my"
        type = 4;
    end
    
    nB1 = 0; nB2 = 0; nB3 = 0; nB4 = 0;
    X_B1 = zeros(1, 100); Y_B1 = zeros(1, 100);
    X_B2 = zeros(1, 100); Y_B2 = zeros(1, 100);
    X_B3 = zeros(1, 100); Y_B3 = zeros(1, 100);
    X_B4 = zeros(1, 100); Y_B4 = zeros(1, 100); 
    for j=1:nCar
        if CarRoster(j).Base(type) == 1
            nB1 = nB1 + 1;
            X_B1(nB1) = CarRoster(j).x;
            Y_B1(nB1) = CarRoster(j).y;
        elseif CarRoster(j).Base(type) == 2
            nB2 = nB2 + 1;
            X_B2(nB2) = CarRoster(j).x;
            Y_B2(nB2) = CarRoster(j).y;
        elseif CarRoster(j).Base(type) == 3
            nB3 = nB3 + 1;
            X_B3(nB3) = CarRoster(j).x;
            Y_B3(nB3) = CarRoster(j).y;
        elseif CarRoster(j).Base(type) == 4
            nB4 = nB4 + 1;
            X_B4(nB4) = CarRoster(j).x;
            Y_B4(nB4) = CarRoster(j).y;
        end
    end

    if nB1 > 0
        plot(X_B1, Y_B1, 'squareb', 'LineWidth',1)
        hold on;
    end
    if nB2 > 0
        plot(X_B2, Y_B2, 'squarer', 'LineWidth',1)
        hold on;
    end
    if nB3 > 0
        plot(X_B3, Y_B3, 'squarek', 'LineWidth',1)
        hold on;
    end
    if nB4 > 0
        plot(X_B4, Y_B4, 'squareg', 'LineWidth',1)
        hold on;
    end
    viscircles([750, 750], 1500, 'Color',[0.4660 0.6740 0.1880], 'LineWidth',0.5);
    viscircles([750, 2250], 1500, 'Color',[0 0.4470 0.7410], 'LineWidth',0.5);
    viscircles([2250, 2250], 1500, 'Color',[0.6350 0.0780 0.1840], 'LineWidth',0.5);
    viscircles([2250, 750], 1500, 'Color',[0 0 0], 'LineWidth',0.5);
    grid on; hold off;
    xticks(0:750:3000);   xlim([0 3000]);
    yticks(0:750:3000);   ylim([0 3000]);
end
