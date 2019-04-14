---
title: "Design of Non-Linear Controller of Rotary Inverted Pendulum"
excerpt: "In this project, we simulated a Sliding mode Controller for an Inverted
Pendulum to control it in upright position <br/><img src='/images/traffic_modelling_basic.png'>"
collection: projects
---

Introduction
============

The Rotary Inverted Pendulum is a highly nonlinear system. A rotary
inverted pendulum system (see Figure 1), has a rotating arm, which is
driven by a motor with a pendulum mounted on its rim. The pendulum moves
as an inverted pendulum in a plane perpendicular to the rotating arm.

![Rotary Inverted Pendulum](pend.jpg "fig:") [RIP]

The controller needs to stabilize two angles namely, $\theta$-the angle
of the motor joint and $\alpha$-the angle of the pendulum. Now, $\theta$
has to be stabilized to be within a particular bound while $\alpha$ has
to be made 180 $^{\circ}$.

Dynamics of the System
======================

In this section the dynamics of the Pendulum is given. The system
parameters were taken from the simulink model provided.

[h!] [value]

   **Parameter**                   **Description**                                **Value**
  --------------- -------------------------------------------------- -----------------------------------
     $J_{eq}$      Equivalent moment of inertia about motor shaft .   1.23 $\times$ 10$^{-4}$kg-m$^{2}$
         m                  Mass of the pendulum assembly                          0.027kg
         r              Length of arm pivot to pendulum pivot                     0.08260m
      $J_{m}$               Motor shaft moment of inertia                    $0.00011$kg-m$^{2}$
         L                    Total length of pendulum.                            0.191m
     $B_{eq}$                    Arm viscous damping                     0.0015 $\frac{N-m}{rad/s}$
         g                      gravitational constant                         9.81 m/s$^{2}$
      $K_{m}$          Motor back-electromotive force constant            0.02797 $\frac{V}{rad/s}$
      $K_{t}$                   Motor torque constant                            0.02797N-m
      R$_{m}$                 Motor armature resistance.                        3.30 $\Omega$

Using the values of Table([value]) following constants were calculated.

[right=]<span>align</span>& a = J~eq~+J~m~+mr^2^\
& b = mLr\
& c =\
& d = mgL\
& G =

The nonlinear state equation of the system is given below:

[]<span>align</span> & = x~2~ =\
& = F~1~(X)+G~1~(X)u\
& = x~4~ =\
& = F~2~(X)+G~2~(X)u

where $F_{1}$, $F_{2}$, $G_{1}$, $G_{2}$ are:

[]<span>align</span> & F~1~(X)=\
& G~1~(X)=\
& F~2~(X)=\
& G~2~(X)=\
& T=

Sliding Mode Controller
=======================

The sliding mode controller for the inverted pendulum is designed as
described in @paper. Here two sliding surface are considered for sliding
mode control. They are defined below:

[]<span>align</span> & s~1~=x~2~+~1~ x~1~\
& s~2~=x~4~+~3~ x~3~

The Lyapunov function is taken as:

$$V=|s_{1}|+\lambda _{2}|s_{2}|$$

To guarantee the stability of the feedback system, the control signal
$u$ is taken such that $$\dot{V} = -k\times sat(\frac{V}{\Phi})$$ where
saturation function is defined as

[]<span>align</span> & sat()=if \< |V|\
& sat()=sign(V) otherwise

The final control signal is shown below:

$$u=\frac{-ksat(\frac{V}{\Phi})-(\lambda_{1}x_{2}+F_{1}(X))sign(s_{1})-\lambda_{2}(\lambda_{3}x_{4}+F_{2}(X))sign(s_{2})}{G_{1}(X)sign(s_{1})+\lambda_{2}G_{2}(X)sign(s_{2})}$$

Result
======

With this sliding mode controller with two sliding surfaces, there are
five constants $\lambda_{1}$,$\lambda_{2}$,$\lambda_{3}$, $k$,
$\Phi$.The values of the constants are given in Table [const]

[h!] [const]

   **Constant**    **Value**
  --------------- -----------
   $\lambda_{1}$      0.2
   $\lambda_{2}$      0.9
   $\lambda_{3}$      0.9
         k            20
      $\Phi$          0.5

![variation of $\theta$ and $\alpha$ with initial disturbance
$\alpha$=25$^{\circ}$](angle.png "fig:") [alpha17]

The results achieved for the initial value of $\alpha$ being 27
$^{\circ}$ is shown in Figures([alpha17]). The above figures show that
the controller is able to stabilize both $\theta$ and $\alpha$. We can
see the prevailing chattering that is present in our output. The
$\alpha$ has a maximum chattering of 5$^{\circ}$. This controller is
able to stablilize the inverted pendulum with an initial $\alpha$ in the
range of 27$^{\circ}$. Now we can reduce chattering to 3$^{\circ}$ by
changing the constants, but that will reduce the maximum range of
$\alpha$ for which this controller can stabilize the system.

<span>99</span> Khanesar, Mojtaba Ahmadieh, Mohammad Teshnehlab, and
Mahdi Aliyari Shoorehdeli. “Sliding mode control of rotary inverted
pendulm.” Control & Automation, 2007. MED’07. Mediterranean Conference
on. IEEE, 2007.

