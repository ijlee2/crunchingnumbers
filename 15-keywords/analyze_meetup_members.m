%--------------------------------------------------------------------------
%  Author:
%    
%    Isaac J. Lee (crunchingnumbers.live)
%    
%  Summary:
%    
%    This program reads the Meetup files and analyzes which interests are
%    popular among the Meetup members at Central Austin Toastmasters.
%    
%  Instructions:
%    
%    Type the following onto Matlab's command window:
%    
%    analyze_meetup_members()
%    
%--------------------------------------------------------------------------
function analyze_meetup_members()
    clc;
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Initialize the problem
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Set the directory of user files
    directory = './meetup_members/';
    
    % Find all user files
    files    = dir(strcat(directory, '*.txt'));
    numUsers = length(files);
    
    % Save the files' names and sizes
    file_names = strcat(directory, {files.name});
    file_sizes = {files.bytes};
    
    % Weigh the interests?
    are_interests_weighed = false;
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Read the files
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Record the unique interests and their frequencies
    interests = containers.Map('KeyType', 'char', 'ValueType', 'uint32');
    
    % Number of users' interests
    numInterests_byUser = zeros(numUsers, 1);
    
    % Number of users' interests (7 bins: 0, 1-20, 21-40, 41-60, 61-80,
    % 81-100, and over 100 interests)
    bins      = [0, 20, 40, 60, 80, 100, inf];
    bins_name = {'       0', ' 1 -  20', '21 -  40', '41 -  60', ...
                 '61 -  80', '81 - 100', '   > 100'};
    numBins = length(bins);
    
    numInterests_byBins = zeros(numBins, 1);
    
    
    %----------------------------------------------------------------------
    %  Read the i-th user
    %----------------------------------------------------------------------
    for i = 1 : numUsers
        if (file_sizes{i} > 0)
            % Read the user's file
            user_file = string(importdata(file_names{i}));
            
            % Find the user's interests
            user_interests         = cellstr(strsplit(user_file, ', '));
            numInterests_byUser(i) = length(user_interests);
            
            % Find if the user's interests exist in our Map
            interests_found = isKey(interests, user_interests);
            
            
            %--------------------------------------------------------------
            %  Set the frequency of j-th interest
            %--------------------------------------------------------------
            for j = 1 : numInterests_byUser(i)
                if (interests_found(j))
                    % Increment by 1
                    interests(user_interests{j}) = interests(user_interests{j}) + 1;
                    
                    % Weigh the interests that appear in the beginning and
                    % end of the user's list
                    if (are_interests_weighed && numInterests_byUser(i) > 15)
                        % Consider the first and last third in the list
                        % to be more important
                        one_third = floor(numInterests_byUser(i) / 3);
                        
                        if (j <= one_third || j >= numInterests_byUser(i) - one_third + 1)
                            interests(user_interests{j}) = interests(user_interests{j}) + 0.5;
                        end
                    end
                    
                else
                    % Initialize to 1
                    interests(user_interests{j}) = 1;
                    
                end
            end
        end
    end
    
    % Number of unique interests found
    numInterests = length(interests);
    
    
    %----------------------------------------------------------------------
    %  Analyze the number of interests specified
    %----------------------------------------------------------------------
    for i = 1 : numBins
        numInterests_byBins(i) = sum(numInterests_byUser <= bins(i)) ...
                               - sum(numInterests_byBins(1 : (i - 1)));
    end
    
    
    %----------------------------------------------------------------------
    %  Sort the interests according to frequency
    %----------------------------------------------------------------------
    values_sorted = cell2mat(values(interests));
    [values_sorted, permutation] = sort(values_sorted, 'descend');
    
    keys_sorted = keys(interests);
    keys_sorted = keys_sorted(permutation);
    
    
    
    %----------------------------------------------------------------------
    % ---------------------------------------------------------------------
    %   Display the results
    % ---------------------------------------------------------------------
    %----------------------------------------------------------------------
    fprintf('Among %d members, there were %d unique interests.\n\n', numUsers, numInterests);
    
    fprintf('--- Number of interests per member ---\n\n');
    
    for i = 1 : numBins
        fprintf('%s interests: %3d members (%.1f%%)\n', bins_name{i}, numInterests_byBins(i), 100 * numInterests_byBins(i)/numUsers);
    end
    
    fprintf('\n');
    
    fprintf('Median: %.1f interests\n', median(numInterests_byUser));
    fprintf('  Mean: %.1f interests\n', mean(numInterests_byUser));
    fprintf('StdDev: %.1f interests\n\n', std(numInterests_byUser));
    
    fprintf('--- Top 100 interests ---\n\n');
    
    if (are_interests_weighed)
        fprintf('Note: Members'' first and last third of interests were given additional weight.\n\n');
    end
    
    for i = 1 : 100
        fprintf('%3d. %s (%d)\n', i, keys_sorted{i}, values_sorted(i));
    end
    
    fprintf('\n');
end