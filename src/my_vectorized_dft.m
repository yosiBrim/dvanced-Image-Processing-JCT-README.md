function X_out = my_vectorized_dft(x)
% MY_VECTORIZED_DFT Computes the 2D Discrete Fourier Transform (2D-DFT)
% over an extended 2M x 2N frequency grid using vectorized matrix multiplication.
%
% Input:
%   x     - Input spatial image or array of size M x N (double or uint8).
% Output:
%   X_out - Complex 2D-DFT matrix of size 2M x 2N.

    % Ensure input is double precision for complex trigonometric calculations
    if ~isa(x, 'double')
        x = double(x);
    end
    
    [M, N] = size(x);
    
    % Step 1: Zero-padding the input array to size 2M x 2N
    x_pad = zeros(2*M, 2*N);
    x_pad(1:M, 1:N) = x;
    
    % Step 2: Generate frequency (mu, nu) and spatial (m, n) index vectors
    mu = (0 : 2*M - 1)';  % Frequency row-indices (Column vector: 2M x 1)
    m  = (0 : 2*M - 1);   % Spatial row-indices   (Row vector:    1 x 2M)
    
    nu = (0 : 2*N - 1);    % Frequency col-indices (Row vector:    1 x 2N)
    n  = (0 : 2*N - 1)';  % Spatial col-indices   (Column vector: 2N x 1)
    
    % Step 3: Construct transformation matrices using outer products
    WM = exp(-1j * (pi / M) * (mu * m));
    WN = exp(-1j * (pi / N) * (n * nu));
    
    % Step 4: Bilinear Matrix Multiplication
    X_out = WM * x_pad * WN;
end