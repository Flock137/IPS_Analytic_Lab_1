% Given parameters
rho = 1.2;      % air density (kg/m^3)
D = 0.23;       % prop diameter (m)
m = 1.2;        % quad mass (kg)
g = 9.81;       % gravity (m/s^2)
CT = 0.10;      % thrust coefficient
CQ = 0.010;     % torque coefficient

% 1. Calculate required hover thrust per motor
total_thrust_required = m * g;  % Total thrust needed (N)
thrust_per_motor = total_thrust_required / 4;  % For quadcopter (N)

% 2. Solve for hover RPS (n_hover) from thrust equation: T = CT * rho * n² * D⁴
% Rearranging: n = sqrt(T / (CT * rho * D⁴))
n_hover_rps = sqrt(thrust_per_motor / (CT * rho * D^4));

% 3. Convert RPS to RPM
n_hover_rpm = n_hover_rps * 60;

% 4. Calculate torque per motor at hover
torque_per_motor = CQ * rho * n_hover_rps^2 * D^5;  % (N·m)

% 5. Calculate power per motor at hover
power_per_motor = 2 * pi * n_hover_rps * torque_per_motor;  % (Watts)

% 6. Calculate total hover power
total_hover_power = 4 * power_per_motor;  % (Watts)

% Display results
fprintf('=== HOVER PERFORMANCE CALCULATIONS ===\n');
fprintf('Total thrust required: %.3f N\n', total_thrust_required);
fprintf('Thrust per motor: %.3f N\n', thrust_per_motor);
fprintf('Hover speed: %.1f RPS (%.0f RPM)\n', n_hover_rps, n_hover_rpm);
fprintf('Torque per motor: %.4f N·m\n', torque_per_motor);
fprintf('Power per motor: %.1f W\n', power_per_motor);
fprintf('TOTAL HOVER POWER: %.1f W\n\n', total_hover_power);

% Verification: Calculate thrust at this RPM to verify
thrust_verify = CT * rho * n_hover_rps^2 * D^4;
fprintf('Verification - Thrust at calculated RPM: %.3f N (should equal %.3f N)\n', ...
        thrust_verify, thrust_per_motor);