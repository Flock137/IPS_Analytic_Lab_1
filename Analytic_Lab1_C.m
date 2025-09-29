% Given parameters
rho = 1.2;      % air density (kg/m^3)
D = 0.23;       % prop diameter (m)
m = 1.2;        % quad mass (kg)
Iz = 0.04;      % yaw inertia (kg·m^2)
CQ = 0.010;     % torque coefficient
dn = 50;        % RPS difference for yaw control

% Hover condition from previous calculation
n_hover = 93.6; % RPS

% 1. Calculate motor speed changes for yaw
% Yaw is created by differential torque between CW and CCW motors
% Let's assume: Two motors increase by +dn, two decrease by -dn
n1 = n_hover + dn;  % Two motors (e.g., front-right, back-left)
n2 = n_hover - dn;  % Two motors (e.g., front-left, back-right)

% 2. Calculate torque from each motor group
% Motor torque: Q = CQ * rho * n² * D⁵
Q1 = CQ * rho * n1^2 * D^5;  % Torque from accelerated motors (N·m)
Q2 = CQ * rho * n2^2 * D^5;  % Torque from decelerated motors (N·m)

% 3. Calculate net yaw torque on aircraft
% For quadcopter: Two CW motors, two CCW motors
% When we accelerate CW motors and decelerate CCW motors:
% - CW motors produce MORE reaction torque (opposing rotation)
% - CCW motors produce LESS reaction torque
% Net yaw torque = sum of all motor reaction torques
net_yaw_torque = -Q1 - Q1 + Q2 + Q2;  % Simplified: 2 motors each side
% More accurate: net_yaw_torque = 2*(-Q1 + Q2)

net_yaw_torque = 2 * (-Q1 + Q2);

% 4. Calculate angular acceleration
% τ = I * α  =>  α = τ / I
yaw_angular_accel = net_yaw_torque / Iz;  % rad/s²

% Display results
fprintf('=== YAW CONTROL ANALYSIS ===\n');
fprintf('Hover RPS: %.1f RPS\n', n_hover);
fprintf('Yaw control input: Δn = ±%.0f RPS\n', dn);
fprintf('Motor speeds: %.1f RPS and %.1f RPS\n', n1, n2);
fprintf('Torque from accelerated motors: %.4f N·m\n', Q1);
fprintf('Torque from decelerated motors: %.4f N·m\n', Q2);
fprintf('NET YAW TORQUE: %.4f N·m\n', net_yaw_torque);
fprintf('YAW ANGULAR ACCELERATION: %.2f rad/s²\n', yaw_angular_accel);
fprintf('YAW ANGULAR ACCELERATION: %.1f deg/s²\n', rad2deg(yaw_angular_accel));