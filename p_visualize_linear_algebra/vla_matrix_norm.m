%--------------------------------------------------------------------------
%  Author:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    
%  Summary:
%    
%    This routine handles the visualization of matrix norm.
%    
%  Instructions:
%    
%    Please call the main routine, visualize_linear_algebra. Type the
%    following onto Matlab's command window:
%    
%    visualize_linear_algebra
%    
%--------------------------------------------------------------------------
function vla_matrix_norm(~, ~, callerName)
    global matrices norms;
    global matrixIndex normIndex;
    global handle_gui;
    global handle_title;
    global handle_plot;
    global handle_field_norm field_norm;
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Initialize variables
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
	% Reset problem parameters
    if (strcmp(callerName, 'main_menu'))
        matrixIndex = 1;
        normIndex   = 1;
    end
    
    % Reset plot information
    if (isempty(handle_plot))
        handle_plot = struct;
        
    else
        for i = 1 : length(handle_plot.x)
            delete(handle_plot.x(i).all);
            delete(handle_plot.x(i).current);
            delete(handle_plot.x(i).label);
            delete(handle_plot.x(i).special);
        end
        
    end
    
    A = eval(matrices{matrixIndex});
    
    handle_plot.windowLocation = [0.06 0.13 0.45 0.68];
    handle_plot.windowCenter   = [0.06 0.13] + 0.5 * [0.45 0.68];
    handle_plot.windowSize     = 1.25 * max(norm(A, 'inf'), 1);
    
    % Reset field values
    field_norm = 0;
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Set the title
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    set(handle_title, 'String', 'Matrix norm');
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Set the left panel
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    subplot('Position', handle_plot.windowLocation, 'FontSize', 14);
    
    
    %----------------------------------------------------------------------
    %  Initialize the unit vector x
    %----------------------------------------------------------------------
    color       = [0.70 0.35 0.45];
    color_light = [0.90 0.55 0.45];
    
    handle_plot.x(1) = createAnimatedLine('x', color, color_light);
    
    
    %----------------------------------------------------------------------
    %  Initialize the linearly transformed vector y = A*x
    %----------------------------------------------------------------------
    color       = [0.25 0.35 0.50];
    color_light = [0.25 0.60 0.70];
    
    handle_plot.x(2) = createAnimatedLine('A*x', color, color_light);
    
    
    %----------------------------------------------------------------------
    %  Set plotting parameters
    %----------------------------------------------------------------------
    % Set the title and axis labels
    title('Click and drag on this plot window!', 'FontSize', 19);
    
    xlabel('x_{1}'     , 'FontSize', 22);
    ylabel('x_{2}     ', 'FontSize', 22, 'Rotation', 0);
    
    % Set the plot range
    axis(handle_plot.windowSize * [-1 1 -1 1]);
    axis square;
    
    grid on;
    
    set(gca, 'YTick'     , get(gca, 'XTick'), ...
             'YTickLabel', get(gca, 'XTickLabel'));
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Set the right panel
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Set the colors
    backgroundColor = handle_gui.Color;
    foregroundColor = [0.30 0.25 0.45];
    
    
    % Create a beveled panel for aesthetics
    handle_rightPanel = ...
    uipanel('Title'                , '', ...
            'TitlePosition'        , 'lefttop', ...
            'Position'             , [0.54 0.13 0.36 0.68], ...
            'BackgroundColor'      , backgroundColor, ...
            'BorderType'           , 'beveledin', ...
            'ForegroundColor'      , [0.00 0.00 0.00], ...
            'FontSize'             , 20, ...
            'FontWeight'           , 'bold');
    
    
    % Create the label for the drop down menu for matrices
    uicontrol('Parent'             , handle_rightPanel, ...
              'Style'              , 'text', ...
              'String'             , 'Select the matrix A:', ...
              'Units'              , 'normalized', ...
              'Position'           , [0.02 0.90 0.96 0.08], ...
              'BackgroundColor'    , backgroundColor, ...
              'ForegroundColor'    , foregroundColor, ...
              'FontSize'           , 18, ...
              'FontWeight'         , 'normal', ...
              'HorizontalAlignment', 'left');
    
    % Create the drop down menu for matrices
    uicontrol('Parent'             , handle_rightPanel, ...
              'Style'              , 'popupmenu', ...
              'String'             , matrices, ...
              'Value'              , matrixIndex, ...
              'Units'              , 'normalized', ...
              'Position'           , [0.02 0.76 0.96 0.08], ...
              'BackgroundColor'    , [0.90 0.92 0.95], ...
              'ForegroundColor'    , [0.10 0.10 0.10], ...
              'FontName'           , 'courier', ...
              'FontSize'           , 17, ...
              'FontWeight'         , 'bold', ...
              'HorizontalAlignment', 'left', ...
              'Callback'           , @changeMatrix);
    
    
    % Create the label for the drop down menu for norms
    uicontrol('Parent'             , handle_rightPanel, ...
              'Style'              , 'text', ...
              'String'             , 'Select the norm p:', ...
              'Units'              , 'normalized', ...
              'Position'           , [0.02 0.55 0.96 0.08], ...
              'BackgroundColor'    , backgroundColor, ...
              'ForegroundColor'    , foregroundColor, ...
              'FontSize'           , 18, ...
              'FontWeight'         , 'normal', ...
              'HorizontalAlignment', 'left');
    
    % Create the drop down menu for norms
    uicontrol('Parent'             , handle_rightPanel, ...
              'Style'              , 'popupmenu', ...
              'String'             , norms, ...
              'Value'              , normIndex, ...
              'Units'              , 'normalized', ...
              'Position'           , [0.02 0.41 0.38 0.08], ...
              'BackgroundColor'    , [0.90 0.92 0.95], ...
              'ForegroundColor'    , [0.10 0.10 0.10], ...
              'FontName'           , 'courier', ...
              'FontSize'           , 17, ...
              'FontWeight'         , 'bold', ...
              'HorizontalAlignment', 'left', ...
              'Callback'           , @changeNorm);
    
    
    % Create the label for the field for maximum norm
    uicontrol('Parent'             , handle_rightPanel, ...
              'Style'              , 'text', ...
              'String'             , 'Largest ||Ax||_{p} found:', ...
              'Units'              , 'normalized', ...
              'Position'           , [0.02 0.20 0.96 0.08], ...
              'BackgroundColor'    , backgroundColor, ...
              'ForegroundColor'    , foregroundColor, ...
              'FontSize'           , 18, ...
              'FontWeight'         , 'normal', ...
              'HorizontalAlignment', 'left');
    
    % Create the field for maximum norm
    handle_field_norm = ...
    uicontrol('Parent'             , handle_rightPanel, ...
              'Style'              , 'text', ...
              'String'             , 'Find me!', ...
              'Units'              , 'normalized', ...
              'Position'           , [0.02 0.06 0.75 0.08], ...
              'BackgroundColor'    , [0.86 0.84 0.86], ...
              'ForegroundColor'    , [0.50 0.10 0.10], ...
              'FontName'           , 'courier', ...
              'FontSize'           , 17, ...
              'FontWeight'         , 'bold', ...
              'HorizontalAlignment', 'left');
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Wait for user response
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    set(handle_gui, 'WindowButtonDownFcn', @startDrawing, ...
                    'WindowButtonUpFcn'  , @stopDrawing);
end


%--------------------------------------------------------------------------
% -------------------------------------------------------------------------
%   Call this routine to create an animated line on the plot window
%   
%   The variable output, which is an array of structs, contains the
%   following information:
%      
%      all     - list of all vectors
%      current - handle to the most recently drawn vector
%      label   - handle to the label
%      special - handle to the "special" vector
% -------------------------------------------------------------------------
%--------------------------------------------------------------------------
function output = createAnimatedLine(label, color, color_light)
    output = struct;
    
    output.all     = animatedline('Color'     , color, ...
                                  'LineStyle' , 'none', ...
                                  'Marker'    , '.', ...
                                  'MarkerSize', 7);
    
    output.current = line([0 0], [0 0], 'Color', color_light, 'LineWidth', 2);
    hold on;
    
    output.label   = text(0, 0, label, 'Color'     , color, ...
                                       'FontSize'  , 18, ...
                                       'FontWeight', 'bold', ...
                                       'Visible'   , 'off');
    
    output.special = plot(0, 0, 'o', 'Color'          , color, ...
                                     'MarkerFaceColor', color_light, ...
                                     'MarkerSize'     , 10, ...
                                     'Visible'        , 'off');
    hold on;
end


%--------------------------------------------------------------------------
% -------------------------------------------------------------------------
%   Call this routine to change the matrix
% -------------------------------------------------------------------------
%--------------------------------------------------------------------------
function changeMatrix(source, ~)
    global matrixIndex;
    
	% Update the matrix index
    matrixIndex = source.Value;
    
    vla_matrix_norm([], [], 'me');
end


%--------------------------------------------------------------------------
% -------------------------------------------------------------------------
%   Call this routine to change the norm
% -------------------------------------------------------------------------
%--------------------------------------------------------------------------
function changeNorm(source, ~)
    global normIndex;
    
    % Update the norm index
    normIndex = source.Value;
    
    vla_matrix_norm([], [], 'me');
end


%--------------------------------------------------------------------------
% -------------------------------------------------------------------------
%   This routine traces the unit vector x and the linearly transformed
%   vector y = A*x. It updates the fields that appear on the GUI.
% -------------------------------------------------------------------------
%--------------------------------------------------------------------------
function startDrawing(source, ~)
    global matrices norms;
    global matrixIndex normIndex;
    global handle_gui;
    global handle_plot;
    global handle_field_norm field_norm;
    
    
    % Find the matrix and the norm
    A = eval(matrices{matrixIndex});
    p = norms{normIndex};
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Find the unit vector that points to the mouse cursor
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Get the location of the mouse cursor
    mouseLocation = get(source, 'CurrentPoint');
    
    % Find the vector that points to the mouse cursor (we account for the
    % aspect ratio of the plot window)
    x = (mouseLocation - handle_plot.windowCenter)';
    x(1) = x(1) / handle_plot.windowLocation(3);
    x(2) = x(2) / handle_plot.windowLocation(4);
    
    % Normalize the vector
    x = x / norm(x, p);
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Find the linearly transformed vector
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    y = A*x;
    
    norm_y = norm(y, p);
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Update the current maximum norm
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    if (norm_y >= field_norm - 5e-5)
        field_norm = norm_y;
        
        % Display the value to the user
        set(handle_field_norm, 'String', sprintf('%.4f', field_norm));
        
        % Display the maximizing vectors
        set(handle_plot.x(1).special, 'XData', x(1), 'YData', x(2), 'Visible', 'on');
        set(handle_plot.x(2).special, 'XData', y(1), 'YData', y(2), 'Visible', 'on');
    end
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Do some bookkeeping
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Add vectors x and y to the lists
    addpoints(handle_plot.x(1).all, x(1), x(2));
    addpoints(handle_plot.x(2).all, y(1), y(2));
    
    % Update the lines representing the vectors x and y
    set(handle_plot.x(1).current, 'XData', [0 x(1)], 'YData', [0 x(2)]);
    set(handle_plot.x(2).current, 'XData', [0 y(1)], 'YData', [0 y(2)]);
    
    % Update the positions of the labels
    dx = [0.1 * handle_plot.windowSize; 0];
    set(handle_plot.x(1).label, 'Position', 1.1*x + sign(x(1))*dx, 'Visible', 'on');
    set(handle_plot.x(2).label, 'Position', 1.1*y + sign(y(1))*dx, 'Visible', 'on');
    
    
    %----------------------------------------------------------------------
    %  Allow the user to trace the vector x continuously
    %----------------------------------------------------------------------
    set(handle_gui, 'WindowButtonMotionFcn', @startDrawing);
end


%--------------------------------------------------------------------------
% -------------------------------------------------------------------------
%   Call this routine to stop tracing the vector x
% -------------------------------------------------------------------------
%--------------------------------------------------------------------------
function stopDrawing(~, ~)
    global handle_gui;
    
    set(handle_gui, 'WindowButtonMotionFcn', '');
end