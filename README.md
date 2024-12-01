This is the implementation of the work published in the following article "RNN-based linear parameter varying adaptive model predictive control for autonomous driving". The article is freely accessible at this link: https://univ-evry.hal.science/hal-04745066/document

## Steps to run the code:

This implementation requires MATLAB 2018b or a more recent version.

-  # RNN training: 
   ### This part is an implementation of discrete MPC with Laguere function for linear systems (vehicle lateral control in this case)
     1. Run the script 'Launch_MPC.m'.
     2. The script loads trajectory data (Double lane change maneuver or other trajectories).
     3. The script loads the parameters for the vehicle model and MPC controller (Params.mat).
     4. Simulation starts with the chosen parameters. You can try different trajectories and change the MPC parameters to compare its performance.
     5. Note that it is important to adjust MPC constraints accordingly, or it will diverge.

-  # RNN-based LPV-MPC: 
   ### This part is an implementation of discrete MPC with Laguere function for linear systems (vehicle lateral control in this case)
     1. Run the script 'Launch_MPC.m'.
     2. The script loads trajectory data (Double lane change maneuver or other trajectories).
     3. The script loads the parameters for the vehicle model and MPC controller (Params.mat).
     4. Simulation starts with the chosen parameters. You can try different trajectories and change the MPC parameters to compare its performance.
     5. Note that it is important to adjust MPC constraints accordingly, or it will diverge.


 -  # GA-PSO optimization: 
    ### This code optimizes the MPC parameters (Np, Nc, Q, R, etc.) with an enhanced PSO algorithm through iterative simulations

     1. Run the script 'PSO_MPC.m'.
     2. The script sets up the optimization problem through the script "mpc_param.m", and executes the optimization through the script "PSO_test.m".
     3. The code simulates the vehicle model in "MPC.slx" to optimize the controller parameters by minimizing the cost function defined in "mpc_param" (please check the paper for more details)
     4. At the end of the optimization, the data of optimal parameters will be saved in an Excel file (check "mpc_param" to know which file) 
       

### You might want to check a closely related implementation in this repository (https://github.com/yassinekebbati/GA-optimized-MLP-based-LPV_MPC)

### If you find this work useful or use it in your work, please cite the main paper:

Kebbati, Y., Ait-Oufroukh, N., Ichalal, D., & Vigneron, V. (2024). RNN-based linear parameter varying adaptive model predictive control for autonomous driving. International Journal of Systems Science, 1-13.

@article{kebbati2024rnn,
  title={RNN-based linear parameter varying adaptive model predictive control for autonomous driving},
  author={Kebbati, Yassine and Ait-Oufroukh, Naima and Ichalal, Dalil and Vigneron, Vincent},
  journal={International Journal of Systems Science},
  pages={1--13},
  year={2024},
  publisher={Taylor \& Francis}
}

