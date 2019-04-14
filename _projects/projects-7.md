---
title: "Designing Linear Controller for Balancing of an Inverted Pendulum<br> <br><img src='/images/project-6/teaser.jpg'>"
excerpt: "In this project, a LQR controller was designed to balance the inverted
 pendulum using Arduino Mega and MATLAB."
header:
  image: project-6/header.jpg
collection: projects
---

# Inverted-Pendulum-Control
Design of a Linear Quadratic Regulator balance controller for the Inverted Pendulum. After manually initializing the pendulum in the upright vertical position, the balance controller moves the rotary arm to keep the pendulum in this upright position. Moreover it is capable of balancing itself, even if minor external disturbances are given.

## Documentation

This project is a part of the control and computing lab project for IIT Bombay. I have attached the relevant Chapter from our lab report. All the harware details, the mathematical model and the codes are explained in details in that report, so I am not explaining anything in this readme anymore.

## Breif details about setup

For this project we used a rotary inverted pendulum kit by Quanser.
![Inverted pendulum kit](/images/project-6/ped.png)

 Arduino Mega was used for the control of the DC Motor voltage.
![Arduino Mega](/images/project-6/mega.png)

The circuit diagram is shown here: [circuit diagram](/images/project-6/Inverted%20Pendulum%20Circuit.svg)
The decoder datasheet can be found here: [HCTL 2022](/images/project-6/AV02-0096EN.pdf)
The encoder datasheet can be found here: [Avago Encoder](/images/project-6/AV02-1046EN_DS_HEDM-55xx_2014-11-20.pdf)


## Demo

![Demo](/images/project-6/demo.gif)

