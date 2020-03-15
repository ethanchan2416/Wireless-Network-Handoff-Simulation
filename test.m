T = 200000;
mTest = randn(T,2);
tic
for i=1:T
    pdist([mTest(i,1); mTest(i,2)]);
end
toc

tic
for i=1:T
    norm(mTest(i,1) - mTest(i,2));
end
toc
%             % straight 1/2, right 1/3, left 1/6
%             P_straight = 1/2;  P_rightTurn = 1/3;  P_leftTurn = 1/6;
%             speed = 10;  %... m/s
% 
%             % if reached intersection, turn?
%             if rem(obj.x, obj.square_length) == 0 && rem(obj.y, obj.square_length) == 0
%                 % turn but not at 4 corners
%                 obj.direction = turn(obj.direction);
%                 % turn and at 4 corners
%                 if obj.x == 0 && obj.y == 0
%                     if obj.direction == 3
%                         obj.direction = 2;
%                     elseif obj.direction == 4
%                         obj.direction = 1;
%                     end
%                 elseif obj.x == 0 && obj.y == obj.square_length * 4
%                     if obj.direction == 1
%                         obj.direction = 2;
%                     elseif obj.direction == 4
%                         obj.direction = 3;
%                     end
%                 elseif obj.x == obj.square_length * 4 && obj.y == 0
%                     if obj.direction == 2
%                         obj.direction = 1;
%                     elseif obj.direction == 3
%                         obj.direction = 4;
%                     end
%                 elseif obj.x == obj.square_length * 4 && obj.y == obj.square_length * 4
%                     if obj.direction == 1
%                         obj.direction = 4;
%                     elseif obj.direction == 2
%                         obj.direction = 3;
%                     end
%                 end
%             end
% 
%             % move forward
%             [obj.x, obj.y] = moveForward(obj.x, obj.y, obj.direction, speed);

%             function [new_x_car, new_y_car] = moveForward(x_car, y_car, direction, speed)
%                 if direction == 1
%                     new_y_car = y_car + speed;
%                     new_x_car = x_car;
%                 elseif direction == 2
%                     new_x_car = x_car + speed;
%                     new_y_car = y_car;
%                 elseif direction == 3
%                     new_y_car = y_car - speed;
%                     new_x_car = x_car;
%                 elseif direction == 4
%                     new_x_car = x_car - speed;
%                     new_y_car = y_car;
%                 end
%             end
% 
%             function new_direction = turn(direction)
%                 % generate random number
%                 P_random = rand();
%                 % compare with turning probability & change direction
%                 % left turn
%                 if P_random < P_leftTurn  
%                     if direction ~= 1
%                         new_direction = direction - 1;
%                     elseif direction == 1
%                         new_direction = 4;
%                     end
%                 % right turn
%                 elseif P_random >= P_leftTurn && P_random < P_leftTurn + P_rightTurn  
%                     if direction ~= 4
%                         new_direction = direction + 1;
%                     elseif direction == 4
%                         new_direction = 1;
%                     end
%                 % straight
%                 elseif P_random >= P_straight  
%                     new_direction = direction;
%                 end
%             end

    function myMethod(obj)
        SignalPower = sigPower(obj);
        best_signal = max(SignalPower);
        % handoff when dist to BSold > 1500m
        if norm([obj.x, obj.y] - obj.BS_Coor_Array(obj.Base(4),:)) > 1500
            % idx of base stations that have best signal
            BestSigBaseIdx = find(SignalPower == best_signal);
            % change base station
            if numel(BestSigBaseIdx) == 2 && ~ismember(obj.Base(4), BestSigBaseIdx)
                obj.Base(4) = randi(BestSigBaseIdx);
                obj.Handoff(4) = obj.Handoff(4) + 1;
            elseif numel(BestSigBaseIdx) == 1 && obj.Base(4) ~= BestSigBaseIdx
                obj.Base(4) = BestSigBaseIdx;
                obj.Handoff(4) = obj.Handoff(4) + 1;
            end
            % assign updated signal power to car
            obj.Signal_power(4) = best_signal;
        % dist to BSold < 1500
        else
            obj.Signal_power(4) = SignalPower(obj.Base(4));
        end
    end