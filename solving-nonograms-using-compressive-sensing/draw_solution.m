%--------------------------------------------------------------------------
%  Authors:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    Oscar F. Lopez
%    
%  Summary:
%    
%    This routine reads the solution vector and draws the solution that
%    it represents.
%--------------------------------------------------------------------------
function draw_solution(x, row_sequences, column_sequences, m, n)
    %----------------------------------------------------------------------
    %  Set problem parameters
    %----------------------------------------------------------------------
    % Create an array of local indices
    table_localIndices = global_to_local(m, n);
    
    % Round the solution to the nearest integer
    x = round(x);
    
    % Size of the solution vector
    N = length(x);
    
    
    %----------------------------------------------------------------------
    %  Draw the solution
    %----------------------------------------------------------------------
    block_color = [1/255 124/255 93/255];
    
    for globalIndex = 1 : N
        if (x(globalIndex) == 1)
            localIndices = table_localIndices(:, globalIndex);
            
            i = localIndices(1);
            k = localIndices(2);
            j = localIndices(3);
            
            rectangle('Position' , [j - 1, -i, k, 1], ...
                      'Curvature', [0.05 0.05], ...
                      'FaceColor', block_color, ...
                      'LineWidth', 0.5);
            hold on;
        end
    end
    
    
    %----------------------------------------------------------------------
    %  Display the row sequences
    %----------------------------------------------------------------------
    row_sequence_size = 1;
    
    for i = 1 : m
        b = row_sequences{i};
        p = length(b);
        
        if (p > row_sequence_size)
            row_sequence_size = p;
        end
        
        % Remove the FontName option if you do not have Montserrat font
        for k = 1 : p
            text(double(-k), double(-i) + 0.5, ...
                 num2str(b(p - k + 1)), ...
                 'FontUnits', 'normalized', ...
                 'FontName' , 'Montserrat Semi Bold', ...
                 'FontSize' , 0.5 / double(max(m, n)));
        end
    end
    
    
    %----------------------------------------------------------------------
    %  Display the column sequences
    %----------------------------------------------------------------------
    column_sequence_size = 1;
    
    for j = 1 : n
        b = column_sequences{j};
        p = length(b);
        
        if (p > column_sequence_size)
            column_sequence_size = p;
        end
        
        % Remove the FontName option if you do not have Montserrat font
        for k = 1 : p
            text(double(j - 1) + 0.25, double(k), ...
                 num2str(b(p - k + 1)), ...
                 'FontUnits', 'normalized', ...
                 'FontName' , 'Montserrat Semi Bold', ...
                 'FontSize' , 0.5 / double(max(m, n)));
        end
    end
    
    
    %----------------------------------------------------------------------
    %  Draw borders
    %----------------------------------------------------------------------
    % Set the window size
    x_min = -row_sequence_size - 1;
    x_max = n;
    y_min = -m;
    y_max = column_sequence_size + 1;
    
    % Set the color of the border
    border_color = [0.10 0.10 0.25];
    
    plot([x_min x_max], [y_min y_min], '-', 'Color', border_color, 'LineWidth', 4);
    plot([x_min x_max], [    0     0], '-', 'Color', border_color, 'LineWidth', 4);
    plot([x_min x_max], [y_max y_max], '-', 'Color', border_color, 'LineWidth', 4);
    
    plot([x_min x_min], [y_min y_max], '-', 'Color', border_color, 'LineWidth', 4);
    plot([    0     0], [y_min y_max], '-', 'Color', border_color, 'LineWidth', 4);
    plot([x_max x_max], [y_min y_max], '-', 'Color', border_color, 'LineWidth', 4);
    
    axis off square;
    axis([x_min x_max y_min y_max]);
    set(gca, 'XTick', {}, 'YTick', {});
end