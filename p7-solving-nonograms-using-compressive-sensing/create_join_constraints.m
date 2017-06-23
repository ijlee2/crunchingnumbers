%--------------------------------------------------------------------------
%  Authors:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    Oscar F. Lopez
%    
%  Summary:
%    
%    This routine creates the join constraints that are told in Part 4
%    of the blog series.
%--------------------------------------------------------------------------
function [A_row, A_col, A_val, b, numEquations] = create_join_constraints(m, n)
    %----------------------------------------------------------------------
    %  Set problem parameters
    %----------------------------------------------------------------------
    % Create two arrays of global indices, one for the row basis vectors
    % and another for the column basis vectors
    table_globalIndices_row    = local_to_global(m, n);
    table_globalIndices_column = local_to_global(n, m);
    
    % Size of the solution vector
    N = m * n * (n + 1) / 2;
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Determine how many nonzero entries will be in the matrix A for
    %   linear equality constraints
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    numEntries_in_A = 0;
    numEntries_in_b = m * n;
    
    % Consider the (I, J)-th cell
    for I = 1 : m
        for J = 1 : n
            % For the row basis vectors
            for k = 1 : n
                j_lo = max(J - k + 1, 1);
                j_hi = min(n - k + 1, J);
                
                numEntries_in_A = numEntries_in_A + (j_hi - j_lo + 1);
            end
            
            % For the column basis vectors
            for k = 1 : m
                i_lo = max(I - k + 1, 1);
                i_hi = min(m - k + 1, I);
                
                numEntries_in_A = numEntries_in_A + (i_hi - i_lo + 1);
            end
        end
    end
    
    % Initialize row, column, and value arrays
    A_row = zeros(numEntries_in_A, 1);
    A_col = A_row;
    A_val = A_row;
    
    b = zeros(numEntries_in_b, 1);
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Build linear equality constraints to join the row basis vectors
    %   with the column basis vectors. This results in a matrix with mn
    %   rows.
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Counters for entries and rows of A
    index_entry_A = 1;
    index_row_A   = 1;
    
    % Consider the (I, J)-th cell
    for I = 1 : m
        for J = 1 : n
            % For the row basis vectors
            for k = 1 : n
                j_lo = max(J - k + 1, 1);
                j_hi = min(n - k + 1, J);
                
                for j = j_lo : j_hi
                    A_row(index_entry_A) = index_row_A;
                    A_col(index_entry_A) = table_globalIndices_row(k, j, I);
                    A_val(index_entry_A) = 1;
                    
                    index_entry_A = index_entry_A + 1;
                end
            end
            
            % For the column basis vectors
            for k = 1 : m
                i_lo = max(I - k + 1, 1);
                i_hi = min(m - k + 1, I);
                
                for i = i_lo : i_hi
                    A_row(index_entry_A) = index_row_A;
                    A_col(index_entry_A) = N + table_globalIndices_column(k, i, J);
                    A_val(index_entry_A) = -1;
                    
                    index_entry_A = index_entry_A + 1;
                end
            end
            
            % The number of row basis vectors that pass the (I, J)-th cell
            % must equal the number of column basis vectors that pass it
            b(index_row_A) = 0;
            
            index_row_A = index_row_A + 1;
        end
    end
    
    
    %----------------------------------------------------------------------
    %  Record how many equations we considered
    %----------------------------------------------------------------------
    numEquations = numEntries_in_b;
end