%% car behavior
% 1. car speed = 10 m/s
% 2. car takes 75 secs to reach intersection
% 3. if x > 3000 or y > 3000 car out of bounds
% 4. turn probability: straight 1/2, right 1/3, left 1/6
% 5. derive car object matrix [car #, x_coor, y_coor, direction]

%% Method 1 (with StepDrive)
clear; clc; close all;
t = 0:1:86400;
x_boundary = 3000; y_boundary = 3000;
x_car = 1500;       y_car = 3000;
direction = 3;
Car_Position = zeros(length(t), 2);
for i=1:length(t)
    [x_car, y_car, direction] = stepDrive(x_car, y_car, direction);
    if x_car <= 0 || y_car <= 0 || x_car >= x_boundary || y_car >= y_boundary
        break
    end
    Car_Position(i, 1:2) = [x_car, y_car];
end
% plot
grid on; hold on;
plot(Car_Position(1:i-1,1), Car_Position(1:i-1,2), 'b', 'LineWidth',2)
xticks(0:750:3000);   xlim([0 3000]);
yticks(0:750:3000);   ylim([0 3000]);

%% Method 2 (without StepDrive)
clear; clc; close all;

t = [0:1:86400];
square_length = 750;
x_boundary = 3000; y_boundary = 3000;
x_car = 750; y_car = 0;  %... initial position of car
speed = 10;  %... m/s
direction = 1;  %... up = 1, right = 2, down = 3, left = 4

position_car = [];
for i=1:length(t)
    % move forward
    [x_car, y_car] = Drive(x_car, y_car, direction);
    % turn?
    if rem(x_car, square_length) == 0 && rem(y_car, square_length) == 0
        direction = Turn(direction);
    end
    if x_car <= 0 || y_car <= 0 || x_car >= x_boundary || y_car >= y_boundary
        break
    end
    position_car = [position_car; [x_car, y_car]];
end

% plot
grid on; hold on;
plot(position_car(:,1), position_car(:,2), 'b', 'LineWidth',2)
xticks([0:750:3000]);   xlim([0 3000]);
yticks([0:750:3000]);   ylim([0 3000]);

function [new_x_car, new_y_car] = Drive(x_car, y_car, direction)
    speed = 10;  %... m/s
    movement = [0, speed; speed, 0; 0, -speed; -speed, 0];
    new_posit = [x_car, y_car] + movement(direction,:);
    new_x_car = new_posit(1);
    new_y_car = new_posit(2);
end

function new_direction = Turn(direction)
    % straight 1/2, right 1/3, left 1/6
    prob_Straight = 1/2;  prob_RightTurn = 1/3;  prob_LeftTurn = 1/6;
    % generate random number
    turn_rand_seed = rand();
    % compare with turning probability & change direction
    % left turn
    if turn_rand_seed < prob_LeftTurn  
        if direction ~= 1
            new_direction = direction - 1;
        elseif direction == 1
            new_direction = 4;
        end
    % right turn
    elseif turn_rand_seed >= prob_LeftTurn && turn_rand_seed < prob_LeftTurn + prob_RightTurn  
        if direction ~= 4
            new_direction = direction + 1;
        elseif direction == 4
            new_direction = 1;
        end
    % straight
    elseif turn_rand_seed >= prob_Straight  
        new_direction = direction;
    end
end

%%
% result = [0 0 0 0];
% for j=1:100
%     ct1=0;ct2=0;ct3=0;ct4=0;
%     for i=1:100
%         new_direction(i) = Turn(direction);
%         if new_direction(i) == 1
%             ct1 = ct1 + 1;
%         elseif new_direction(i) == 2
%             ct2 = ct2 + 1;
%         elseif new_direction(i) == 3
%             ct3 = ct3 + 1;
%         elseif new_direction(i) == 4
%             ct4 = ct4 + 1;
%         end
%     end
%     result = result + [ct1, ct2, ct3, ct4];
% end
% result./100

% [x_car, y_car] = Drive(x_car, y_car, direction);
% x_car
% y_car