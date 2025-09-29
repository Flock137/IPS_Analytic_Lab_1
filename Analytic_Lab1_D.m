% Base parameters
m = 1.2;        % quad mass (kg)
g = 9.81;       % gravity (m/s^2)
CT = 0.10;      % thrust coefficient
CQ = 0.010;     % torque coefficient

% Base values
D_base = 0.23;  % prop diameter (m)
rho_base = 1.2; % air density (kg/m^3)

% Variation ranges (±5% for D, ±8% for rho)
D_range = D_base * linspace(0.95, 1.05, 20);      % ±5% variation
rho_range = rho_base * linspace(0.92, 1.08, 20);  % ±8% variation

% Create mesh grids
[D_grid, rho_grid] = meshgrid(D_range, rho_range);

% Initialize power matrix
hover_power = zeros(size(D_grid));

% Calculate hover power for each combination
for i = 1:size(D_grid, 1)
    for j = 1:size(D_grid, 2)
        D = D_grid(i, j);
        rho = rho_grid(i, j);
        
        % Calculate hover RPS
        thrust_per_motor = (m * g) / 4;
        n_hover = sqrt(thrust_per_motor / (CT * rho * D^4));
        
        % Calculate torque and power per motor
        torque_per_motor = CQ * rho * n_hover^2 * D^5;
        power_per_motor = 2 * pi * n_hover * torque_per_motor;
        
        % Total hover power
        hover_power(i, j) = 4 * power_per_motor;
    end
end

% Create 3D surface plot
figure('Position', [100, 100, 1200, 800]);

subplot(2,2,1);
surf(D_grid, rho_grid, hover_power, 'EdgeColor', 'none');
xlabel('Prop Diameter (m)');
ylabel('Air Density (kg/m^3)');
zlabel('Hover Power (W)');
title('3D Surface: Hover Power vs D and ρ');
colorbar;
grid on;

subplot(2,2,2);
contourf(D_grid, rho_grid, hover_power, 15);
xlabel('Prop Diameter (m)');
ylabel('Air Density (kg/m^3)');
title('Contour: Hover Power (W)');
colorbar;

% Add reference lines for base values
hold on;
plot([D_base D_base], ylim, 'r--', 'LineWidth', 2);
plot(xlim, [rho_base rho_base], 'r--', 'LineWidth', 2);
hold off;

subplot(2,2,3);
% Slice at base density
rho_idx = find(abs(rho_range - rho_base) == min(abs(rho_range - rho_base)), 1);
plot(D_range, hover_power(rho_idx, :), 'b-', 'LineWidth', 2);
xlabel('Prop Diameter (m)');
ylabel('Hover Power (W)');
title(sprintf('Power vs Diameter (ρ = %.2f kg/m³)', rho_base));
grid on;
hold on;
plot(D_base, hover_power(rho_idx, D_range == D_base), 'ro', 'MarkerSize', 8, 'LineWidth', 2);
hold off;

subplot(2,2,4);
% Slice at base diameter
D_idx = find(abs(D_range - D_base) == min(abs(D_range - D_base)), 1);
plot(rho_range, hover_power(:, D_idx), 'r-', 'LineWidth', 2);
xlabel('Air Density (kg/m³)');
ylabel('Hover Power (W)');
title(sprintf('Power vs Air Density (D = %.2f m)', D_base));
grid on;
hold on;
plot(rho_base, hover_power(rho_range == rho_base, D_idx), 'bo', 'MarkerSize', 8, 'LineWidth', 2);
hold off;

% Display numerical results
fprintf('=== SENSITIVITY ANALYSIS RESULTS ===\n');
fprintf('Base hover power: %.1f W\n', hover_power(rho_range == rho_base, D_range == D_base));
fprintf('Power range: %.1f W to %.1f W\n', min(hover_power(:)), max(hover_power(:)));

% Calculate sensitivity coefficients
power_base = hover_power(rho_range == rho_base, D_range == D_base);

% Effect of ±5% diameter change
D_min_power = hover_power(rho_range == rho_base, 1);
D_max_power = hover_power(rho_range == rho_base, end);
D_sensitivity = ((D_max_power - D_min_power) / power_base) / 0.10; % per 10% change

% Effect of ±8% density change  
rho_min_power = hover_power(1, D_range == D_base);
rho_max_power = hover_power(end, D_range == D_base);
rho_sensitivity = ((rho_max_power - rho_min_power) / power_base) / 0.16; % per 16% change

fprintf('Diameter sensitivity: %.2f%% power change per 1%% diameter change\n', D_sensitivity);
fprintf('Density sensitivity: %.2f%% power change per 1%% density change\n', rho_sensitivity);