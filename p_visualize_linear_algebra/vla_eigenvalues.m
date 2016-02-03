%--------------------------------------------------------------------------
%  Author:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    
%  Summary:
%    
%    This routine handles the visualization of eigenvalues and
%    eigenvectors.
%    
%  Instructions:
%    
%    Please call the main routine, visualize_linear_algebra. Type the
%    following onto Matlab's command window:
%    
%    visualize_linear_algebra
%    
%--------------------------------------------------------------------------
function vla_eigenvalues(~, ~, callerName)
    global matrices;
    global matrixIndex;
    global handle_gui;
    global handle_plot;
    global handle_field_angle;
    global handle_field_eigenvalue;
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Initialize variables
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
	% Reset problem parameters
    if (strcmp(callerName, 'main_menu'))
        matrixIndex = 1;
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
    
    handle_plot.windowLocation = [0.06 0.15 0.46 0.70];
    handle_plot.windowCenter   = [0.06 0.15] + 0.5 * [0.46 0.70];
    handle_plot.windowSize     = 1.25 * max(norm(A, 'inf'), 1);
    
    
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
    title('Click and drag on this plot window!', 'FontSize', 20);
    
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
            'Position'             , [0.55 0.15 0.36 0.70], ...
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
    
    
    % Create the label for the field for angle
    uicontrol('Parent'             , handle_rightPanel, ...
              'Style'              , 'text', ...
              'String'             , 'Angle between x and A*x:', ...
              'Units'              , 'normalized', ...
              'Position'           , [0.02 0.55 0.96 0.08], ...
              'BackgroundColor'    , backgroundColor, ...
              'ForegroundColor'    , foregroundColor, ...
              'FontSize'           , 18, ...
              'FontWeight'         , 'normal', ...
              'HorizontalAlignment', 'left');
    
    % Create the field for angle
    handle_field_angle = ...
    uicontrol('Parent'             , handle_rightPanel, ...
              'Style'              , 'text', ...
              'String'             , 'Make me 0 or 180!', ...
              'Units'              , 'normalized', ...
              'Position'           , [0.02 0.41 0.75 0.08], ...
              'BackgroundColor'    , [0.86 0.84 0.86], ...
              'ForegroundColor'    , [0.50 0.10 0.10], ...
              'FontName'           , 'courier', ...
              'FontSize'           , 17, ...
              'FontWeight'         , 'bold', ...
              'HorizontalAlignment', 'left');
    
    
    % Create the label for the field for eigenvalue
    uicontrol('Parent'             , handle_rightPanel, ...
              'Style'              , 'text', ...
              'String'             , 'Eigenvalue:', ...
              'Units'              , 'normalized', ...
              'Position'           , [0.02 0.20 0.96 0.08], ...
              'BackgroundColor'    , backgroundColor, ...
              'ForegroundColor'    , foregroundColor, ...
              'FontSize'           , 18, ...
              'FontWeight'         , 'normal', ...
              'HorizontalAlignment', 'left');
    
    % Create the field for eigenvalue
    handle_field_eigenvalue = ...
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
    
    vla_eigenvalues([], [], 'me');
end


%--------------------------------------------------------------------------
% -------------------------------------------------------------------------
%   This routine traces the unit vector x and the linearly transformed
%   vector y = A*x. It updates the fields that appear on the GUI.
% -------------------------------------------------------------------------
%--------------------------------------------------------------------------
function startDrawing(source, ~)
    global matrices;
    global matrixIndex;
    global handle_gui;
    global handle_plot;
    global handle_field_angle;
    global handle_field_eigenvalue;
    
    
    % Find the matrix
    A = eval(matrices{matrixIndex});
    
    
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
    
    % Normalize the vector (in 2-norm)
    x = x / norm(x);
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Find the linearly transformed vector
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    y = A*x;
    
    norm_y = norm(y);
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Update the angle between x and y
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    angle = acosd(dot(x, y) / norm_y);
    
    % Display the value to the user
    set(handle_field_angle, 'String', sprintf('%.3f', angle));
    
    if (angle <= 2.5e-1)
        % Display the value to the user
        set(handle_field_eigenvalue, 'String', sprintf('%.3f', norm_y));
        
        % Display the eigenvector and the mapped vector
        set(handle_plot.x(1).special, 'XData', x(1), 'YData', x(2), 'Visible', 'on');
        set(handle_plot.x(2).special, 'XData', y(1), 'YData', y(2), 'Visible', 'on');
        
    elseif (180 - angle <= 2.5e-1)
        % Display the value to the user
        set(handle_field_eigenvalue, 'String', sprintf('%.3f', -norm_y));
        
        % Display the eigenvector and the mapped vector
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