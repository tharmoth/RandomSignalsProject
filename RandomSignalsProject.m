clc; clear; clf; format compact; clear sound;

unit = 100;

% Calculate a dots vector
on = ones(1,unit);
off = zeros(1,1*unit);
dots = [off on off];
dot = dots;

% Calculate a dash vector
on = ones(1,3*unit);
off = zeros(1,.5*unit);
dash = [off on off];

% Calculate a word space vector
on = ones(1,.5*unit);
word_space = zeros(1,7*unit); 
word_space = [on word_space on];

% Calculate a letter space vector
on = ones(1,.2*unit);
letter_space = zeros(1,3*unit); 
letter_space = [on letter_space on];

% Get the converted morse input
string = ' Hello World ';
% string = input("Enter a string to translate: ", 's');
string = append(' ', string)
x_raw = morse(string);
x = x_raw;
soundsc(x_raw, 1000)

% Filter the signal to digital
% x = medfilt1(x, unit);
% x(x < .5) = 0;
% x(x >= .5) = 1;

t_dash = .8;
t_dot = .8;
t_letter = .8;
t_word = .9;

% Dashes
[dash_corro,lags_dash] = xcorr(x, dash);
[na_dash_corro, lags_dash] = xcorr(flip(x), flip(dash));
dash_corro = dash_corro + na_dash_corro;
dash_corro = dash_corro / max(dash_corro);
na_dash_corro = na_dash_corro / max(na_dash_corro);
dash_locatoins = find_peaks(dash_corro, t_dash);

% Dots 
[dot_corro, lags_dot] = xcorr(x, dots);
[na_dot_corro, lags_dot] = xcorr(flip(x), flip(dots));
dot_corro = dot_corro + na_dot_corro;
dot_corro = dot_corro / max(dot_corro);
na_dot_corro = na_dot_corro / max(na_dot_corro);
dot_locations = find_peaks(dot_corro, t_dot);

% Spaces Letter
[space_letter_corro, lags_space] = xcorr(x, letter_space);
[na_space_letter_corro, lags_space] = xcorr(flip(x), flip(letter_space));
space_letter_corro = space_letter_corro + na_space_letter_corro;
space_letter_corro = space_letter_corro / max(space_letter_corro);
na_space_letter_corro = na_space_letter_corro / max(na_space_letter_corro);
space_letter_locations = find_peaks(space_letter_corro, t_letter);

% Spaces Word
[space_word_corro,lags_space] = xcorr(x, word_space);
[na_space_word_corro, lags_space] = xcorr(flip(x), flip(word_space));
space_word_corro = space_word_corro + na_space_word_corro;
space_word_corro = space_word_corro / max(space_word_corro);
na_space_word_corro = na_space_word_corro / max(na_space_word_corro);
space_word_locations = find_peaks(space_word_corro, t_word);

% test = cross_corrolation(x, dash);
% plot(test)
% Plot
figure(1)
sgtitle("Cross Correlation")
subplot(2, 2 , 1); hold on;  xlim([1 length(x)]);
threshold_line = ones(1, length(x))*t_dash; 
xlim([lags_dash(find(dash_corro > .001, 1, 'first')) length(x)]);
ylim([-.3 1.3])
title("Dash Plot")
plot(x_raw);
plot(threshold_line)
plot(lags_dash, dash_corro, 'r');

subplot(2, 2 , 2);  hold on; 
threshold_line = ones(1, length(x))*t_dot; 
xlim([lags_dot(find(dot_corro > .001, 1, 'first')) length(x)]);
ylim([-.3 1.3])
title("Dot Plot")
plot(x_raw)
plot(threshold_line)
plot(lags_dot, dot_corro, 'r')

subplot(2, 2 , 3); hold on;
threshold_line = ones(1, length(x))*t_letter; 
xlim([lags_space(find(space_letter_corro > .001, 1, 'first')) length(x)]);
ylim([-.3 1.3])
title("Letter Space Plot")
plot(x_raw)
plot(threshold_line)
plot(lags_space, space_letter_corro, 'r')

subplot(2, 2 , 4); hold on;
threshold_line = ones(1, length(x))*t_word; 
lags_space(find(space_word_corro > .001, 1, 'first'))
length(x)
xlim([lags_space(find(space_word_corro > .001, 1, 'first')) length(x)]); 
ylim([-.3 1.3])
title("Word Space Plot")
plot(x_raw)
plot(threshold_line)
plot(lags_space, space_word_corro, 'r')



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
    else
        disp("Error two items at same index")
        break
    end
end
num_dots = length(strfind(output_string,'.'));
num_dashes = length(strfind(output_string,'_'));
percent_dots = num_dots / (num_dots + num_dashes) * 100;
percent_dashes = num_dashes / (num_dots + num_dashes) * 100;

output_string = strtrim(output_string);
outputs = strsplit(output_string);

% Convert the output dots and dashes to alphanumeric
% codes = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '0'};
% characters = {'.____', '..___', '...__', '...._', '.....', '_....', '__...', '___..', '____.', '_____'};
codes = {' ','1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L' ,'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
characters = {'-', '.____', '..___', '...__', '...._', '.....', '_....', '__...', '___..', '____.', '_____', '._', '_...', '_._.', '_..', '.', '.._.', '__.', '....', '..', '.___', '_._', '._..', '__', '_.', '___', '.__.', '__._', '._.', '...', '_', '.._', '..._', '.__', '_.._', '_.__', '__..'};
dictionary = containers.Map(characters, codes);
output_letters = "";
for i = outputs
%     i
    if isKey(dictionary, i)
        output_letters = append(output_letters, dictionary(i));
    end
end

disp("Input: " + string)
disp("Output: " + output_letters)
disp("Output Dots Dashes: " + output_string)
disp("Percentage Dashes: " + percent_dashes + "%")
disp("Percentage Dots: " + percent_dots + "%")


function peaks = find_peaks(signal, threshold)
    threshold = threshold * 100000;
    signal = round(signal * 100000);
    peaks = [];
    in_peak = false;
    for i = 2:length(signal)-1
        last = signal(i - 1);
        current = signal(i);
        next = signal(i + 1);
        if current > threshold
            in_peak = true;
        elseif current < threshold && in_peak
            peaks = [peaks, i];
            in_peak = false;
        end
        
       
%         if current > threshold && current > next && current >= last
%             
%         end
    end
end

function result = flip(x)
    x = -1 * x;
    x = x + 1;
    result = x;
end

% function cross = cross_corrolation(x, y)
%     cross = [];
%     y_pad = [y zeros(1, length(x)*2)];
%     for i = 1:length(y)
%        s = 0;
%        for j = 1:length(x)
%            x(j);
%            y_pad(j + i);
%            s = s + x(j) * y_pad(j + i);
%        end
%        cross = [cross, s];
%     end
% end





