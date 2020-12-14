clc; clear; clf; format compact; clear sound; clear all; close all;

p = 2
% Print SNR graph
if p == 0
    figure(1)
    subplot(2, 2, 1)
    x_raw = morse(' Hello ', 10000000, 0);
    plot(x_raw)
    title('No noise')
    ylim([-2 3])
    xlim([0 length(x_raw)]);
    xlabel('Time')
    ylabel('Intensity')

    subplot(2, 2, 2)
    x_raw = morse(' Hello ', 100, 0);
    plot(x_raw)
    title('100:1 SNR')
    ylim([-2 3])
    xlim([0 length(x_raw)]);
    xlabel('Time')
    ylabel('Intensity')

    subplot(2, 2, 3)
    x_raw = morse(' Hello ', 10, 0);
    plot(x_raw)
    title('10:1 SNR')
    ylim([-2 3])
    xlim([0 length(x_raw)]);
    xlabel('Time')
    ylabel('Intensity')

    subplot(2, 2, 4)
    x_raw = morse(' Hello ', 1, 0);
    plot(x_raw)
    title('1:1 SNR')
    ylim([-2 3])
    xlim([0 length(x_raw)]);
    xlabel('Time')
    ylabel('Intensity')
end

if p == 1
    % Get the converted morse input
    A = importdata('test_text.txt');
    string = char(A{1});
    string = 'THIS IS A LONGER TEST';
    disp(length(string))
    string = append(' ', string);
    x_raw = morse(string, 100000000, 0);
    % soundsc(x_raw, 1000)
    [decoded_string, output_morse] = correlation_decoder(x_raw, false);
    disp("Input: " + string)
    disp("Output: " + decoded_string)
    disp("Output Dots Dashes: " + output_morse)
    
    unit_var = 1:-.1:0;
    snr_rates = 2:-.1:0;
    distance =  zeros(length(unit_var), length(snr_rates));
    iterations = 1;
    for j = 1:iterations
        for unit = 1:length(unit_var)
            for snr = 1:length(snr_rates)
                x_raw = morse(string, snr_rates(snr), unit_var(unit));
                [decoded_string, output_morse] = correlation_decoder(x_raw, false);
                d = editDistance(string, decoded_string) - 1;
                distance(unit, snr) = distance(unit, snr) + d / iterations;
            end
        end
    end
    figure(1)
    surf(snr_rates, unit_var, distance)
    title('Errors as SNR and Unit Length Variance change')
    xlabel('SNR')
    ylabel('Unit Length Variance')
    zlabel('Number of Errors')
    
    distance = distance ./ (length(string));
    figure(2)
    imshow(distance, 'InitialMagnification', 4000, 'XData', snr_rates, 'YData', unit_var);
    h = gca;
    h.Visible = 'On';
    title('Errors as SNR and Unit Length Variance change')
    xlabel('Signal to noise ratio ')
    ylabel('Unit length variance')
end

if p == 2
    string = 'THIS IS A LONGER TEST';
    string = append(' ', string);
    x_raw = morse(string, 100000000000, 1);
    [decoded_string, output_morse] = correlation_decoder(x_raw, false);
    disp("Input: " + string)
    disp("Output: " + decoded_string)
    disp("Output Dots Dashes: " + output_morse)
end

if p == 3
        % Get the converted morse input
    A = importdata('test_text.txt');
    string = char(A{1});
%     string = 'THIS IS A LONGER TEST';
    disp(length(string))
    string = append(' ', string);
    x_raw = morse(string, 100000000, 0);
    % soundsc(x_raw, 1000)
    [decoded_string, output_morse] = correlation_decoder(x_raw, false);
    disp("Input: " + string)
    disp("Output: " + decoded_string)
    disp("Output Dots Dashes: " + output_morse)
    
    unit_var = 1:-.1:0;
    
    distance_unit =  zeros(1, length(unit_var));
    iterations = 5;
    for j = 1:iterations
        for unit = 1:length(unit_var)
            x_raw = morse(string, 100000000, unit_var(unit));
            [decoded_string, output_morse] = correlation_decoder(x_raw, false);
            d = editDistance(string, decoded_string) - 1;
            distance_unit(unit) = distance_unit(unit) + d / iterations;
        end
    end
    
    snr_rates = 2:-.1:0;
    distance_snr =  zeros(1, length(snr_rates));
    for j = 1:iterations
        for snr = 1:length(snr_rates)
            x_raw = morse(string, snr_rates(snr), 0);
            [decoded_string, output_morse] = correlation_decoder(x_raw, false);
            d = editDistance(string, decoded_string) - 1;
            distance_snr(snr) = distance_snr(snr) + d / iterations;
        end
    end
    
    figure(1)
    subplot(1, 2, 1)
    plot(snr_rates, distance_snr)
    title('Errors vs Signal to Noise Ratio')
    xlabel('Signal to Noise Ratio')
    ylabel('Number of Errors')
    
    subplot(1, 2, 2)
    plot(unit_var, distance_unit)
    set ( gca, 'xdir', 'reverse' )
    title('Errors vs Unit Length Variance')
    xlabel('Unit Length Variance')
    ylabel('Number of Errors')
    ylim([0, length(string)])
end

if p == 4
    string = 'THIS IS A LONGER TEST';
    string = append(' ', string);
    x_raw = morse(string, 100000000000, 1);
%     soundsc(x_raw)
    plot(x_raw)
%     [decoded_string, output_morse] = correlation_decoder(x_raw, false);
    audiowrite('MorseSignal.wav',x_raw, 44100)
end

if p == 5
    string = 'THIS IS A LONGER TEST';
    x_raw = morse(string, 1, 1);
    [correlation, lags] = xcorr(x_raw, [zeros(1, 10000) x_raw]);
    plot(x_raw); hold on;
    plot(lags, correlation)
end
