---
title: "Cooperative outdoor flight: Theory, System development and Integration"
excerpt: "In this project we have developed and implemented a holistic system architecture capable of handling
control and communication of a multi-agent system. <br/><img src='/images/outdoor_quadrotor_testbed.png'>"
collection: portfolio
---

We have implemented a decentralized consensus algorithm which drives robots (quadrotors in our case) from any initial condition in space to an autonomously decided common point. This is commonly known as the rendezvous problem. Each agent only uses information from its neighbours to take decisions and trajectory planning is done completely on-board.

A novel synchronized, time-slotted and scalable communication protocol which avoids data packet collisions and ensures real-time connectivity between agents is proposed and implemented. This protocol can address changing communication graph topologies and temporary link breaks and additions.

A video of one of our experiments can be found [here](https://youtu.be/LFCnua4CBsU). 

*Applications*: autonomous formation flight, search and rescue missions.

This research was presented at [ECC 2016](http://zapurva.github.io/files/ECC16_presentation_AJ.pdf) and [CDC 2017](http://zapurva.github.io/files/CDC17_presentation_AJ.pdf). For technical details refer to [Paper 1](https://ieeexplore.ieee.org/abstract/document/7810609) and [Paper 2](https://ieeexplore.ieee.org/abstract/document/8263964). 
