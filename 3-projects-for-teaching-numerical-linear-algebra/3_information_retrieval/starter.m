%--------------------------------------------------------------------------
%  Author: Isaac J. Lee
%  
%  This routine demonstrates the use of QR in information retrieval.
%  
%  You will need to add/edit/delete some code to run this program. These
%  parts are indicated by a comment beginning with the word "PROBLEM."
%  
%  To run this program, type in:
%      starter(query)
%  where
%      query is a string (needs to be enclosed by single quotation marks)
%      that indicates what terms to search for. It is case-insensitive.
%--------------------------------------------------------------------------
function starter(query)
    clc;
    
    
    % ---------------------------------------------------------------------
    %  Read terms and documents
    % ---------------------------------------------------------------------
    % Number of terms, number of documents
    t = 30; d = 25;
    % Term-by-document matrix
    A = zeros(t, d);
    % Query vector
    x = zeros(t, 1);
    % Acceptance tolerance
    tolerance = 0.5;
    
    % books.txt needs to be in the same directory as this file
    booksFileID = fopen('books.txt');
    books = textscan(booksFileID, '%s', d, 'delimiter', '\n');
    
    for j = 1 : d
        % Read in the book's title
        str = books{1}(j, 1);
        % The number of words in a title is one more than the number of
        % whitespaces that occur in the title
        numWords = size(strfind(char(str), ' '), 2) + 1;
        % Tokenize the title and assign the entries of a_{j} accordingly
        for i = 1 : numWords
            [token, remain] = strtok(str, ' ');
            index = lookUp(token);
            
            if (index ~= -1)
                A(index, j) = 1;
            end
            
            str = remain;
        end
    end
    
    [Q, R] = qr(A);
    r = rank(A);
    
    
    % ---------------------------------------------------------------------
    %  Encode the query as a term vector x
    % ---------------------------------------------------------------------
    numWords = size(strfind(query, ' '), 2) + 1;
    for i = 1 : numWords
    	[token, remain] = strtok(query, ' ');
        index = lookUp(token);
        
        if (index ~= -1)
        	x(index) = 1;
        end
        
        query = remain;
    end
    
    
    % ---------------------------------------------------------------------
    %  Return matches using formula (1-1)
    % ---------------------------------------------------------------------
    fprintf('Using formula (1-1): A\n');
    
    for j = 1 : d
        cosTheta = A(:, j)' * x / (norm(A(:, j)) * norm(x));
        
        if (cosTheta > tolerance)
            fprintf('%2.2f%%, %s\n', cosTheta*100, char(books{1}(j, 1)));
        end
    end
    
    
    % ---------------------------------------------------------------------
    %  Return matches using formula (1-2) (gives the same results as (1-1))
    % ---------------------------------------------------------------------
    %{
    fprintf('\nUsing formula (1-2): QR of A\n');
    
    for j = 1 : d
        cosTheta = R(1:r, j)' * (Q(:, 1:r)' * x) / (norm(R(1:r, j)) * norm(x));
        
        if (cosTheta > tolerance)
            fprintf('%2.2f%%, %s\n', cosTheta*100, char(books{1}(j, 1)));
        end
    end
    %}
    
    
    % ---------------------------------------------------------------------
    %  Return matches using formula (1-3) (gives the same results as (1-1))
    % ---------------------------------------------------------------------    
    %{
    fprintf('\nUsing formula (1-3): QR of A + orthogonal projection\n');
    
    for j = 1 : d
        x_A = Q(:, 1:r) * Q(:, 1:r)' * x;
        cosThetaNew = A(:, j)' * x_A / (norm(A(:, j)) * norm(x));
        
        if (cosThetaNew > tolerance)
            fprintf('%2.2f%%, %s\n', cosThetaNew*100, char(books{1}(j, 1)));
        end
    end
    %}
    
    
    % ---------------------------------------------------------------------
    %  Return matches using formula (2) (higher recall)
    % ---------------------------------------------------------------------    
    fprintf('\nUsing formula (2): A + new cosine measure\n');
    
    % Orthogonal projection of x onto the column space of Q_A
	x_A = Q(:, 1:r) * Q(:, 1:r)' * x;
    
    % PROBLEM 1d: Return all matches to the query using formula (2)
    
    % END PROBLEM
    
    
    % ---------------------------------------------------------------------
    %  Return matches using formula (3-2)
    % ---------------------------------------------------------------------    
    fprintf('\nUsing formula (3-2): QR of (A + E)\n');
    
    % New rank k (k < r)
    k = r - 5;
    % Zero out R_BR. The resulting R is the matrix we would get from
    % the QR factorization of A + E.
    R((k + 1):t, (k + 1):d) = zeros(t - k, d - k);
    
    % PROBLEM 1f: Return all matches to the query using formula (3-2)
    
    % END PROBLEM
    
    
    % ---------------------------------------------------------------------
    %  Return matches using formula (4)
    % ---------------------------------------------------------------------    
    fprintf('\nUsing formula (4): QR of (A + E) + new cosine measure\n');
    
    % Orthogonal projection of x onto the column space of Q_{A + E}
	x_AplusE = Q(:, 1:k) * Q(:, 1:k)' * x;
    
    % PROBLEM 1f: Return all matches to the query using formula (4)
    
    % END PROBLEM
end

function output = lookUp(str)
    dictionary = {{'acoustics'}
                  {'algebra', 'algebraic'}
                  {'analysis', 'analytic'}
                  {'application', 'applications'}
                  {'chaos'}
                  {'complex'}
                  {'control'}
                  {'differential'}
                  {'distribution'}
                  {'dynamics'}
                  {'economic', 'economics'}
                  {'element', 'elements'}
                  {'engineering'}
                  {'equation', 'equations'}
                  {'finance', 'financial'}
                  {'finite'}
                  {'fluid', 'fluids'}
                  {'geometry'}
                  {'linear'}
                  {'matrix', 'matrices'}
                  {'mechanics', 'mechanical'}
                  {'nonlinear'}
                  {'optimization'}
                  {'partial'}
                  {'real'}
                  {'statistics', 'statistical'}
                  {'stress'}
                  {'structural'}
                  {'theory', 'theoretic', 'theoretical'}
                  {'transform', 'transformations'}
                  };
    numberOfTerms = size(dictionary, 1);
    
    output = -1;
    
    for i = 1 : numberOfTerms
        numberOfSimilarEntries = size(dictionary{i}, 2);
        
        for j = 1 : numberOfSimilarEntries
            if (strcmp(lower(str), dictionary{i}{j}) == true)
                output = i;
                break;
            end
        end
        
        if (output ~= -1)
            break;
        end
    end
end