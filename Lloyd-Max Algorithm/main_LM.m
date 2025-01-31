% Gaussian PDF
mu = 0; % mean
sigma = 1; % standard deviation
gaussian_pdf = @(x) exp(-(x - mu).^2 / (2 * sigma^2)) / (sigma * sqrt(2 * pi));

% Rayleigh PDF
sigma_rayleigh = 1; % scale parameter
rayleigh_pdf = @(x) (x / sigma_rayleigh^2) .* exp(-x.^2 / (2 * sigma_rayleigh^2));


% Parameters
M = 16; % Number of quantization levels
threshold = 1e-6; % Convergence threshold
Xmin = -3*sigma; % Adjust based on expected range of the signal
Xmax = 3*sigma;  % Adjust based on expected range of the signal

% Lloyd-Max for Gaussian Distribution
[levels_gaussian, boundaries_gaussian] = lloyd_max(M, gaussian_pdf, Xmin, Xmax, threshold);
disp('Gaussian Distribution Quantized Levels:');
disp(levels_gaussian);

% Lloyd-Max for Rayleigh Distribution
[levels_rayleigh, boundaries_rayleigh] = lloyd_max(M, rayleigh_pdf, 0, Xmax * 2, threshold);
disp('Rayleigh Distribution Quantized Levels:');
disp(levels_rayleigh);
