%--------------------------------------------------------------------------
%  Authors:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    Oscar F. Lopez
%    
%  Summary:
%    
%    This routine reads the solution file, which is a text file with the
%    name nonogram_solution<testCase>.txt and is located in a subdirectory
%    called input_files.
%    
%    The file contains the following lines (note that the numbers are
%    separated by a whitespace):
%    
%    i1 k1 j1
%    i2 k2 j2
%    ...
%    iN kN jN   (all the local indices)
%--------------------------------------------------------------------------
function x_true = read_solution_file(testCase, m, n, N, s)
    %----------------------------------------------------------------------
    %  Set problem parameters
    %----------------------------------------------------------------------
    % Open the file
    fileID = fopen(sprintf('input_files/nonogram_solution%d.txt', testCase));
    
    % Array of global indices
    table_globalIndices = local_to_global(m, n);
    
    % True solution vector
    x_true = zeros(N, 1);
    
    
    %----------------------------------------------------------------------
    %  Read the local indices
    %----------------------------------------------------------------------
    lines_of_text = textscan(fileID, '%s', 'delimiter', '\n');
    
    fclose(fileID);
    
    if (length(lines_of_text{1}) ~= s)
        error(['We did not assign the correct number of basis vectors.' ...
               ' Please check the solution file.']);
    end
    
    for i = 1 : s
        % Get the local index
        localIndex = str2num(lines_of_text{1}{i});
        
        % Find the global index
        globalIndex = table_globalIndices(localIndex(2), localIndex(3), localIndex(1));
        
        % Update the true solution vector
        x_true(globalIndex) = 1;
    end
end