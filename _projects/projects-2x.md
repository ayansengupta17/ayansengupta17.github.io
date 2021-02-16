---
title: " Algorithm for Open-Loop Trajectory Generation of Infinite-Dimensional Systems<br><br><img src='/images/project-3/images/teaser.jpg'>"
excerpt: "Oberst-Riquier Based Generalised Algorithm for Open-Loop Trajectory Generation of Infinite-Dimensional Systems"
header:
  image: project-3/images/header.jpg
collection: projects
author_profile: true
---

**Abstract**
We propose a generalised approach to solving the trajectory generation problem, which is usually the first step for
solving a broader class of control problems known as the
motion planning problem or trajectory tracking problem.
Such problems arise in many areas of aerodynamics, civil
engineering applications, nanotechnology devices, chemical
processes etc. The systems concerned here are overdetermined systems defined by linear partial differential equation(s) with boundary condition(s). Our goal is to achieve
a target reference trajectory, which we call ”output reference” with some precisely calculated open-loop trajectory,
which we call the open-loop ”input trajectory”. The proposed method uses Groebner basis based algebraic analysis
for providing an exact solution to such trajectory generation problem. For the solution of PDE(s), we use the
Oberst-Riquier algorithm while a Groebner-fan algorithm
is used for enumerating all the Groebner bases. Our proposed algorithm does not require the usual procedure of
segregating the PDEs into different categories before solving the problem. Moreover, we also examine and provide
sufficient conditions for such a problem to be well-posed.
Finally, we provide an algorithm that is capable of checking the well-posedness conditions and solving the trajectory
generation problem. Our technique of handling the boundary condition(s) enables us to utilize them directly without
classifying them into conventional classes of boundary conditions.


**Comments**

Presented at [SIAM Conference on Analysis of Partial Differential Equations](https://www.siam.org/conferences/cm/conference/pd19)


