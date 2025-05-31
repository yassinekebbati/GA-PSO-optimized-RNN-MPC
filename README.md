This is the implementation of the work published in the following article "RNN-based linear parameter varying adaptive model predictive control for autonomous driving". The article is freely accessible at this link: https://univ-evry.hal.science/hal-04745066/document

## Steps to run the code:

This implementation requires MATLAB 2018b or a more recent version. For building and training the Jordan network, you need to have Python and Keras framework with the following libraries: 
![image](https://github.com/user-attachments/assets/0e836448-2f7b-4d62-8234-e5462907f4d7)


-  # Jordan Network (RNN folder): 
   ### This code is used to build the Jordan network and train it for predicting the tire cornering stiffness coefficients for MPC adaptations 
     1. Run the code found in 'Jordan_lpv_mpc.py' in Python to generate Jordan.h5, which contains the trained RNN network.
     2. The script loads the data and prepares it for training and testing, then builds the RNN and trains it, and then it saves the trained network to file Jordan.h5.
     3. Run the script "Network_Import.m" to load the generated Jordan network and save it as a mat file (note that for using it in MPC code, we will also need the mean value and standard deviation).

 -  # GA-PSO optimization (GA_PSO_LPVMPC folder): 
    ### This code optimizes the MPC cost function weighting matrices (Q and R) with a novel hybrid GA and PSO algorithm through iterative simulations

     1. Run the script 'HGAPSO_SPHERE.m' to test the hybrid GA-PSO on the sphere function problem.
     2. Run the script 'MPC_APP_HGAPSO.m' to run the hybrid GA-PSO to optimize the MPC cost function weighting matrices (note that this will run the MPC code and simulate the controller for a certain number of iterations; you will need to set the iteration by changing MaxIt and the number of population by changing nPop in "H_GA_PSO.m" script).
     3. Feel free to test different hyperparameters of the code to further improve the performance of the algorithm
  
       
-  # RNN-based LPV-MPC (RNN_LPV_MPC folder): 
   ### This part is an implementation of LPV_MPC controller with RNN corrections for the vehicle model (vehicle lateral and longitudinal control)
     1. First, ensure that Yalmip is available to your MATLAB. For this, you need to add the provided Yalmip folder to MATLAB path.  
     2. Run the script 'MAIN_LPV_MPC.m' to launch the controller (note that you need to have all files and scripts in the folder within MATLAB path).
     3. You can try the controller for the lane change maneuver by using data labeled with DLC (note you will need to adjust the code to use the aforementioned data).
     4. You can try the controller for the general position and speed trajectories by using data labeled "test_data", "Pos_data", and "wind_data" (note you will need to adjust the code to use the aforementioned data).
        




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

