%--------------------------------------------------------------------------
%  Authors:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    Oscar F. Lopez
%    
%  Summary:
%    
%    This routine reads the nonogram input and solution files, sets up
%    the compressive sensing problem, and solves it. Afterwards, it shows
%    the true and obtained solutions side-by-side.
%    
%  Instructions:
%    
%    Type the following onto Matlab's command window:
%    
%    solve_nonogram(testCase)
%    
%    where
%    
%    testCase = 1, 2, ... (which nonogram to look at)
%    
%--------------------------------------------------------------------------
function solve_nonogram(testCase)
    clc;
    close all;
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Step 1: Read the input and solution files
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    [row_sequences, column_sequences, m, n, N, s, ~] = read_input_file(testCase);
    
    x_true = read_solution_file(testCase, m, n, N, s);
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Step 2: Create linear constraints
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Create constraints using row basis vectors
    [A_row, A_col, A_val, b, ...
     B_row, B_col, B_val, c, ...
     numEquations, numInequalities] = ...
    create_constraints(row_sequences, column_sequences, m, n, s);
    
    
    % Create sparse matrices A and B
    A = sparse(A_row, A_col, A_val);
    B = sparse(B_row, B_col, B_val);
    
    
    % Remove large variables that we no longer need
    clear A_row A_col A_val ...
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
    fprintf('Number of unknowns: %d\n', N);
    fprintf('Sparsity level: %d\n\n', s);
    
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
                           'ObjectiveCutOff'    , s + 1);
    %}
    
    % Solve for x
    x = intlinprog(ones(N, 1), ...
                   1 : double(N), ...
                   B, c, ...
                   A, b, ...
                   zeros(N, 1), ones(N, 1), ...
                   []);
    
    
    
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
    path_to_save_directory = './solutions/';
    
    % Create the directory if it does not exist
    if ~exist(path_to_save_directory, 'dir')
        mkdir(path_to_save_directory);
    end
    
    print('-dpng', '-r0', sprintf('%snonogram%d.png', path_to_save_directory, testCase));
end