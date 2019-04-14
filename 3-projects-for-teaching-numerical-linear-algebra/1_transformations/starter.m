%--------------------------------------------------------------------------
%  Author: Isaac J. Lee
%  
%  This routine demonstrates the use of linear and affine transformations
%  in graphics.
%  
%  You will need to add/edit/delete some code to run this program. These
%  parts are indicated by a comment beginning with the word "PROBLEM."
%  
%  To run this program, type in:
%      starter()
%--------------------------------------------------------------------------
function starter()
    clc; clf;
    xmin = -2; xmax = 7;
    ymin = -2; ymax = 7;
    
    % Coordinates for the house
    House = [0.0 4.0 4.0 3.4 3.4 3.5 3.5 2.7 2.7 2.8 2.8 2.0 0.0 0.0;
             0.0 0.0 3.0 3.6 4.5 4.5 4.7 4.7 4.5 4.5 4.2 5.0 3.0 0.0];
    
    % Homogeneous coordinates for the house
    House_H = [House; ones(1, size(House, 2))];
    
    
    % ---------------------------------------------------------------------
    %  This part demonstrates the rotation of an object.
    % ---------------------------------------------------------------------
    subplot(2, 2, 1);
    title('Rotation');
    axis([xmin xmax ymin ymax]);
    grid on; axis square;
    line([xmin xmax], [0 0], 'Color', 'k', 'LineWidth', 2);
    line([0 0], [ymin ymax], 'Color', 'k', 'LineWidth', 2);
    
    % PROBLEM 1c: Enter the components of the rotation matrix here.
    M1 = [0 0;
          0 0];
    % END PROBLEM
    
    HouseRotated = M1 * House;
    line(House(1, :), House(2, :), 'Color', 'b', 'LineWidth', 3);
    line(HouseRotated(1, :), HouseRotated(2, :), 'Color', 'r', 'LineWidth', 3);
    
    
    % ---------------------------------------------------------------------
    %  This part demonstrates the scaling of an object.
    % ---------------------------------------------------------------------
    subplot(2, 2, 2);
    title('Scaling');
    axis([xmin xmax ymin ymax]);
    grid on; axis square;
    line([xmin xmax], [0 0], 'Color', 'k', 'LineWidth', 2);
    line([0 0], [ymin ymax], 'Color', 'k', 'LineWidth', 2);
    
    % PROBLEM 1c: Enter the components of the scaling matrix here.
    M2 = [0 0;
          0 0];
    % END PROBLEM
    
    HouseScaled = M2 * House;
    line(House(1, :), House(2, :), 'Color', 'b', 'LineWidth', 3);
    line(HouseScaled(1, :), HouseScaled(2, :), 'Color', 'r', 'LineWidth', 3);
    
    
    % ---------------------------------------------------------------------
    %  This part demonstrates the shearing of an object.
    % ---------------------------------------------------------------------
    subplot(2, 2, 3);
    title('Shearing');
    axis([xmin xmax ymin ymax]);
    grid on; axis square;
    line([xmin xmax], [0 0], 'Color', 'k', 'LineWidth', 2);
    line([0 0], [ymin ymax], 'Color', 'k', 'LineWidth', 2);
    
    % PROBLEM 1c: the components of the shearing matrix here.
    M3 = [0 0;
          0 0];
    % END PROBLEM
    
    HouseSheared = M3 * House;
    line(House(1, :), House(2, :), 'Color', 'b', 'LineWidth', 3);
    line(HouseSheared(1, :), HouseSheared(2, :), 'Color', 'r', 'LineWidth', 3);
    
    
    % ---------------------------------------------------------------------
    %  This part demonstrates the translation of an object.
    % ---------------------------------------------------------------------
    subplot(2, 2, 4);
    title('Translation');
    axis([xmin xmax ymin ymax]);
    grid on; axis square;
    line([xmin xmax], [0 0], 'Color', 'k', 'LineWidth', 2);
    line([0 0], [ymin ymax], 'Color', 'k', 'LineWidth', 2);
    
    % PROBLEM 2c: Enter the components of the translation matrix here.
    M4 = [0 0 0;
          0 0 0;
          0 0 0];
    % END PROBLEM
    
    HouseTranslated = M4 * House_H;
    line(House(1, :), House(2, :), 'Color', 'b', 'LineWidth', 3);
    line(HouseTranslated(1, :), HouseTranslated(2, :), 'Color', 'r', 'LineWidth', 3);
end