rho = 1.2; % air density (kg/m^3)
D = 0.23; % prop diameter (m)
m = 1.2; % quad mass (kg)
g = 9.81; % gravity (m/s^2)
Iz = 0.04; % yaw inertia (kg·m^2)
CT = 0.10; % thrust coefficient
CQ = 0.010; % torque coefficient

CT = 0.10; % thrust coefficient
CQ = 0.010; % torque coefficient

n = linspace(80, 400, 15); % RPS grid (~5k–24k RPM)
dn = 50; % yaw control test (RPS)

% D is the most important, due to the formulas below

% Calculate thrust and torque
T = CT * rho * n.^2 * D^4;  % Thrust (N)
Q = CQ * rho * n.^2 * D^5;  % Torque (N·m)

% Display results
fprintf('n (RPS)\tThrust (N)\tTorque (N·m)\n');
for i = 1:length(n)
    fprintf('%.1f\t\t%.3f\t\t%.4f\n', n(i), T(i), Q(i));
end

% Optional: Plot results
figure;
subplot(1,2,1);
plot(n, T, 'b-o', 'LineWidth', 2);
xlabel('Rotational Speed (RPS)');
ylabel('Thrust (N)');
title('Thrust vs RPM');
grid on;

subplot(1,2,2);
plot(n, Q, 'r-o', 'LineWidth', 2);
xlabel('Rotational Speed (RPS)');
ylabel('Torque (N·m)');
title('Torque vs RPM');
grid on;


