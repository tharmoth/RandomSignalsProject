function [morseText] = morse(string)
 
%% Translate AlphaNumeric Text to Morse Text  (Still may need adjustments to spaces to reduce confusion between other spaces)
 % types of spaces: - after each element(dot and dash)(included in dot and
 %                  dash generating functions)
 %                  - after each letter (the space function)
 %                  - after each word (the first character in the morse
 %                  dictionary)
    string = double(lower(string));
    
%Defined such that the ascii code of the characters in the string map
%to the indecies of the dictionary. (important in the next step)2
morseDictionary = {{' ',word_space},{'',''},{'',''},{'',''},...
                   {'',''},{'',''},{'',''},{'',''},{'',''},{'',''},...
                   {'',''},{'',''},{'',''},{'',''},{'',''},{'',''},...
                   {'0',[dash dash dash dash dash]},...
                   {'1',[dot dash dash dash dash]},...
                   {'2',[dot dot dash dash dash]},...
                   {'3',[dot dot dot dash dash]},...
                   {'4',[dot dot dot dot dash]},...
                   {'5',[dot dot dot dot dot]},...
                   {'6',[dash dot dot dot dot]},...
                   {'7',[dash dash dot dot dot]},...
                   {'8',[dash dash dash dot dot]},...
                   {'9',[dash dash dash dash dot]},...
                   {'',''},{'',''},{'',''},{'',''},{'',''},{'',''},...
                   {'',''},{'',''},{'',''},{'',''},{'',''},{'',''},...
                   {'',''},{'',''},{'',''},{'',''},{'',''},{'',''},...
                   {'',''},{'',''},{'',''},{'',''},{'',''},{'',''},...
                   {'',''},{'',''},{'',''},{'',''},{'',''},{'',''},...
                   {'',''},{'',''},{'',''},{'',''},{'',''},{'',''},...
                   {'',''},{'',''},{'',''},...
                   {'a',[dot dash]},...
                   {'b',[dash dot dot dot]},...
                   {'c',[dash dot dash dot]},...
                   {'d',[dash dot dot]},...
                   {'e',[dot]},...
                   {'f',[dot dot dash dot]},...
                   {'g',[dash dash dot]},...
                   {'h',[dot dot dot dot]},...
                   {'i',[dot dot]},...
                   {'j',[dot dash dash dash]},...
                   {'k',[dash dot dash]},...
                   {'l',[dot dash dot dot]},...
                   {'m',[dash dash]},...
                   {'n',[dash dot]},...
                   {'o',[dash dash dash]},...
                   {'p',[dot dash dash dot]},...
                   {'q',[dash dash dot dash]},...
                   {'r',[dot dash dot]},...
                   {'s',[dot dot dot]},...
                   {'t',[dash]},...
                   {'u',[dot dot dash]},...
                   {'v',[dot dot dot dash]},...
                   {'w',[dot dash dash]},...
                   {'x',[dash dot dot dash]},...
                   {'y',[dash dot dash dash]},...
                   {'z',[dash dash dot dot]}};
 
    %Iterates through each letter in the string and converts it to morse
    %code and inserts the results into a new array, also adds a space after
    %each letter(see the below functions)
    morseText = arrayfun(@(x)[morseDictionary{x}{2} letter_space], (string - 31), 'UniformOutput', false);
 
    %The output of the previous operation is a cell array, we want it to be
    %a string.
    morseText = cell2mat(morseText);
    
      %Takes morseText and creates an image representation of the encoded string.  
      x = morseText;
    
        morseText = awgn(morseText, 1, 'measured');
%      morseText = morseText * (9/10) + randn(1, length(morseText)) * (1/10);
% for k=1:length(x)
%   x0=k;
%   y0=0;
%   x1=x0+1;
%   y1=1;
%   rectangle('Position',[x0 y0 x1 y1],'FaceColor',x(k)*[1 1 1],'EdgeColor','k');
%   hold on;
% end
% xlim([1 x1])
end

%generates dots
function dot = dot
    on = ones(1, unit+error_offset);
    off = zeros(1,unit+error_offset);
    dot = [on off];
end

%generates dashes
function dash = dash
    on = ones(1,3*unit+error_offset);
    off = zeros(1,unit+error_offset);
    dash = [on off];
end

%for inter-letter spaces, inter element spaces are included in the 2 above
%functions. word spaces are included in the morse dictionary in the first
%element.
function word_space = word_space
    word_space = zeros(1,2*unit+error_offset); 
end

%for inter-letter spaces, inter element spaces are included in the 2 above
%functions. word spaces are included in the morse dictionary in the first
%element.
function letter_space = letter_space
    letter_space = zeros(1,2*unit+error_offset); 
end


function error_offset = error_offset
    percentage = 0;
    unit = 100;
    error_offset = round(percentage/2*(rand*2-1)*unit);
end


function unit = unit
    unit = 100;
end