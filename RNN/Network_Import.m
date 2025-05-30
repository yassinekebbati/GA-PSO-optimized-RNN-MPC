

%Specify keras network file name
modelfile = 'Jordan.h5';

%convert keras network to mat 
% net = importNetworkFromTensorFlow(modelfile)
Jordan_net = importKerasNetwork(modelfile)

%save converted file
save  Jordan_net

%show the network
plot(Jordan_net)