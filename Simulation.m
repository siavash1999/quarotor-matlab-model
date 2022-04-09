clear; clc;
controller_type = "LQR";

%% Initialization
run QuadStateSpaceModel.m

if controller_type == "PID"
    flag = 1;
elseif controller_type == "LQR"
    flag = 0;
else
    error("The Controller Type is not specified correctly.");
end

%% First Scenario
scenario = 0;
waypoints = [0,0,0,0;...
             0,0,1,0;...
             0,0,1,0];
time_of_arrival = [0, eps, 20];
simulation_time = time_of_arrival(end)+5;
setpoint.time = time_of_arrival;
setpoint.signals.values = waypoints;
sim("Model.slx");
scn1_data = scenario1_output;



%% Second Scenario
scenario = 1;
waypoints = [0,0,0,0;...
             1,0,0,0;...
             1,0,0,0];
time_of_arrival = [0, eps, 20];
simulation_time = time_of_arrival(end)+5;
setpoint.time = time_of_arrival;
setpoint.signals.values = waypoints;
sim("Model.slx");
scn2_data = scenario2_output;

%% Third Scenario
scenario = 2;
waypoints = [0,0,0,      0;...
             1,0,0,      0;...
             1,0,0,   pi/2;...
             1,1,0,   pi/2;...
             1,1,0,     pi;...
             0,1,0,     pi;...
             0,1,0, 3*pi/2;...
             0,0,0, 3*pi/2;...
             0,0,0, 3*pi/2];
time_of_arrival = [0, 20, 25, 45, 55, 75, 80, 100, 105];
simulation_time = time_of_arrival(end)+5;
setpoint.time = time_of_arrival;
setpoint.signals.values = waypoints;
sim("Model.slx");
scn3_data = scenario3_output;