function F_y = F_vertSpring_y(x, K_v, preload_dist)
    % Linear approximation of springs with the resultant force acting along the axial direction (Postive stiffness). An offset can be provided to the displacment x 
    % 
    % | Parameter     | Explanation | Units
    % | ------------- | :-------------:       |:-------------: |
    % | x             |Displacement           |Meter|
    % | K_v           |Spring Stiffness       |Newtons/meter|
    % |preload_dist   |Desired spring offset  |Meter|
    F_y =  K_v*(x+preload_dist);
end