clc; clear; clf; close all; format compact; clear sound;

unit = 100;

% Calculate a dots vector
on = ones(1,unit);
off = zeros(1,unit);
dots = [off on off];
dot = dots;

% Calculate a dash vector
on = ones(1,3*unit);
off = zeros(1,unit);
dash = [off on off];

% Calculate a space vector
word_space = zeros(1,7*unit); 

% Calculate a space vector
letter_space = zeros(1,3*unit); 

% Get the converted morse input
input = ' ab c ';
x = morse(input);
plot(x); hold on
xlim([1 length(x)])
ylim([-1.3 1.3])
% soundsc(x, 1000)
               
% Dashes
[dash_corro,lags_dash] = xcorr(x, dash);
dash_corro = dash_corro / max(dash_corro);
dash_locatoins = find_peaks(dash_corro, .9);

% Dots
[dot_corro,lags_dot] = xcorr(x, dots);
dot_corro = dot_corro / max(dot_corro);
dot_locations = find_peaks(dot_corro, .9);

% Spaces Letter
[space_letter_corro, lags_space] = xcorr(~x, ~letter_space);
space_letter_corro = space_letter_corro / max(space_letter_corro);
space_letter_locations = find_peaks(space_letter_corro, .9);

% Spaces Word
[space_word_corro,lags_space] = xcorr(~x, ~word_space);
space_word_corro = space_word_corro / max(space_word_corro);
space_word_locations = find_peaks(space_word_corro, .9);

% plot(lags_dot, dot_corro)
% plot(lags_dot, dot_corro)
plot(lags_space, space_letter_corro)
% plot(lags_space, space_word_corro)


% Build the output from the locations of dots dashes and spaces
output_string = "";
while ~isempty(dot_locations) || ~isempty(dash_locatoins) || ~isempty(space_letter_locations) || ~isempty(space_word_locations)
    if ~isempty(dot_locations)
       min_dot = dot_locations(1);
    else
       min_dot = Inf;
    end
    
    if ~isempty(dash_locatoins)
       min_dash = dash_locatoins(1);
    else
       min_dash = Inf;
    end
    
    if ~isempty(space_letter_locations)
       min_space = space_letter_locations(1);
    else
       min_space = Inf;
    end
    
    if ~isempty(space_word_locations)
       min_space_word = space_word_locations(1);
    else
       min_space_word = Inf;
    end
    
    if min_dot < min_dash && min_dot < min_space && min_dot < min_space_word
        dot_locations = dot_locations(2:length(dot_locations));
        output_string = append(output_string, ".");
    elseif min_dash < min_dot && min_dash < min_space && min_dash < min_space_word
        dash_locatoins = dash_locatoins(2:length(dash_locatoins));
        output_string = append(output_string, "_");
    elseif min_space < min_dot && min_space < min_dash && min_space < min_space_word
        space_letter_locations = space_letter_locations(2:length(space_letter_locations));
        output_string = append(output_string, " ");
    elseif ~isempty(space_word_locations)
        space_word_locations = space_word_locations(2:length(space_word_locations));
        output_string = append(output_string, " - ");
    end
end
output_string = strtrim(output_string)
outputs = strsplit(output_string)

% Convert the output dots and dashes to alphanumeric
% codes = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '0'};
% characters = {'.____', '..___', '...__', '...._', '.....', '_....', '__...', '___..', '____.', '_____'};
codes = {' ','1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l' ,'m', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};
characters = {'-', '.____', '..___', '...__', '...._', '.....', '_....', '__...', '___..', '____.', '_____', '._', '_...', '_._.', '_..', '.', '.._.', '__.', '....', '..', '.___', '_._', '._..', '__', '_.', '___', '.__.', '__._', '._.', '...', '_', '.._', '..._', '.__', '_.._', '_.__', '__..'};
dictionary = containers.Map(characters, codes);
output_letters = "";
for i = outputs
    i
    output_letters = append(output_letters, dictionary(i));
end

disp("Input:" + input)
disp("Output Dots Dashes: " + output_string)
disp("Output:" + output_letters)


function peaks = find_peaks(signal, threshold)
    threshold = threshold * 100000;
    signal = round(signal * 100000);
    peaks = [];
    for i = 2:length(signal)-1
        last = signal(i - 1);
        current = signal(i);
        next = signal(i + 1);
        if current > threshold && current > next && current > last
            peaks = [peaks, i];
        end
    end
end



