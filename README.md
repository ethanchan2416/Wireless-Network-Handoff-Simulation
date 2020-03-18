# Wireless Network Handoff Simulation
## Purpose
Realize and observe the characteristics of 4 different handoff principles in a simulated 16-city-block traffic cross-section with cars generated according to Poisson's distribution.
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

### Base Station (BS) Characteristics
1. Base station transmission power **Pt = -50 dBm**
2. Minimum effective transmission power **Pmin = -125 dBm** (connection to car is lost if signal power is weaker than Pmin)

### Car (MS) Characteristics
1. At the entry points *x*, cars are generated according to **Poisson distribution** with an **arrival rate = 2 cars/min**
2. Constant **car speed = 36 km/hr**
3. At the intersections, cars follow a mobility possibility model of **straight: P = 1/2**, **right turn: P = 1/3**, **left turn: P = 1/6**
