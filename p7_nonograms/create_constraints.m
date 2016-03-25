%--------------------------------------------------------------------------
%  Authors:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    Oscar F. Lopez
%    
%  Summary:
%    
%    This routine creates the nonogram constraints that are described in
%    Part 3 of the blog series.
%--------------------------------------------------------------------------
function [A_row, A_col, A_val, b, ...
          B_row, B_col, B_val, c, ...
          numEquations, numInequalities] = ...
         create_constraints(row_sequences, column_sequences, m, n, s)   
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
    
    numEntries_in_b = 0;
    numEntries_in_c = 0;
    
    
    %----------------------------------------------------------------------
    %  Linear equality constraint in Section 4a
    %----------------------------------------------------------------------
    numEntries_in_A = numEntries_in_A + N;
    numEntries_in_b = numEntries_in_b + 1;
    
    
    %----------------------------------------------------------------------
    %  Linear equality constraints in Section 4b
    %----------------------------------------------------------------------
    countEntries = 0;
    
    for J = 1 : n
        for k = 1 : n
            j_lo = max(J - k + 1, 1);
            j_hi = min(n - k + 1, J);
            
            countEntries = countEntries + (j_hi - j_lo + 1);
        end
    end
    
    numEntries_in_A = numEntries_in_A + m * countEntries;
    numEntries_in_b = numEntries_in_b + n;
    
    
    %----------------------------------------------------------------------
    %  Linear equality constraints in Section 4c
    %----------------------------------------------------------------------
    numEntries_in_A = numEntries_in_A + N;
    numEntries_in_b = numEntries_in_b + m * n;
    
    
    %----------------------------------------------------------------------
    %  Linear inequality constraints in Section 4d
    %----------------------------------------------------------------------
    countEntries = 0;
    
    for J = 1 : n
        for k = 1 : n
            j_lo = max(J - k + 1, 1);
            j_hi = min(n - k + 1, J + 1);
            
            countEntries = countEntries + (j_hi - j_lo + 1);
        end
    end
    
    numEntries_in_B = numEntries_in_B + m * countEntries;
    numEntries_in_c = numEntries_in_c + m * n;
    
    
    %----------------------------------------------------------------------
    %  Linear inequality constraints in Section 4e
    %----------------------------------------------------------------------
    countEntries = 0;
    countInequalities = 0;
    
    for I = 1 : m
        sequence = row_sequences{I};
        
        p = length(sequence);
        
        if (p == 1)
            continue;
            
        elseif (length(unique(sequence)) == p)
            for L = 1 : (p - 1)
                % For the L-th block
                sequence_left  = sequence(1 : (L - 1));
                k              = sequence(L);
                sequence_right = sequence((L + 1) : p);
                
                numCellsTaken_left  = sum(sequence_left)  + length(sequence_left);
                numCellsTaken_right = sum(sequence_right) + length(sequence_right);
                
                j_lo = numCellsTaken_left + 1;
                j_hi = (n - numCellsTaken_right) - k + 1;
                
                countEntries = countEntries + 2 * (j_hi - j_lo + 1);
                
                % For the (L + 1)-th block
                sequence_left  = sequence(1 : L);
                k              = sequence(L + 1);
                sequence_right = sequence((L + 2) : p);
                
                numCellsTaken_left  = sum(sequence_left)  + length(sequence_left);
                numCellsTaken_right = sum(sequence_right) + length(sequence_right);
                
                j_lo = numCellsTaken_left + 1;
                j_hi = (n - numCellsTaken_right) - k + 1;
                
                countEntries = countEntries + (j_hi - j_lo + 1);
            end
            
            countInequalities = countInequalities + 2*(p - 1);
            
        else
            for L = 1 : p
                sequence_left  = sequence(1 : (L - 1));
                k              = sequence(L);
                sequence_right = sequence((L + 1) : p);
                
                numCellsTaken_left  = sum(sequence_left)  + length(sequence_left);
                numCellsTaken_right = sum(sequence_right) + length(sequence_right);
                
                j_lo = numCellsTaken_left + 1;
                j_hi = (n - numCellsTaken_right) - k + 1;
                
                countEntries = countEntries + 2 * (j_hi - j_lo + 1);
            end
            
            countInequalities = countInequalities + 2*p;
        end
    end
    
    numEntries_in_B = numEntries_in_B + countEntries;
    numEntries_in_c = numEntries_in_c + countInequalities;
    
    
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
    %   Section 4a:
    %   
    %   Build a linear equality constraint to enforce the sparsity level.
    %   This results in a matrix with 1 row.
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Counters for entries and rows of A
    index_entry_A = 1;
    index_row_A   = 1;
    
    for globalIndex = 1 : N
    	A_row(index_entry_A) = index_row_A;
        A_col(index_entry_A) = globalIndex;
        A_val(index_entry_A) = 1;
        
        index_entry_A = index_entry_A + 1;
    end
    
    b(index_row_A) = s;
    
    index_row_A = index_row_A + 1;
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Section 4b:
    %   
    %   Build linear equality constraints to enforce the column sums.
    %   This results in a matrix with n rows.
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Consider the J-th column
    for J = 1 : n
        % Build the linear equation
        for i = 1 : m
            for k = 1 : n
                j_lo = max(J - k + 1, 1);
                j_hi = min(n - k + 1, J);
                
                for j = j_lo : j_hi
                    A_row(index_entry_A) = index_row_A;
                    A_col(index_entry_A) = table_globalIndices(k, j, i);
                    A_val(index_entry_A) = 1;
                    
                    index_entry_A = index_entry_A + 1;
                end
            end
        end
        
        % Find the column sum
        b(index_row_A) = sum(column_sequences{J});
        
        index_row_A = index_row_A + 1;
    end
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Section 4c:
    %   
    %   Build linear equality constraints to check that each block size
    %   appears a correct number of times. This results in a matrix with
    %   mn rows.
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Consider the I-th row
    for I = 1 : m
        % Consider block of size K
        for K = 1 : n
            % Build the linear equation
            j_hi = n - K + 1;
            
            for j = 1 : j_hi
                A_row(index_entry_A) = index_row_A;
                A_col(index_entry_A) = table_globalIndices(K, j, I);
                A_val(index_entry_A) = 1;
                
                index_entry_A = index_entry_A + 1;
            end
            
            % Count how many times k appears in the row sequence
            b(index_row_A) = sum(row_sequences{I} == K);
            
            index_row_A = index_row_A + 1;
        end
    end
    
    if (index_entry_A - 1 ~= numEntries_in_A)
        error(['We did not assign the correct number of entries in A.' ...
               ' Please check the code.']);
    end
    
    if (index_row_A - 1 ~= numEntries_in_b)
        error(['We did not assign the correct number of entries in b.' ...
               ' Please check the code.']);
    end
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Section 4d:
    %   
    %   Build linear inequality constraints so that mutually exclusive
    %   basis vectors do not appear together. This results in a matrix
    %   with mn rows.
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Counters for entries and rows of B
    index_entry_B = 1;
    index_row_B   = 1;
    
    % Consider the (I, J)-th cell
    for I = 1 : m
        for J = 1 : n
            % Build the linear inequality
            for k = 1 : n
                j_lo = max(J - k + 1, 1);
                j_hi = min(n - k + 1, J + 1);
                
                for j = j_lo : j_hi
                    B_row(index_entry_B) = index_row_B;
                    B_col(index_entry_B) = table_globalIndices(k, j, I);
                    B_val(index_entry_B) = 1;
                    
                    index_entry_B = index_entry_B + 1;
                end
            end
            
            % At most 1 among the basis vectors can appear
            c(index_row_B) = 1;
            
            index_row_B = index_row_B + 1;
        end
    end
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Section 4e:
    %   
    %   Build linear inequality constraints to ensure that the blocks
    %   appear in the correct order. This results in a matrix with at
    %   most 2s rows.
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Consider the I-th row
    for I = 1 : m
        sequence = row_sequences{I};
        
        % Find the number of blocks in the sequence
        p = length(sequence);
        
        if (p == 1)
            continue;
            
        elseif (length(unique(sequence)) == p)
            for L = 1 : (p - 1)
                % For the L-th block
                sequence_left  = sequence(1 : (L - 1));
                k              = sequence(L);
                sequence_right = sequence((L + 1) : p);
                
                numCellsTaken_left  = sum(sequence_left)  + length(sequence_left);
                numCellsTaken_right = sum(sequence_right) + length(sequence_right);
                
                j_lo = numCellsTaken_left + 1;
                j_hi = (n - numCellsTaken_right) - k + 1;
                
                for j = j_lo : j_hi
                    B_row(index_entry_B) = index_row_B;
                    B_col(index_entry_B) = table_globalIndices(k, j, I);
                    B_val(index_entry_B) = -j;
                    
                    index_entry_B = index_entry_B + 1;
                    
                    B_row(index_entry_B) = index_row_B + 1;
                    B_col(index_entry_B) = table_globalIndices(k, j, I);
                    B_val(index_entry_B) = j;
                    
                    index_entry_B = index_entry_B + 1;
                end
                
                % For the (L + 1)-th block
                sequence_left  = sequence(1 : L);
                k              = sequence(L + 1);
                sequence_right = sequence((L + 2) : p);
                
                numCellsTaken_left  = sum(sequence_left)  + length(sequence_left);
                numCellsTaken_right = sum(sequence_right) + length(sequence_right);
                
                j_lo = numCellsTaken_left + 1;
                j_hi = (n - numCellsTaken_right) - k + 1;
                
                for j = j_lo : j_hi
                    B_row(index_entry_B) = index_row_B + 1;
                    B_col(index_entry_B) = table_globalIndices(k, j, I);
                    B_val(index_entry_B) = -j;
                    
                    index_entry_B = index_entry_B + 1;
                end
                
                % Change strict inequality to an inequality with equal sign
                c(index_row_B    ) = -1;
                c(index_row_B + 1) = -1;
                
                index_row_B = index_row_B + 2;
            end
            
        else
            % Keep track of where each block can appear
            j_range = zeros(2, p);
            
            % Build the linear inequality for the lower bound
            for L = 1 : p
                sequence_left  = sequence(1 : (L - 1));
                k              = sequence(L);
                sequence_right = sequence((L + 1) : p);
                
                numCellsTaken_left  = sum(sequence_left)  + length(sequence_left);
                numCellsTaken_right = sum(sequence_right) + length(sequence_right);
                
                j_lo = numCellsTaken_left + 1;
                j_hi = (n - numCellsTaken_right) - k + 1;
                j_range(:, L) = [j_lo; j_hi];
                
                for j = j_lo : j_hi
                    B_row(index_entry_B) = index_row_B;
                    B_col(index_entry_B) = table_globalIndices(k, j, I);
                    B_val(index_entry_B) = -1;
                    
                    index_entry_B = index_entry_B + 1;
                end
                
                % There is at least 1 block of size k
                c(index_row_B) = -1;
                
                index_row_B = index_row_B + 1;
            end
            
            % Build the linear inequality for the upper bound
            for L = 1 : p
                k = sequence(L);
                
                j_lo = j_range(1, L);
                j_hi = j_range(2, L);
                
                for j = j_lo : j_hi
                    B_row(index_entry_B) = index_row_B;
                    B_col(index_entry_B) = table_globalIndices(k, j, I);
                    B_val(index_entry_B) = 1;
                    
                    index_entry_B = index_entry_B + 1;
                end
                
                % Count how many other blocks of size k can overlap with
                % the L-th block
                numOverlaps = 1;
                
                for L1 = (L - 1) : -1 : 1
                    if (sequence(L1) ~= k)
                        continue;
                    elseif (j_lo <= j_range(2, L1))
                        numOverlaps = numOverlaps + 1;
                    else
                        break;
                    end
                end
                
                for L1 = (L + 1) : p
                    if (sequence(L1) ~= k)
                        continue;
                    elseif (j_hi >= j_range(1, L1))
                        numOverlaps = numOverlaps + 1;
                    else
                        break;
                    end
                end
                
                c(index_row_B) = numOverlaps;
                
                index_row_B = index_row_B + 1;
            end
            
        end
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