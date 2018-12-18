---
title: "Microscopic model for lane-less (Indian) traffic"
excerpt: "In this project, a new model is introducted for traffic on broad roads, where the drivers do not
follow lane discipline. <br/><img src='/images/traffic_modelling_basic.png'>"
collection: portfolio
---

In this project, a new model is introduced for traffic on broad roads, where the drivers do not follow lane discipline. Instead of the traditional car-following models, the driver reactions are assumed to be influenced by possibly a number of vehicles, obstacles and unmodelled entities in visibility cones to the front and to the sides of each vehicle. It is shown that in congested traffic situations, the vehicles converge to a layered formation with fixed inter-vehicle distances and in sparse and heterogeneous traffic, the velocity and inter vehicle separations can oscillate continuously, but are uniformly bounded. 

These model-based predictions are verified experimentally. Detailed motion information of groups of cars is extracted through image processing techniques. The proposed model is initialised with the extracted data and the computed trajectories are compared with the actual ones. 

*Applications*: The model can potentially be applied for predicting behaviour of drivers; useful in development of learning techniques for controllers for autonomous vehicles in the Indian context. Another application case is for the development of simulators for analysis of macroscopic parameters like vehicle density, flow rates, etc. useful in traffic management and planning

This research was presented at [IFAC 2017](https://www.youtube.com/watch?v=Osqg78ncm4A&t=431s). For technical details refer to [Paper 1](https://www.sciencedirect.com/science/article/pii/S2405896317315525) and [Paper 2](https://ieeexplore.ieee.org/abstract/document/8355794).
