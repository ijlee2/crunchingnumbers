%--------------------------------------------------------------------------
%  Authors:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    Oscar F. Lopez
%    
%  Summary:
%    
%    This routine reads the nonogram input and solution files, sets up
%    the compressive sensing problem, and solves it. In addition to the
%    usual constraints, we consider those due to column basis vectors.
%    Once the routine solves the problem, it shows the true and obtained
%    solutions side-by-side.
%    
%  Instructions:
%    
%    Type the following onto Matlab's command window:
%    
%    solve_nonogram_column(testCase)
%    
%    where
%    
%    testCase = 1, 2, ... (which nonogram to look at)
%    
%--------------------------------------------------------------------------
function solve_nonogram_column(testCase)
    clc;
    close all;
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Step 1: Read the input and solution files
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    [row_sequences, column_sequences, m, n, N, s_row, s_column] = ...
    read_input_file(testCase);
    
    x_true = read_solution_file(testCase, m, n, N, s_row);
    
    % Size of the augmented solution vector
    N_augmented = N + n * m * (m + 1) / 2;
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Step 2: Create linear constraints
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Create constraints using row basis vectors
    [A1_row, A1_col, A1_val, b1, ...
     B1_row, B1_col, B1_val, c1, ...
     numEquations1, numInequalities1] = ...
    create_constraints(row_sequences, column_sequences, m, n, s_row);
    
    
    % Create constraints using column basis vectors
    [A2_row, A2_col, A2_val, b2, ...
     B2_row, B2_col, B2_val, c2, ...
     numEquations2, numInequalities2] = ...
    create_constraints(column_sequences, row_sequences, n, m, s_column);
    
    
    % Create constraints that join the row and column basis vectors
    [A3_row, A3_col, A3_val, b3, numEquations3] = ...
    create_join_constraints(m, n);
    
    
    % Create sparse matrices A, B and RHS vectors b, c
    A_row = [A1_row; A2_row + double(numEquations1); A3_row + double(numEquations1 + numEquations2)];
    A_col = [A1_col; A2_col + double(N); A3_col];
    A_val = [A1_val; A2_val; A3_val];
    
    B_row = [B1_row; B2_row + double(numInequalities1)];
    B_col = [B1_col; B2_col + double(N)];
    B_val = [B1_val; B2_val];
    
    A = sparse(A_row, A_col, A_val);
    B = sparse(B_row, B_col, B_val);
    
    b = [b1; b2; b3];
    c = [c1; c2];
    
    numEquations    = numEquations1 + numEquations2 + numEquations3;
    numInequalities = numInequalities1 + numInequalities2;
    
    
    % Remove large variables that we no longer need
    clear A1_row A1_col A1_val b1 ...
          B1_row B1_col B1_val c1 ...
          A2_row A2_col A2_val b2 ...
          B2_row B2_col B2_val c2 ...
          A3_row A3_col A3_val b3 ...
          A_row A_col A_val ...
          B_row B_col B_val;
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Step 3: Solve the minimization problem
    %   
    %   Use Matlab's intlinprog to solve the l1-minimization problem:
    %   
    %     min ||x||_{1}
    %      x
    %     
    %     subject to  Ax  = b,
    %                 Bx <= c,
    %                 x is a binary vector
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    fprintf('Number of unknowns: %d\n', N_augmented);
    fprintf('Sparsity level: %d\n\n', s_row + s_column);
    
    fprintf('Number of equations: %d\n', numEquations);
    fprintf('Number of inequalities: %d\n\n', numInequalities);
    
    % Solver parameters that we can tune
    %{
    options = optimoptions('intlinprog'         , ...
                           'ConstraintTolerance', 1e-6, ...
                           'Display'            , 'off', ...
                           'Heuristics'         , 'none', ...
                           'IntegerPreprocess'  , 'none', ...
                           'IntegerTolerance'   , 1e-3, ...
                           'LPPreprocess'       , 'none', ...
                           'NodeSelection'      , 'minobj', ...
                           'ObjectiveCutOff'    , s_row + s_column + 1);
    %}
    
    % Solve for x
    x = intlinprog(ones(N_augmented, 1), ...
                   1 : double(N_augmented), ...
                   B, c, ...
                   A, b, ...
                   zeros(N_augmented, 1), ones(N_augmented, 1), ...
                   []);
    
    % Remove variables that correspond to column basis vectors
    x((N + 1) : end) = [];
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Step 4: Display the solution
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
    
    
    %----------------------------------------------------------------------
    %  Draw the true solution
    %----------------------------------------------------------------------
    subplot('Position', [0.05 0.10 0.40 0.80]);
    
    draw_solution(x_true, row_sequences, column_sequences, m, n);
    
    title('True solution', 'FontUnits', 'normalized', 'FontSize', 0.10);
    
    
    %----------------------------------------------------------------------
    %  Draw the obtained solution
    %----------------------------------------------------------------------
    subplot('Position', [0.55 0.10 0.40 0.80]);
    
    draw_solution(x, row_sequences, column_sequences, m, n);
    
    title('Obtained solution', 'FontUnits', 'normalized', 'FontSize', 0.10);
    
    
    %----------------------------------------------------------------------
    %  Save the figure to a png file
    %----------------------------------------------------------------------
    path_to_save_directory = './solutions_column/';
    
    % Create the directory if it does not exist
    if ~exist(path_to_save_directory, 'dir')
        mkdir(path_to_save_directory);
    end
    
    print('-dpng', '-r0', sprintf('%snonogram%d.png', path_to_save_directory, testCase));
end