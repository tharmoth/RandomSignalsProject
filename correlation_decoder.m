function [output_string, output_morse] = correlation_decoder(signal, should_plot)
    global unit_num
    unit = unit_num;

    % Calculate a dots vector
    on = ones(1,unit);
    off = zeros(1,1*unit);
    dots = [off on off];

    % Calculate a dash vector
    on = ones(1,3*unit);
    off = zeros(1,.5*unit);
    dash = [off on off];

    % Calculate a word space vector
    on = ones(1,.5*unit);
    word_space = zeros(1,7*unit); 
    word_space = [on word_space on];

    % Calculate a letter space vector
%     on = ones(1,.2*unit);
    on = ones(1,.5*unit);
    letter_space = zeros(1,3*unit); 
    letter_space = [on letter_space on];

    t_dash = .75;
    t_dot = .8;
    t_letter = .8;
    t_word = .9;

    % Dashes
    [dash_corro, lags_dash, dash_locatoins] = detect(signal, dash, t_dash);
    [dot_corro, lags_dot, dot_locations] = detect(signal, dots, t_dot);
    [space_letter_corro, lags_space_letter, space_letter_locations] = detect(signal, letter_space, t_letter);
    [space_word_corro, lags_space, space_word_locations] = detect(signal, word_space, t_word);

    if should_plot
        figure(1); clf;
        sgtitle("Cross Correlation")
        subplot(2, 2 , 1); hold on;
        threshold_line = ones(1, length(signal))*t_dash; 
        xlim([lags_dash(find(dash_corro > .001, 1, 'first')) length(signal)]);
        ylim([-.3 1.3])
        title("Dash Plot")
        plot(signal);
        plot(threshold_line)
        plot(lags_dash, dash_corro, 'r');

        subplot(2, 2 , 2);  hold on; 
        threshold_line = ones(1, length(signal))*t_dot; 
        xlim([lags_dot(find(dot_corro > .001, 1, 'first')) length(signal)]);
        ylim([-.3 1.3])
        title("Dot Plot")
        plot(signal)
        plot(threshold_line)
        plot(lags_dot, dot_corro, 'r')

        subplot(2, 2 , 3); hold on;
        threshold_line = ones(1, length(signal))*t_letter; 
        xlim([lags_space(find(space_letter_corro > .001, 1, 'first')) length(signal)]);
        ylim([-.3 1.3])
        title("Letter Space Plot")
        plot(signal)
        plot(threshold_line)
        plot(lags_space_letter, space_letter_corro, 'r')

        subplot(2, 2 , 4); hold on;
        threshold_line = ones(1, length(signal))*t_word; 
        xlim([lags_space(find(space_word_corro > .001, 1, 'first')) length(signal)]); 
        ylim([-.3 1.3])
        title("Word Space Plot")
        plot(signal)
        plot(threshold_line)
        plot(lags_space, space_word_corro, 'r')
    end
    
    % Build the output from the locations of dots dashes and spaces
    output_morse = "";
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
            output_morse = append(output_morse, ".");
        elseif min_dash < min_dot && min_dash < min_space && min_dash < min_space_word
            dash_locatoins = dash_locatoins(2:length(dash_locatoins));
            output_morse = append(output_morse, "_");
        elseif min_space < min_dot && min_space < min_dash && min_space < min_space_word
            space_letter_locations = space_letter_locations(2:length(space_letter_locations));
            output_morse = append(output_morse, " ");
        elseif ~isempty(space_word_locations)
            space_word_locations = space_word_locations(2:length(space_word_locations));
            output_morse = append(output_morse, " - ");
        else
            disp("Error two items at same indesignal")
            break
        end
    end
    output_morse = strtrim(output_morse); % Remove trailing and heading spaces
    outputs = strsplit(output_morse); % Break into letters and spaces
    output_morse = strjoin(outputs); % Remove extra spaces
    
    num_dots = length(strfind(output_morse,'.'));
    num_dashes = length(strfind(output_morse,'_'));
    percent_dots = num_dots / (num_dots + num_dashes) * 100;
    percent_dashes = num_dashes / (num_dots + num_dashes) * 100;

    % Convert the output dots and dashes to alphanumeric
    % codes = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '0'};
    % characters = {'.____', '..___', '...__', '...._', '.....', '_....', '__...', '___..', '____.', '_____'};
    codes = {' ','1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L' ,'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
    characters = {'-', '.____', '..___', '...__', '...._', '.....', '_....', '__...', '___..', '____.', '_____', '._', '_...', '_._.', '_..', '.', '.._.', '__.', '....', '..', '.___', '_._', '._..', '__', '_.', '___', '.__.', '__._', '._.', '...', '_', '.._', '..._', '.__', '_.._', '_.__', '__..'};
    dictionary = containers.Map(characters, codes);
    output_string = "";
    for i = outputs
        if isKey(dictionary, i)
            output_string = append(output_string, dictionary(i));
        end
    end
end

function peaks = find_peaks(signal, threshold)
    threshold = threshold * 100000;
    signal = round(signal * 100000);
    peaks = [];
    in_peak = false;
    peak_start = 0;
    global unit_num
    min_peak_size = round(unit_num / 20);
    for i = 2:length(signal)-1
        current = signal(i);
        if current > threshold
            if ~in_peak
                peak_start = i;
            end
            in_peak = true;
        elseif current < threshold && in_peak
            if i - peak_start > min_peak_size
                peaks = [peaks, i];
                in_peak = false;
            else
                in_peak = false;
            end
        end
    end
end

function result = flip(signal)
    signal = -1 * signal;
    signal = signal + 1;
    result = signal;
end

function [correlation, lags, peaks]  = detect(signal, signal_2, threshold)
    [correlation, lags] = xcorr(signal, signal_2);
    [flip_correlation, ~] = xcorr(flip(signal), flip(signal_2));
    correlation = correlation + flip_correlation;
    correlation = correlation / max(correlation);
    peaks = find_peaks(correlation, threshold);
end

function plot_correlation(signal_1, signal_2, lags, threshold, subplot_num, plot_title)
    subplot(2, 2, subplot_num);  hold on; 
    threshold_line = ones(1, length(signal_1))*threshold; 
    xlim([lags(find(signal_2 > .001, 1, 'first')) length(signal_1)]);
    ylim([-.3 1.3])
    title(plot_title)
    plot(signal_1)
    plot(threshold_line)
    plot(lags, signal_2, 'r')
end

% function cross = cross_corrolation(signal, y)
%     cross = [];
%     y_pad = [y zeros(1, length(signal)*2)];
%     for i = 1:length(y)
%        s = 0;
%        for j = 1:length(signal)
%            signal(j);
%            y_pad(j + i);
%            s = s + signal(j) * y_pad(j + i);
%        end
%        cross = [cross, s];
%     end
% end

