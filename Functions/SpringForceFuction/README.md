# Introduction

The files in this folder are various stiffness functions for springs. This includes both positive and negative stiffness Springs. In all cases, they employ various input parameters (including the displacement parameter x) and output the force exerted by the spring

## BuckleBeam.m
The function for this code was obtained from [[1]](#1). The resultant force is the force in the vertical direction

| Parameter     | Explanation |
| ------------- | :-------------: |
| x             |Displacement(meters)|
| P_e           |P<sub>e</sub> = EI( &pi; /L)<sup>2</sup>  - Classic Euler critical load for hinge-hinged boundary|
|a              |Horizontal distance between mass and reference (see diagram)|
|L              |Full Length of the beam|
|q_0            |Initial imperfection at the center of the beam|

<img src="./Images/BuckleBeam.png" alt="drawing" style="width:400px;"/>

Image obtained from [[1]](#1).

## F_horzSpring_y.m
The function for this code uses horizontal springs for the negative stiffness element. The resultant force is the force in the vertical direction

| Parameter     | Explanation |
| ------------- | :-------------: |
| x             |Displacement(meters)|
| K_h           |Horizontal Spring Stiffness (spring providing the negative stiffness in the vertical direction|
|L_0            |Full Length of the springs under no load|
|L_min          |Minimum Length of the springs (springs horizontal)|
|h_0            |Height of the horizontal springs under no load|

<img src="./Images/HorizontalSpring.png" alt="drawing" style="width:400px;"/>

## F_vertSpring_y.m
Linear approximation of springs with the resultant force acting along the axial direction (Postive stiffness). Offset of x can be provided. 

| Parameter     | Explanation |
| ------------- | :-------------: |
| x             |Displacement(meters)|
| K_v           |Spring Stiffness |
|h_0            |Height of the horizontal springs under no load|

## References

<a id="1">[1]</a> 
 Xingtian Liu, Xiuchang Huang, Hongxing Hua,
On the characteristics of a quasi-zero stiffness isolator using Euler buckled beam as negative stiffness corrector,
Journal of Sound and Vibration,
Volume 332, Issue 14,
2013,
Pages 3359-3376,
ISSN 0022-460X,
https://doi.org/10.1016/j.jsv.2012.10.037.
(https://www.sciencedirect.com/science/article/pii/S0022460X13000813)