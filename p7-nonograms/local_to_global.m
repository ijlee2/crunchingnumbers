%--------------------------------------------------------------------------
%  Authors:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    Oscar F. Lopez
%    
%  Summary:
%    
%    This routine creates a lookup table that, from the local index i, k,
%    and j of a basis vector, returns its global index.
%    
%    We store the lookup table as a 3D array. Because of how MATLAB stores
%    multi-dimensional array, we let the first two indices correspond to k
%    and j, and the third index to i.
%    
%    For the stylish lambda example, we would get,
%    
%    table_globalIndices(:, :, 1) =
%       1     2     3
%       4     5     0
%       6     0     0
%    
%    table_globalIndices(:, :, 2) =
%       7     8     9
%      10    11     0
%      12     0     0
%    
%    table_globalIndices(:, :, 3) =
%      13    14    15
%      16    17     0
%      18     0     0
%    
%    table_globalIndices(:, :, 4) =
%      19    20    21
%      22    23     0
%      24     0     0
%--------------------------------------------------------------------------
function table_globalIndices = local_to_global(m, n)
    % Initialize the lookup table
    table_globalIndices = zeros(n, n, m);
    
    % Counter for the global index
    globalIndex = 1;
    
    % Create the lookup table
    for i = 1 : m
        for k = 1 : n
            for j = 1 : (n - k + 1)
                table_globalIndices(k, j, i) = globalIndex;
                
                globalIndex = globalIndex + 1;
            end
        end
    end
end