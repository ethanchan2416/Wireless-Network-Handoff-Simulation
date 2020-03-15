%% lambda 1
clc; clear; close all;
t = 0:1:500;
lambda = 1 / 30;
y = lambda .* t .* exp(-lambda .* t);
plot(t, y)

%% lambda 2
clc; clear; close all;

for k = 1:1000
    num_car = 0;
    for i = 1:60
        if PoissonGenerateCar()
            num_car = num_car + 1;
        end
    end
    results(k) = num_car;
end
mean(results)