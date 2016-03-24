%--------------------------------------------------------------------------
%  Authors:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    Oscar F. Lopez
%    
%  Summary:
%    
%    This routine reads the input file, which is a text file with the
%    name nonogram_input<testCase>.txt and is located in a subdirectory
%    called input_files.
%    
%    The file contains the following lines (note that the numbers are
%    separated by a whitespace):
%    
%    m n                 (size of the nonogram)
%    b1 b2 ... bp_{1}
%    ...
%    b1 b2 ... bp_{m}    (all the row sequences)
%    b1 b2 ... bp_{1}
%    ...
%    b1 b2 ... bp_{n}    (all the column sequences)
%--------------------------------------------------------------------------
function [row_sequences, column_sequences, m, n, N, s_row, s_column] = read_input_file(testCase)
    %----------------------------------------------------------------------
    %  Set problem parameters
    %----------------------------------------------------------------------
    % Open the file
    fileID = fopen(sprintf('input_files/nonogram_input%d.txt', testCase));
    
    
    %----------------------------------------------------------------------
    %  Read the size of the nonogram
    %----------------------------------------------------------------------
    lines_of_text = textscan(fileID, '%d %d', 1, 'delimiter', '\n');
    m = lines_of_text{1};
    n = lines_of_text{2};
    
    % Size of the solution vector
    N = m * n * (n + 1) / 2;
    
    
    %----------------------------------------------------------------------
    %  Read the row sequences
    %----------------------------------------------------------------------
    lines_of_text = textscan(fileID, '%s', m, 'delimiter', '\n');
    
    % Array of row sequences
    row_sequences = cell(m, 1);
    
    % Sparsity level due to row basis vectors
    s_row = 0;
    
    % Sum of row sums (we use this to check the input file)
    sum_rowSums = 0;
    
    % Store the row sequences
    for i = 1 : m
        row_sequences{i} = str2num(lines_of_text{1}{i});
        
        s_row = s_row + length(row_sequences{i});
        
        sum_rowSums = sum_rowSums + sum(row_sequences{i});
    end
    
    
    %----------------------------------------------------------------------
    %  Read the column sequences
    %----------------------------------------------------------------------
    lines_of_text = textscan(fileID, '%s', 'delimiter', '\n');
    
    fclose(fileID);
    
    if (length(lines_of_text{1}) ~= n)
        error(['We did not assign the correct number of row or column' ...
               ' sequences. Please check the input file.']);
    end
    
    % Array of column sequences
    column_sequences = cell(n, 1);
    
    % Sparsity level due to column basis vectors
    s_column = 0;
    
    % Sum of column sums (we use this to check the input file)
    sum_columnSums = 0;
    
    % Store the column sequences
    for j = 1 : n
        column_sequences{j} = str2num(lines_of_text{1}{j});
        
        s_column = s_column + length(column_sequences{j});
        
        sum_columnSums = sum_columnSums + sum(column_sequences{j});
    end
    
    if (sum_rowSums ~= sum_columnSums)
        error(['The sum of row sums does not equal the sum of column' ...
               ' sums. Please check the input file.']);
    end
end