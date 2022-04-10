clear; clc; close all;

%% Initialization
controller_type = "LQR";    % Either "LQR" or "PID" Value is accepted.
if controller_type == "LQR"
    controller_flag = 0;
elseif controller_type == "PID"
    controller_flag = 1;
else
    error("Controller Type is not specified correctly.")
end
run QuadStateSpaceModel.m

%% First Scenario
waypoints = [0,0,  0,0;...
             0,0, -1,0;...
             0,0, -1,0];
time_of_arrival = [0, eps, 2*eps];
simulation_time = time_of_arrival(end)+10;
setpoint.time = time_of_arrival;
setpoint.signals.values = waypoints;
sim("Model.slx");
if controller_flag==true
    output = pid_output;
else
    output = lqr_output;
end

% visualization
figure(1)
subplot(2,1,1)
plot(output.X_e.Time, output.X_e.Data(:,3))
grid on
title(controller_type+' Controller - scenario no.1')
xlabel('Time (s)')
ylabel('Altitude (m)')
subplot(2,1,2)
plot(output.V_b.Time, output.V_b.Data(:,3))
grid on
xlabel('Time (s)')
ylabel('Velocity Z direction body frame(m/s)')

%% Second Scenario
waypoints = [0,0,0,0;...
             1,0,0,0;...
             1,0,0,0];
time_of_arrival = [0, eps, 20];
simulation_time = time_of_arrival(end)+5;
setpoint.time = time_of_arrival;
setpoint.signals.values = waypoints;
sim("Model.slx");
if controller_flag==true
    output = pid_output;
else
    output = lqr_output;
end

% visualization
figure(2)
subplot(2,2,1)
plot(output.X_e.Time, output.X_e.Data(:,1))
grid on
title(controller_type+' Controller - scenario no.1')
xlabel('Time (s)')
ylabel('forward position (m)')
subplot(2,2,2)
plot(output.V_b.Time, output.V_b.Data(:,1))
grid on
xlabel('Time (s)')
ylabel('Velocity x direction (m/s)')
subplot (2,2,3)
plot(output.attitude.Time, output.attitude.Data(:,2))
grid on
xlabel("Time (s)")
ylabel("Pitch angle (rad)")
subplot(2,2,4)
plot(output.w_b.Time, output.w_b.Data(:,2))
grid on
xlabel("Time (s)")
ylabel("Angular Velocity y direction (rad/s)")
%% Third Scenario
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
if controller_flag==true
    output = pid_output;
else
    output = lqr_output;
end

% visualization
figure(3)
plot3(output.X_e.Data(:,1),output.X_e.Data(:,2),output.X_e.Data(:,3))
hold on
plot3(waypoints(:,1), waypoints(:,2), waypoints(:,3))
grid on
title("Trajectory of simulated Quadrotor UAV")
xlabel("X (m)")
xlim([-0.2, 1.2])
ylabel("Y (m)")
ylim([-0.2, 1.2])
zlabel("Z (m)")
zlim([-0.001, 0.001])