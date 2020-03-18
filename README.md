# Wireless Network Hand-off Simulation
## Purpose
Realize and observe the characteristics of 4 different hand-off principles in a simulated 16-city-block traffic cross-section with cars generated according to Poisson's distribution.
## Objective
Considering (1) the best relative signal principle, (2) threshold principle, (3) entropy principle and (4) a principle of your choice, obtain the **total number of handoffs** for each principle over the duration of 1 day (86400s). Also acquire the **average signal power** for each principle.
## Problem Discription
A 16-city-block traffic cross-section is shown below:

    -----x----x----x-----
    |    |    |    |    |
    x----O---------O----x        O: Base Station (BS)
    |    |    |    |    |
    x-------------------x        x: Car Entry/Exit Points
    |    |    |    |    |
    x----O---------O----x        - and |: Roads
    |    |    |    |    |
    -----x----x----x-----

### General Rules
1. Simulation interval = 1 sec., duration = 86400 sec. (1 day)
2. Every second new cars are generated at the entry points *x* based on Poisson's distribution
3. As soon as a car enters the system it is connected to a base station
4. Each car will only connect to one base station at a given time
5. Cars will move around in the system (but never in reverse)
6. If a car leaves the system via an exit point, the car is lost forever

### Base Station (BS) Characteristics
1. Base station transmission power **_Pt_ = -50 dBm**
2. Minimum effective transmission power **_Pmin_ = -125 dBm** (connection to car is lost if signal power is weaker than Pmin)

### Car (MS) Characteristics
1. At the entry points *x*, cars are generated according to **Poisson's distribution** with an **_arrival rate_ = 2 cars/min**
2. Constant **_car speed_ = 36 km/hr**
3. At the intersections, cars follow a mobility possibility model of **_straight_: P = 1/2**, **_right turn_: P = 1/3**, **_left turn_: P = 1/6**

### Hand-off Principles
#### Best Relative Signal
Hand-off happens when the transmission power **_Pnew_ from a BS > _Pold_ from original BS**
#### Threshold
Hand-off happens when **_Pnew_ > _Pold_ and _Pold_ < _threshold_**, _threshold_ = -110 dBm
