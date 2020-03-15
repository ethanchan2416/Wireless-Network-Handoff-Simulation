clear; clc; close all;
square_length = 750;
Init_Scalar = [square_length, square_length, 1];
Init_X_Y_Direction = [0, 1, 2; 0, 2, 2; 0, 3, 2;
                      1, 4, 3; 2, 4, 3; 3, 4, 3;
                      4, 3, 4; 4, 2, 4; 4, 1, 4;
                      3, 0, 1; 2, 0, 1; 1, 0, 1;];
Init_Position = reshape((Init_Scalar .* Init_X_Y_Direction)', 1, []);

t = 0:1:300;
Car_Position = zeros(length(t), length(Init_Position));
Car_Position(1,:) = Init_Position;

for i=1:length(t)-1
    [row, col] = size(Car_Position);
    for car_num=1:(col/3)
        x_car = Car_Position(i, 3*car_num-2);
        y_car = Car_Position(i, 3*car_num-1);
        direction = Car_Position(i, 3*car_num);
        [x_car, y_car, direction] = stepDrive(x_car, y_car, direction);
%         if x_car <= 0 || y_car <= 0 || x_car >= x_boundary || y_car >= y_boundary
%             continue
%         end
        Car_Position(i+1, 3*car_num-2:3*car_num) = [x_car, y_car, direction];
    end
end

grid on; hold on;
xticks(0:750:3000);   xlim([0 3000]);
yticks(0:750:3000);   ylim([0 3000]);
for i=1:12
    plot(Car_Position(:,3*i-2), Car_Position(:,3*i-1), 'LineWidth',2)
end