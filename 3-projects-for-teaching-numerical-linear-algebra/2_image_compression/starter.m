%--------------------------------------------------------------------------
%  Author: Isaac J. Lee
%  
%  This routine demonstrates the use of SVD in image compression.
%  
%  You will need to add/edit/delete some code to run this program. These
%  parts are indicated by a comment beginning with the word "PROBLEM."
%  
%  To run this program, type in:
%      starter()
%--------------------------------------------------------------------------
function starter()
    clc; clf;
    
    % A is a h x w x 3 matrix and stores the intensities in the red, green,
    % and blue channel
    % cacti.jpg needs to be in the same directory as this file
    A = imread('cacti.jpg');
    h = size(A, 1); w = size(A, 2);
    
    % Extract the red, green, and blue channel matrices
    AR = double(A(:, :, 1));
    AG = double(A(:, :, 2));
    AB = double(A(:, :, 3));
    
    
    % ---------------------------------------------------------------------
    %  Perform SVD for each color channel matrix.
    % ---------------------------------------------------------------------
    [UR, SR, VR] = svd(AR);
    
    % PROBLEM #1: Find the SVD for the green and blue channels. (Please keep
    % the variable names consistent by using UG, SG, VG, UB, SB, and VB.)
    
    % END PROBLEM
    
    
    % ---------------------------------------------------------------------
    %  Find the rank of AR, AG, and AB by counting the number of positive
    %  singular values. We will use the variables r_AR, r_AG, and r_AB
    %  later to compute the relative error.
    % ---------------------------------------------------------------------
    r_AR = size(find(SR > 0), 1);
    
    % PROBLEM #2: Repeat for the green and blue channels. (Please use r_AG
    % and r_AB.)
    
    % END PROBLEM
    
    
    % ---------------------------------------------------------------------
    %  Display images
    % ---------------------------------------------------------------------
    % Display the original cacti image
    subplot(2, 3, 1);
    image(A);
    axis off; axis image;
    title('Original', 'FontSize', 13);
    set(gca, 'FontSize', 13);
    
    ranks = [5 10 20 40 80]';
    
    for i = 1 : size(ranks, 1)
        % -----------------------------------------------------------------
        %  Compute the best rank-k approximation for each channel.
        % -----------------------------------------------------------------
        k = ranks(i);
        
        AR_k = UR(:, 1:k) * SR(1:k, 1:k) * VR(:, 1:k)';
        
        % PROBLEM #3: Change the codes so that we compute the best rank-k
        % approximation for the green and blue channels.
        AG_k = zeros(h, w);
        AB_k = zeros(h, w);
        % END PROBLEM
        
        % Combine the three channels to produce the colored image
        A_k = cat(3, AR_k, AG_k, AB_k)/255;
        
        
        % -----------------------------------------------------------------
        %  Evaluate the relative error ||A - A_{k}||_{F} / ||A||_{F}.
        % -----------------------------------------------------------------
        % PROBLEM #4: Compute the relative error, not using Matlab's
        % built-in Frobenius norm, but using the singular values of A
        % instead. See problem 1(b) for the formula. Insert your code
        % into the fprintf statements below, and then uncomment the lines.
%        fprintf('For k = %d, the relative error in the red channel is %1.4g.\n', k, % ENTER THE CODE FOR RELATIVE NORM HERE %);
%        fprintf('For k = %d, the relative error in the green channel is %1.4g.\n', k, % ENTER THE CODE FOR RELATIVE NORM HERE %);
%        fprintf('For k = %d, the relative error in the blue channel is %1.4g.\n\n', k, % ENTER THE CODE FOR RELATIVE NORM HERE %);
        % END PROBLEM
        
        % Display the rank-k approximation images
        subplot(2, 3, i + 1);
        fileName = ['rank', num2str(k), '.jpg'];
        imwrite(A_k, fileName, 'jpg');
        image(imread(fileName));
        axis off; axis image;    
        delete(fileName);
        title(['k = ', num2str(k)], 'FontSize', 13);
        set(gca, 'FontSize', 13);
    end
    
    
    % ---------------------------------------------------------------------
    %  Compute another rank-k approximation for each channel and compare
    %  to the best approximation.
    % ---------------------------------------------------------------------
    figure;
    
    % Display the best rank-80 approximation (in Frobenius norm sense)
    subplot(1, 3, 1);
    imwrite(A_k, 'rank80.jpg', 'jpg');
    image(imread('rank80.jpg'));
    axis off; axis image;
    delete('rank80.jpg');
    title('A_{80}', 'FontSize', 13);
	set(gca, 'FontSize', 13);
    
    % Display the original cacti image
    subplot(1, 3, 2);
    image(A);
    axis off; axis image;
    title('Original', 'FontSize', 13);
    set(gca, 'FontSize', 13);
    
	% E is an error matrix of size w x w with full rank
    % PROBLEM #5: Set E to be the bidiagonal matrix with the diagonals
    % all 0.5's and the superdiagonals all 0.45's.
    E = zeros(w, w);
    % END PROBLEM
    
    % Display a rank-80 approximation
    subplot(1, 3, 3);
    imwrite(cat(3, AR_k*E, AG_k*E, AB_k*E)/255, 'rank80-2.jpg', 'jpg');
    image(imread('rank80-2.jpg'));
    axis off; axis image;
    delete('rank80-2.jpg');
    title('Atilde_{80}', 'FontSize', 13);
	set(gca, 'FontSize', 13);
end