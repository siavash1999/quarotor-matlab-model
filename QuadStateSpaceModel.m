%    Filename: QuadSpaceStateModel.m 
%   Author(s): Siavash Emami
%        Date: November 2020
% Description: In this File a LTI state-space model of quadrotor in hover,
%              cruise, and spin mode is derived from physical model. its
%              observability and controllability is checked and a
%              full-state feedback controller is designed for it. 
% clear;close all;

%% Preparation
%system properties:
rho = 1.1840;         %Air density
g = 9.81;             %Gravitational constant
Ix= 0.01;             %Moment of inertia about x axis
Iy= 0.01;             %Moment of inertia about y axis
Iz= 0.02;             %Moment of inertia about z axis
m = 1;                %Mass of quadrotor
Ct= 9.9865e-06;       %Thrust Coefficient
Cm= 1.6e-2;           %Moment Coefficient
d = 0.21;             %Distance of propeller from center of mass of quadrotor
Cfx = 0.08268;        %Drag Coefficient in x direction
Cfz = 0.08268;        %Drag Coefficient in z direction

%% Hover mode
%state matrix:
Ahover = [0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0;...
          0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0;...
          0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0;...
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;...
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;...
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;...
          0,-g, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;...
          g, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;...
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;...
          0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0;...
          0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0;...
          0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0;];

%input matrix:
Bhover = [0   , 0   , 0   , 0   ;...
     0   , 0   , 0   , 0   ;...
     0   , 0   , 0   , 0   ;...
     0   , 1/Ix, 0   , 0   ;...
     0   , 0   , 1/Iy, 0   ;...
     0   , 0   , 0   , 1/Iz;...
     0   , 0   , 0   , 0   ;...
     0   , 0   , 0   , 0   ;...
      1/m, 0   , 0   , 0   ;...
     0   , 0   , 0   , 0   ;...
     0   , 0   , 0   , 0   ;...
     0   , 0   , 0   , 0   ;];

 %Output matrix:
Chover = eye(12,12);

%Checking observability and controllability:
Obs = rank(obsv(Ahover, Chover)); %rank of observability matrix = 12
Ctr = rank(ctrb(Ahover, Bhover)); %rank of controllability matrix = 12
if Ctr < size(Ahover,1) || Obs < size(Ahover,1)
    error("ERROR: System is not either observable or controllable. " + ...
        "check the parameters and run the script again.")
end
%State-Space Represenation of model:
quad_hover = ss(Ahover,Bhover,Chover,0);

%Defining weight matrices Q and R for state and input matrices respectively
%and finding optimized K gain matrix with LQR method:
Qhover = [10,  0, 0,   0,   0,   0,   0,   0,   0,    0,    0,  0;...
           0, 10, 0,   0,   0,   0,   0,   0,   0,    0,    0,  0;...
           0,  0, 2,   0,   0,   0,   0,   0,   0,    0,    0,  0;...
           0,  0, 0, 0.1,   0,   0,   0,   0,   0,    0,    0,  0;...
           0,  0, 0,   0, 0.1,   0,   0,   0,   0,    0,    0,  0;...
           0,  0, 0,   0,   0, 0.1,   0,   0,   0,    0,    0,  0;...
           0,  0, 0,   0,   0,   0, 0.2,   0,   0,    0,    0,  0;...
           0,  0, 0,   0,   0,   0,   0, 0.2,   0,    0,    0,  0;...
           0,  0, 0,   0,   0,   0,   0,   0, 200,    0,    0,  0;...
           0,  0, 0,   0,   0,   0,   0,   0,   0, 0.05,    0,  0;...
           0,  0, 0,   0,   0,   0,   0,   0,   0,    0, 0.05,  0;...
           0,  0, 0,   0,   0,   0,   0,   0,   0,    0,    0, 75;];

Rhover = [5,  0,  0,  0;...
          0, 10,  0,  0;...
          0,  0, 10,  0;...
          0,  0,  0, 10;];
 
Khover = lqr(quad_hover,Qhover,Rhover);

% correction of K gain matrix:
Khover = correction(Khover);

%% Functions:
% this function corrects the K gain matrix which may have little errors due
% to approximate methods of solving the LQR problem:
function [Kn] = correction(K)
    s = size(K);
    Kn = zeros(s(1),s(2));
    s = s(1)*s(2);
    for i=1:s
        if abs(K(i))>10^-4
            Kn(i) = K(i);
        end
    end
end