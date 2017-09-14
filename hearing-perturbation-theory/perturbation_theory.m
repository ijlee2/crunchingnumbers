%--------------------------------------------------------------------------
%  Author:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    
%  Summary:
%    
%    This program uses an audio to demonstrate how the condition number
%    of a matrix A can corrupt the solution x, when the data A and b are
%    perturbed by a fixed amount.
%  
%  Instructions:
%    
%    Type the following onto Matlab's command window:
%    
%    perturbation_theory(encryptionOption, noiseOption)
%    
%    where,
%      
%      encryptionOption = 1 creates a well-conditioned encryption matrix
%                       = 2 creates an ill-conditioned encryption matrix
%      
%      noiseOption = 1 perturbs the matrix
%                  = 2 perturbs the RHS vector
%                  = 3 perturbs both matrix and RHS vector
%    
%--------------------------------------------------------------------------
function perturbation_theory(encryptionOption, noiseOption)
    % Clear screen and close figures
    clc;
    close all;
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Read the audio X_true
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % An audio is represented as a vector
    [x_true, sampleRate] = audioread('williams.wav');
    
    % Trim the audio so that the play time (i.e. length of the vector x)
    % is a multiple of 10 (= timeStep)
    timeStep = 10;
    
    n = timeStep * floor(length(x_true) / timeStep);
    
    x_true = x_true(1 : n, 1);
    
    
    % If there were no input arguments, simply play the original audio
	if (nargin == 0)
        sound(x_true, sampleRate);
        
        return;
        
    else
        % Change the solution vector to a matrix
        X_true = reshape(x_true, timeStep, n / timeStep);
        
    end
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Create the encryption matrix A
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    switch encryptionOption
        %------------------------------------------------------------------
        %  A is the orthogonal matrix generated from the QR factorization
        %  of a (10 x 10) random matrix. A is a well-conditioned matrix.
        %------------------------------------------------------------------
        case 1
            [A, ~] = qr(randn(timeStep));
            
        %------------------------------------------------------------------
        %  A is the (10 x 10) Hilbert matrix. Hilbert matrices are known
        %  to be very ill-conditioned.
        %------------------------------------------------------------------
        case 2
            A = hilb(timeStep);
            
    end
    
    % Find the largest entry in A (we will use this number to normalize
    % the perturbation DeltaA)
    A_max = max(max(A));
    
    
    fprintf('The condition number of the matrix A is %1.4e.\n\n', cond(A));
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Encrypt the encrypted audio B
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Use matrix-matrix multiplication to encrypt the audio
    B = A * X_true;
    
    % Find the largest entry in B (we will use this number to normalize
    % the perturbation DeltaB)
    B_max = max(max(B));
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Decrypt the encrypted audio X
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    switch noiseOption
        % Option 1. Perturb the matrix
        case 1
            DeltaA = (0.010 * A_max) * randn(timeStep);
            
            X = (A + DeltaA) \ B;
            
        % Option 2. Perturb the RHS vector
        case 2
            DeltaB = (0.001 * B_max) * randn(size(X_true));
            
            X = A \ (B + DeltaB);
            
        % Option 3. Perturb the matrix and the RHS vector
        case 3
            DeltaA = (0.010 * A_max) * randn(timeStep);
            DeltaB = (0.001 * B_max) * randn(size(X_true));
            
            X = (A + DeltaA) \ (B + DeltaB);
            
    end
    
    % Change the solution matrix to a vector
    x = reshape(X, n, 1);
    
    % Find the relative error between the true and obtained solutions
    relativeError = norm(x - x_true) / norm(x_true);
    
    
    fprintf('The relative error in the solution vector x is %.4g.\n\n', relativeError);
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Plot a sample of the audio file
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    figure('Units'            , 'normalized', ...
           'OuterPosition'    , [0 0 1 1], ...
           'Color'            , [1 1 1], ...
           'InvertHardcopy'   , 'off', ...
           'MenuBar'          , 'none', ...
           'NumberTitle'      , 'off', ...
           'Resize'           , 'on', ...
           'PaperUnits'       , 'points', ...
           'PaperPosition'    , [0 0 800 600], ...
           'PaperPositionMode', 'auto');
    
    
    % Obtain a 100 ms sample of the audio starting at 1 second
    sampleIndex = sampleRate : (sampleRate + floor(sampleRate / 100));
    
    time = sampleIndex / sampleRate;
    
    
    %----------------------------------------------------------------------
    %  Compute the relative error at each time
    %----------------------------------------------------------------------
    absoluteError = abs(x(sampleIndex) - x_true(sampleIndex));
    relativeError = absoluteError ./ abs(x_true(sampleIndex));
    
    % If the frequency in the original audio is 0, replace the relative
    % error with the absolute error
    relativeError(isinf(relativeError)) = absoluteError(isinf(relativeError));
    
    % Find the average (median) of relative errors
    relativeError_average = median(relativeError);
    
    
    %----------------------------------------------------------------------
    %  Plot the true and obtained audios
    %----------------------------------------------------------------------
    subplot(2, 1, 1);
    
    plot(time, x_true(sampleIndex), '-' , 'LineWidth', 2); hold on;
    plot(time, x(sampleIndex)     , '-r', 'LineWidth', 2);
    
    set(gca, 'FontSize', 32, ...
             'XGrid', 'on', ...
             'XTick', 1 : 0.001 : 1.01, ...
             'XTickLabel', {'1.000', '', '1.002', '', '1.004', '', '1.006', '', '1.008', '', '1.010'});
    
    title('100 ms sample', 'FontSize', 48);
    
    xlabel('Time (s)', 'FontSize', 32);
    ylabel('Frequency', 'FontSize', 32);
    legend({' True', ' Obtained'}, 'FontSize', 26, 'Location', 'SouthEast');
    
    axis tight;
    xlim([1.00 1.01]);
    
    
    %----------------------------------------------------------------------
    %  Plot the relative error between the audios
    %----------------------------------------------------------------------
    subplot(2, 1, 2);
    
    plot(time, log10(relativeError), 'LineWidth', 2); hold on;
    plot([time(1) time(end)], log10(relativeError_average) * [1 1], '-r', 'LineWidth', 2);
    
    set(gca, 'FontSize', 32, ...
             'XGrid', 'on', ...
             'XTick', 1 : 0.001 : 1.01, ...
             'XTickLabel', {'1.000', '', '1.002', '', '1.004', '', '1.006', '', '1.008', '', '1.010'}, ...
             'YTick', -2 : 2, ...
             'YTickLabel', {'1%', '10%', '100%', '1000%', '10000%'});
    
    xlabel('Time (s)', 'FontSize', 32);
    ylabel('Relative error', 'FontSize', 32);
    
    axis tight;
    axis([1.00 1.01 -2 2]);
    
    
    %----------------------------------------------------------------------
    %  Play the decrypted audio file
    %----------------------------------------------------------------------
    sound(x, sampleRate);
    
    % Save the audio and plot
    fileName_option = sprintf('_obtained%d%d', encryptionOption, noiseOption);
    
    audiowrite(strcat('audio', fileName_option, '.wav'), x, sampleRate);
    
    print(strcat('plot', fileName_option), '-dpng', '-r300');
end