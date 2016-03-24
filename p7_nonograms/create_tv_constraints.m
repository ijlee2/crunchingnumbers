%--------------------------------------------------------------------------
%  Authors:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    Oscar F. Lopez
%    
%  Summary:
%    
%    This routine creates the total variation constraints that are told in
%    Part 4 of the blog series.
%--------------------------------------------------------------------------
function [A_row, A_col, A_val, b, ...
          B_row, B_col, B_val, c, ...
          numEquations, numInequalities] = ...
         create_tv_constraints(column_sequences, m, n)
    %----------------------------------------------------------------------
    %  Set problem parameters
    %----------------------------------------------------------------------
    % Create an array of global indices
    table_globalIndices = local_to_global(m, n);
    
    % Size of the solution vector
    N = m * n * (n + 1) / 2;
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Determine how many nonzero entries will be in the matrices A and B
    %   for linear equality and inequality constraints
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    numEntries_in_A = 0;
    numEntries_in_B = 0;
    
    numEntries_in_b = (m - 1) * n;
    numEntries_in_c = (m + 1) * n;
    
    for J = 1 : n
        for I = 1 : (m - 1)
            % Build the linear equation
            for k = 1 : n
                j_lo = max(J - k + 1, 1);
                j_hi = min(n - k + 1, J);
                
                numEntries_in_A = numEntries_in_A + 2 * (j_hi - j_lo + 1);
                numEntries_in_B = numEntries_in_B + 2 * (j_hi - j_lo + 1);
            end
            
            % Write z+_{I, J} - z-_{I, J} for the linear equation
            numEntries_in_A = numEntries_in_A + 2;
            
            % Ensure uniqueness of auxiliary variables
            numEntries_in_B = numEntries_in_B + 1;
            
            % Lower bound for total variation
            numEntries_in_B = numEntries_in_B + 2;
            
            % Upper bound for total variation
            numEntries_in_B = numEntries_in_B + 2;
        end
    end
    
    
    %----------------------------------------------------------------------
    %  Initialize row, column, and value arrays
    %----------------------------------------------------------------------
    A_row = zeros(numEntries_in_A, 1);
    A_col = A_row;
    A_val = A_row;
    
    B_row = zeros(numEntries_in_B, 1);
    B_col = B_row;
    B_val = B_row;
    
    b = zeros(numEntries_in_b, 1);
    c = zeros(numEntries_in_c, 1);
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Build linear equality and inequality constraints to ensure that
    %   the total variations are within their bounds for each column.
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Counters for entries and rows of A
    index_entry_A = 1;
    index_row_A   = 1;
    
    % Counters for entries and rows of B
    index_entry_B = 1;
    index_row_B   = 1;
    
    % Consider the J-th column
    for J = 1 : n
        p = length(column_sequences{J});
        
        for I = 1 : (m - 1)
            % Build the linear equation
            for k = 1 : n
                j_lo = max(J - k + 1, 1);
                j_hi = min(n - k + 1, J);
                
                for j = j_lo : j_hi
                    % Write C_{I + 1, J} - C_{I, J} for the linear equation
                    A_row(index_entry_A) = index_row_A;
                    A_col(index_entry_A) = table_globalIndices(k, j, I + 1);
                    A_val(index_entry_A) = 1;
                    
                    index_entry_A = index_entry_A + 1;
                    
                    A_row(index_entry_A) = index_row_A;
                    A_col(index_entry_A) = table_globalIndices(k, j, I);
                    A_val(index_entry_A) = -1;
                    
                    index_entry_A = index_entry_A + 1;
                    
                    
                    % Write C_{I + 1, J} - C_{I, J} for the linear inequality
                    B_row(index_entry_B) = index_row_B + (I - 1);
                    B_col(index_entry_B) = table_globalIndices(k, j, I + 1);
                    B_val(index_entry_B) = 1;
                    
                    index_entry_B = index_entry_B + 1;
                    
                    B_row(index_entry_B) = index_row_B + (I - 1);
                    B_col(index_entry_B) = table_globalIndices(k, j, I);
                    B_val(index_entry_B) = -1;
                    
                    index_entry_B = index_entry_B + 1;
                end
            end
            
            
            % Locations of auxiliary variables z+_{I, J} and z-_{I, J}
            index_z_plus  = N + (J - 1) * (m - 1) + I;
            index_z_minus = index_z_plus + (m - 1) * n;
            
            
            % Write z+_{I, J} - z-_{I, J} for the linear equation
            A_row(index_entry_A) = index_row_A;
            A_col(index_entry_A) = index_z_plus;
            A_val(index_entry_A) = -1;
            
            index_entry_A = index_entry_A + 1;
            
            A_row(index_entry_A) = index_row_A;
            A_col(index_entry_A) = index_z_minus;
            A_val(index_entry_A) = 1;
            
            index_entry_A = index_entry_A + 1;
            
            b(index_row_A) = 0;
            
            index_row_A = index_row_A + 1;
            
            
            % Ensure uniqueness of auxiliary variables
            B_row(index_entry_B) = index_row_B + (I - 1);
            B_col(index_entry_B) = index_z_minus;
            B_val(index_entry_B) = 2;
            
            index_entry_B = index_entry_B + 1;
            
            
            % Lower bound for total variation
            B_row(index_entry_B) = index_row_B + (m - 1);
            B_col(index_entry_B) = index_z_plus;
            B_val(index_entry_B) = -1;
            
            index_entry_B = index_entry_B + 1;
            
            B_row(index_entry_B) = index_row_B + (m - 1);
            B_col(index_entry_B) = index_z_minus;
            B_val(index_entry_B) = -1;
            
            index_entry_B = index_entry_B + 1;
            
            
            % Upper bound for total variation
            B_row(index_entry_B) = index_row_B + m;
            B_col(index_entry_B) = index_z_plus;
            B_val(index_entry_B) = 1;
            
            index_entry_B = index_entry_B + 1;
            
            B_row(index_entry_B) = index_row_B + m;
            B_col(index_entry_B) = index_z_minus;
            B_val(index_entry_B) = 1;
            
            index_entry_B = index_entry_B + 1;
        end
        
        
        c(index_row_B : (index_row_B + m - 2)) = 1;
        c(index_row_B + m - 1)                 = -2*(p - 1);
        c(index_row_B + m)                     = 2*p;
        
        index_row_B = index_row_B + (m + 1);
    end
    
    % Check for errors
    if (index_entry_B - 1 ~= numEntries_in_B)
        error(['We did not assign the correct number of entries in B.' ...
               ' Please check the code.']);
    end
    
    if (index_row_B - 1 ~= numEntries_in_c)
        error(['We did not assign the correct number of entries in c.' ...
               ' Please check the code.']);
    end
    
    
    %----------------------------------------------------------------------
    %  Record how many equations and inequalities we considered
    %----------------------------------------------------------------------
    numEquations    = numEntries_in_b;
    numInequalities = numEntries_in_c;
end