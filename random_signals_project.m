clc; clear; clf; format compact; clear sound; clear all; close all;

p = 5;
global unit_num
unit_num = 2;

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

% Run the program to generate a 3d plot at various levels of both SNR and
% ULV
if p == 1
    % Get the converted morse input
    A = importdata('test_text.txt');
    string = char(A{1});
    string = 'THIS IS A LONGER TEST';
    disp(length(string))
    string = append(' ', string);
    x_raw = morse(string, 100000000, 0);
    % soundsc(x_raw, 1000)
    [decoded_string_corr, output_morse] = correlation_decoder(x_raw, false);
    disp("Input: " + string)
    disp("Output: " + decoded_string_corr)
    disp("Output Dots Dashes: " + output_morse)
    
    unit_var = 1:-.1:0;
    snr_rates = 2:-.1:0;
    distance =  zeros(length(unit_var), length(snr_rates));
    iterations = 1;
    for j = 1:iterations
        for unit = 1:length(unit_var)
            for snr = 1:length(snr_rates)
                x_raw = morse(string, snr_rates(snr), unit_var(unit));
                [decoded_string_corr, output_morse] = correlation_decoder(x_raw, false);
                d = editDistance(string, decoded_string_corr) - 1;
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

% Run the program once on a test string
if p == 2
    string = 'THIS IS A LONGER TEST';
    string = append(' ', string);
    x_raw = morse(string, 100000000000, 0);
    [decoded_string_corr, output_morse] = correlation_decoder(x_raw, true);
    disp("Input: " + string)
    disp("Output: " + decoded_string_corr)
    disp("Output Dots Dashes: " + output_morse)
    
    string = 'THIS IS A LONGER TEST ';
    string = append(' ', string);
    x_raw = morse(string, 100000000000, 0);
    [decoded_string_corr] = wavelet_decoder(x_raw, false);
    disp("Input: " + string)
    disp("Output: " + decoded_string_corr)
end

% Generate plots for various levels of both ULV and SNR
if p == 3
    % Get the converted morse input
    A = importdata('test_text.txt');
    string = char(A{1});
%     string = 'THIS IS A LONGER TEST';
    disp(length(string))
    string = append(' ', string);
    x_raw = morse(string, 100000000, 0);
    % soundsc(x_raw, 1000)
    [decoded_string_corr, output_morse] = correlation_decoder(x_raw, false);
    disp("Input: " + string)
    disp("Output: " + decoded_string_corr)
    disp("Output Dots Dashes: " + output_morse)
    
    unit_var = 1:-.1:0;
    
    distance_unit =  zeros(1, length(unit_var));
    iterations = 5;
    for j = 1:iterations
        for unit = 1:length(unit_var)
            x_raw = morse(string, 100000000, unit_var(unit));
            [decoded_string_corr, output_morse] = correlation_decoder(x_raw, false);
            d = editDistance(string, decoded_string_corr) - 1;
            distance_unit(unit) = distance_unit(unit) + d / iterations;
        end
    end
    
    snr_rates = 2:-.1:0;
    distance_snr =  zeros(1, length(snr_rates));
    for j = 1:iterations
        for snr = 1:length(snr_rates)
            x_raw = morse(string, snr_rates(snr), 0);
            [decoded_string_corr, output_morse] = correlation_decoder(x_raw, false);
            d = editDistance(string, decoded_string_corr) - 1;
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

% Save out the waveform for use elsewhere
if p == 4
    string = 'THIS IS A LONGER TEST';
    string = append(' ', string);
    x_raw = morse(string, 100000000000, 1);
%     soundsc(x_raw)
    plot(x_raw)
    audiowrite('MorseSignal.wav',x_raw, 44100)
end

% Compare wavelets to cross correlation
if p == 5    
    % Get the converted morse input
    A = importdata('test_text.txt');
    string = char(A{1});
    string = 'THIS IS A LONGER TEST';
    disp(length(string))
    string = append(' ', string);
    x_raw = morse(string, 100000000, 0);
    % soundsc(x_raw, 1000)
    [decoded_string_corr, output_morse] = correlation_decoder(x_raw, false);
    disp("Input: " + string)
    disp("Output: " + decoded_string_corr)
    disp("Output Dots Dashes: " + output_morse)
    [decoded_string_corr] = wavelet_decoder(x_raw, false);
    disp("Output: " + decoded_string_corr)
    
    unit_var = 1:-.1:0;
    distance_unit_corr =  zeros(1, length(unit_var));
    distance_unit_wave =  zeros(1, length(unit_var));
    iterations = 20;
    for j = 1:iterations
        for unit = 1:length(unit_var)
            unit_num = 50;
            x_raw = morse(string, 100000000, unit_var(unit));
            [decoded_string_corr, ~] = correlation_decoder(x_raw, false);
            d_corr = editDistance(string, decoded_string_corr) - 1;
            distance_unit_corr(unit) = distance_unit_corr(unit) + d_corr / iterations;
            
            unit_num = 2;
            x_raw = morse(string, 100000000, unit_var(unit));
            [decoded_string_wave] = wavelet_decoder(x_raw, false);
            d_wave = editDistance(string, decoded_string_wave) - 1;
            distance_unit_wave(unit) = distance_unit_wave(unit) + d_wave / iterations;
        end
    end
    
    snr_rates = [30:-1:5 5:-.1:0];
    distance_snr_corr =  zeros(1, length(snr_rates));
    distance_snr_wave =  zeros(1, length(snr_rates));
    for j = 1:iterations
        for snr = 1:length(snr_rates)
            unit_num = 50;
            x_raw = morse(string, snr_rates(snr), 0);
            [decoded_string_corr, ~] = correlation_decoder(x_raw, false);
            d_corr = editDistance(string, decoded_string_corr) - 1;
            distance_snr_corr(snr) = distance_snr_corr(snr) + d_corr / iterations;
            
            unit_num = 2;
            x_raw = morse(string, snr_rates(snr), 0);
            [decoded_string_wave] = wavelet_decoder(x_raw, false);
            d_wave = editDistance(string, decoded_string_wave) - 1;
            distance_snr_wave(snr) = distance_snr_wave(snr) + d_wave / iterations;
        end
    end
    
    figure(1); clf;
    subplot(1, 2, 1)
    plot(snr_rates, distance_snr_corr); hold on;
    plot(snr_rates, distance_snr_wave);
    legend('Correlation', 'Wavelet')
    title('Errors vs Signal to Noise Ratio')
    xlabel('Signal to Noise Ratio')
    ylabel('Number of Errors')
    
    subplot(1, 2, 2)
    plot(unit_var, distance_unit_corr); hold on;
    plot(unit_var, distance_unit_wave);
    set ( gca, 'xdir', 'reverse' )
    legend('Correlation', 'Wavelet')
    title('Errors vs Unit Length Variance')
    xlabel('Unit Length Variance')
    ylabel('Number of Errors')
    ylim([0, length(string)])
end
