%--------------------------------------------------------------------------
%  Authors:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    Oscar F. Lopez
%    
%  Summary:
%    
%    This routine creates a lookup table that, from the global index of a
%    basis vector, finds its local indices i (row index), k (block size),
%    and j (starting column index).
%    
%    For the stylish lambda example, we would get,
%    
%    table_localIndices =
%    Columns 1 through 12
%       1     1     1     1     1     1     2     2     2     2     2     2
%       1     1     1     2     2     3     1     1     1     2     2     3
%       1     2     3     1     2     1     1     2     3     1     2     1
%    
%    Columns 13 through 24
%       3     3     3     3     3     3     4     4     4     4     4     4
%       1     1     1     2     2     3     1     1     1     2     2     3
%       1     2     3     1     2     1     1     2     3     1     2     1
%--------------------------------------------------------------------------
function table_localIndices = global_to_local(m, n)
    % Initialize the lookup table
    table_localIndices = zeros(3, m * n * (n + 1) / 2);
    
    % Counter for the global index
    globalIndex = 1;
    
    % Create the lookup table
    for i = 1 : m
        for k = 1 : n
            for j = 1 : (n - k + 1)
                table_localIndices(:, globalIndex) = [i; k; j];
                
                globalIndex = globalIndex + 1;
            end
        end
    end
end