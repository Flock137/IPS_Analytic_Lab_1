% Given parameters
rho = 1.2;      % air density (kg/m^3)
D = 0.23;       % prop diameter (m)
m = 1.2;        % quad mass (kg)
g = 9.81;       % gravity (m/s^2)
CT_nominal = 0.10;  % nominal thrust coefficient

% ±5% uncertainty in C_T
CT_uncertainty = 0.05;  % ±5%
CT_min = CT_nominal * (1 - CT_uncertainty);
CT_max = CT_nominal * (1 + CT_uncertainty);

% Calculate hover RPM for nominal, min, and max C_T
thrust_per_motor = (m * g) / 4;

% Hover RPS calculation: n = sqrt(T / (C_T * ρ * D⁴))
n_nominal_rps = sqrt(thrust_per_motor / (CT_nominal * rho * D^4));
n_min_rps = sqrt(thrust_per_motor / (CT_max * rho * D^4));  % Higher C_T = lower RPM
n_max_rps = sqrt(thrust_per_motor / (CT_min * rho * D^4));  % Lower C_T = higher RPM

% Convert to RPM
n_nominal_rpm = n_nominal_rps * 60;
n_min_rpm = n_min_rps * 60;
n_max_rpm = n_max_rps * 60;

% Calculate percentage variations
rpm_variation_min = (n_min_rpm - n_nominal_rpm) / n_nominal_rpm * 100;
rpm_variation_max = (n_max_rpm - n_nominal_rpm) / n_nominal_rpm * 100;

% Display results
fprintf('=== HOVER RPM WITH C_T UNCERTAINTY ANALYSIS ===\n');
fprintf('C_T range: %.4f to %.4f (±%.0f%%)\n', CT_min, CT_max, CT_uncertainty*100);
fprintf('\n');
fprintf('Nominal hover RPM: %.0f RPM (C_T = %.3f)\n', n_nominal_rpm, CT_nominal);
fprintf('Minimum hover RPM: %.0f RPM (C_T = %.3f) → %.1f%% change\n', n_min_rpm, CT_max, rpm_variation_min);
fprintf('Maximum hover RPM: %.0f RPM (C_T = %.3f) → %.1f%% change\n', n_max_rpm, CT_min, rpm_variation_max);
fprintf('RPM RANGE: %.0f to %.0f RPM\n', n_min_rpm, n_max_rpm);
fprintf('Total variation: ±%.1f%%\n', abs(rpm_variation_min));

% Additional analysis: Create a sensitivity curve
CT_test = linspace(CT_min, CT_max, 50);
n_test_rps = sqrt(thrust_per_motor ./ (CT_test * rho * D^4));
n_test_rpm = n_test_rps * 60;

% Plot results
figure('Position', [100, 100, 1000, 600]);

subplot(2,2,1);
plot(CT_test, n_test_rpm, 'b-', 'LineWidth', 2);
hold on;
plot(CT_nominal, n_nominal_rpm, 'ro', 'MarkerSize', 8, 'LineWidth', 2);
plot([CT_min, CT_max], [n_min_rpm, n_max_rpm], 'rx', 'MarkerSize', 10, 'LineWidth', 2);
xlabel('Thrust Coefficient C_T');
ylabel('Hover RPM');
title('Hover RPM vs C_T');
grid on;
legend('RPM vs C_T', 'Nominal', 'Extremes', 'Location', 'best');

subplot(2,2,2);
% Show the uncertainty range
CT_range = [CT_min, CT_min, CT_max, CT_max, CT_min];
n_range = [0, n_max_rpm, n_max_rpm, n_min_rpm, n_min_rpm];
fill(CT_range, n_range, [0.8, 0.9, 1.0], 'EdgeColor', 'b', 'LineWidth', 1);
hold on;
plot(CT_nominal, n_nominal_rpm, 'ro', 'MarkerSize', 8, 'LineWidth', 2);
xlabel('Thrust Coefficient C_T');
ylabel('Hover RPM');
title('Hover RPM Uncertainty Range');
grid on;

subplot(2,2,3);
% Show the RPM distribution
rpm_values = [n_min_rpm, n_nominal_rpm, n_max_rpm];
labels = {'Min', 'Nominal', 'Max'};
bar(rpm_values, 'FaceColor', [0.7, 0.7, 0.9]);
set(gca, 'XTickLabel', labels);
ylabel('Hover RPM');
title('Hover RPM Range');
grid on;

% Add RPM values on bars
for i = 1:length(rpm_values)
    text(i, rpm_values(i)+10, sprintf('%.0f', rpm_values(i)), ...
        'HorizontalAlignment', 'center', 'FontWeight', 'bold');
end

subplot(2,2,4);
% Sensitivity analysis
CT_percent_change = (CT_test - CT_nominal) / CT_nominal * 100;
n_percent_change = (n_test_rpm - n_nominal_rpm) / n_nominal_rpm * 100;
plot(CT_percent_change, n_percent_change, 'r-', 'LineWidth', 2);
xlabel('C_T Change (%)');
ylabel('RPM Change (%)');
title('Sensitivity: RPM vs C_T Changes');
grid on;
hold on;
plot([-5, 5], [rpm_variation_min, rpm_variation_max], 'bo', 'MarkerSize', 8);
plot([0, 0], [min(n_percent_change), max(n_percent_change)], 'k--');
plot([min(CT_percent_change), max(CT_percent_change)], [0, 0], 'k--');

% Calculate and display key statistics
fprintf('\n=== KEY STATISTICS ===\n');
fprintf('RPM change per 1%% C_T change: %.3f%%\n', abs(rpm_variation_min)/5);
fprintf('RPM spread: %.0f RPM\n', n_max_rpm - n_min_rpm);
fprintf('This means a %.0f%% C_T uncertainty causes %.1f%% RPM uncertainty\n', ...
        CT_uncertainty*100, abs(rpm_variation_min));