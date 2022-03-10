%% Introduction to Matlab
% Julian Keil keil@psychologie.uni-kiel.de
%
% This will show you the most basic tools in matlab
% You can type stuff into the command window, you can copy and paste, you
% can mark and run a section or you can run a block of code (the yellow
% highlight). Or you can run the whole script.

%% 0. Good practice Clear all from workspace
clear all
close all
clc

%% 1. Simple Variables
% Matlab is a big calculator
1+1

% You can store the output to a new variable
x = 1+1 % Note the "=" 
% ---Question 1: How is this different from R?

% You can also suppress the output in the command window by ending the line
% with a semicolon ";"
y = 1+1;

% Now you have to use "who" or "whos" to see what's in your working memory
% ---Question 2: What do you see when typing in "who" and "whos". What's the
% differene? What happens if you ask "why"?

% You can also manipulate variables
z = x+y;

% Variables can store multiple types of data, but only one type of data at
% a time

variable = 1;
variable = 'hello'; % Text is defined in ''

% Variables can also store vectors and matrices
variable = [1 2 3 4 5];
% ---Question 3: How do you separate columns and rows? What is the use of ',' and ';'? Build a 2x3 Matrix
% ---Question 4: Can you store text and numbers in one vector?

%% 2. Complex Variables
% Variables can also store different kinds of information in cell arrays
var1{1} = [ 1 2 3 4 5 6 7 ];
var1{2} = 'hello world';
var1{3} = [ 1 3 6 7 4 3 5 6 7 87 76 43 4 5 6 767 ];

% To combine cell arrays, vectors and matrices, we can use data structures.
% Here, fields can contain all kinds of information. This is similar to a
% data frame in R. The different fields a separated by "."
data.text = 'here is some text';
data.number = 1; % Here is a number
data.vector = [1 2 3 4];
data.matrix = [5 7 8; 9 10 11];

% You can also store multiple data structures in one structure. Here, you
% need the same fields in each sub-structure
data(2).text = 'more text';
data(2).number = 2; % Here is a number
data(2).vector = [11 21 31 41];
data(2).matrix = [51 71 81; 91 101 111];
data(2).horst = 'test';

% ---Question 5: How can you access one specific field (e.g. the text of the
% second structure or the thrid value in the first vector)?
% ---Question 6: How does the index of a matrix work? How can I access the
% third value of the second column in the example below? Compare this
% behavor to R. With which values does the index start?
example = rand(10,10);

% You can also access multiple elements at once using ":"
example(1:5,1:2)
% ":" can also be used to build vectors and matrices.
% ---Question 7: How can you build a vector from 1 to 10?
% ---Question 8: How can you build a vector from 1 to 10 in steps of 2?
% ---Question 9: How can you build a vector from 10 to 1?

%% Functions
% + and - and rand etc. are functions
% Functions are multi-purpose scripts that are stored on disc and referenced in the path -> What
% is the Matlab-Path? DO NOT MESS WITH THESE FUNCTIONS! Always check if
% name of function is in use!
% Functions usually take an input and give an output. To learn more about
% functions, you can ask "help functionname". 
mean(x)

% Functions can also use multiple inputs
X = [1 2 3; 3 3 6; 4 6 8; 4 7 7]
mean(X,1)
mean(X,2)

% Functions can also have multiple outputs
[max_value, max_value_index] = max(X(1,:))
% ---Question 10: What does the (1,:) after X indicate? What does the
% output of "max" indicate?

% You can also chain functions
Y = max(randperm(round(rand(1)*10))); % Clicking on the parenthesis will show you the pairs. This can get messy.

%% Loops
% For-Loops can do the same thing over and over again:
clear out 

for i = 1:10
    out(i) = i+1;
end % For i
% Good practice: Use indentation and label the loops

% Loops can also be nested
for i = 1:10
    for j = 11:20
        out(i,j) = i*j;
    end % for j
end % for i

% Important: the same elements can be used as index and variable. But note
% that they will change with each iteration. 
% ---Question 11: Look at "out" what happens at the beginning of the matrix? What can we learn from tis about the behavior of Matlab?

%% Boolean Logic
% We can use <> == & | and combinations of these to check conditions
% ---Question 12: What is the difference between "=" and "==" Why does 4=5
% not work, and what is the output of 4==5?
% ---Question 13: What is the purpose of ~ before a logic statement? What
% is the difference between 4==5 and 4~=5?

% Similar functions exist for different variable types "is..."

%If-Loops can be used to check conditions
if 4 > 5
    disp('this is not good')
end

% If-Loops can be extended by "else" or "elseif" statements
if 4 > 5
    disp('this is not good')
elseif 4 == 5
    disp('this is not better')
else
    disp('this is fine')
end

% Many functions are based on the size of the input data.
length(X) % gives you the longest dimension of an variable
size(X) % gives you all the dimensions, the second input defines the dimension to check
numel(X) % Gives you the number of elements

%% Final Task:
% Build a For-Loop for each element in a vector X = 1:3:100 % Hint:
% "length" is your friend
% In Each iteration, check if the element of X can be divided by 2 and put
% this information into an output variable % Hint: The function "rem" is
% your friend
X = 1:3:100;
clear out
for i = 1:length(X)
    out(i) = rem(X(i),2);
end

for i = 1:length(X)
    if rem(X(i),2) == 0
        out2(i) = 1;
    end
end
%% Some general hints
% Avoid Loops: Each Iteration takes time. The less iterations you have, the
% faster your code. Remember you maths-classes!
clear x y1 y2

x = randi(100,1,10000000);
tic
for i = 1:length(x)
    y1(i) = x(i)/2;
end % for i
toc

tic
y2 = x./2;
toc

% ---Question 14: What does the point do here? What is the difference
% between / and \ ?