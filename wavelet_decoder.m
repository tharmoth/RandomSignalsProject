function [output_string] = wavelet_decoder(morseText, should_plot)
    % morsearray = morse(' test message ', 10, 0);
    % morseText = morsearray;
    % morseText = awgn(morsearray, 100,'measured');

    %morseText = morseText * (9/10) + randn(1, length(morseText)) * (1/10);
    if should_plot
        figure (1)
        subplot(2,2,1)
        plot(morseText);
        hold on
        plot(morsearray);
    end

    smoothed = smoothdata(morseText,'gaussian',3);


    %x(x < 0) = 0

    %% edge detection

    edgedet = conv([-1/2 1/2], morseText);
    edgedetsmooth = conv([-1/2 1/2], smoothed);

    if should_plot
        subplot(2,2,2)
        plot(smoothed);
        title('3pt Moving Avg')

        subplot(2,2,3)
        plot(edgedet);
        title('conv');

        subplot(2,2,4)
        plot(edgedetsmooth);
        title('conv smooth');
    end

    for n = 1:length(edgedet)
        if edgedet(n) < 0
            edgedet(n) = edgedet(n)*(-1);
        else
           edgedet(n) = edgedet(n);
        end
    end

    [pksnoiseedge, locsnoiseedge] = findpeaks(edgedet,'MinPeakHeight',0.3);

    %subplot(2,2,4)
    %plot(conv([1 -1], smoothed));
    %title('conv smoothed');
    %% wavelets
    if should_plot
        figure (2)
        cwtbase = cwt(morseText,1:10,'haar','plot');
        figure (3)
        cwtsmooth = cwt(smoothed,1:10,'haar','plot');
        title('Smoothed')
    else
        cwtbase = cwt(morseText,1:10,'haar');
        cwtsmooth = cwt(smoothed,1:10,'haar');
    end
    if should_plot
        figure (4)
        plot(cwtbase(4,:));
        title('CWT 4')
    end
    %mat2gray(morseText) plot(abs(fftshift(fft(morseText))))

    %makes pic of image with noise
    morsepic = zeros(1,length(morseText));
    for n = 1:10
        morsepic(n,:) = morseText;
    end

    if should_plot
        figure(5)
        imshow(mat2gray(morsepic));
    end

    smoothpic = zeros(1,length(smoothed));
    for n = 1:10
        smoothpic(n,:) = smoothed;
    end

    if should_plot
        figure(6)
        imshow(mat2gray(smoothpic));
    end

    %finds peaks above a certain threshold from cwt l3
    [pksnoise,locsnoise] = findpeaks(cwtbase(4,:),'MinPeakHeight',0.5);

    [npksnoise,nlocsnoise] = findpeaks((-1.*cwtbase(4,:)),'MinPeakHeight',0.5);

    nedges = sort([nlocsnoise locsnoise]);

    string = [];
    for n = 1:length(nedges)-1
        if mod(n,2) == 1
            if nedges(n+1)-nedges(n) < 4
                string = [string 1];
            else
                string = [string 2];
            end
        else 
            if nedges(n+1)-nedges(n) < 4
                string = string;
            elseif nedges(n+1)-nedges(n) > 10
                string = [string 3];
                string = [string 3];
            else
                string = [string 3];
            end
        end
    end

    string = [string 3];

    n=1;
    output = '';
    while n <= length(string)
        if string(n) == 1  
            if string(n+1) == 3 %.
                output = [output 'e'];
                n=n+2;
            elseif string(n+1) == 1  
                if string(n+2) == 3 %..
                    output = [output 'i'];
                    n=n+3;
                elseif string(n+2) == 1
                    if string(n+3) == 3 %...
                        output = [output 's'];
                        n=n+4;
                    elseif string(n+3) == 1 %....
                        output = [output 'h'];
                        n=n+5;
                    else                    %...-
                        output = [output 'v'];
                        n=n+5;
                    end
                else
                    if string(n+3) == 3 %..-
                        output = [output 'u'];
                        n=n+4;
                    else                    %..-.
                        output = [output 'f'];
                        n=n+5;
                    end
                end
            else
                if string(n+2) ==3 %.-
                    output = [output 'a'];
                    n=n+3;
                elseif string(n+2) == 1
                    if string(n+3) == 3
                        output = [output 'r'];
                        n=n+4;
                    else
                        output = [output 'l'];
                        n=n+5;
                    end
                else
                    if string(n+3) == 3
                        output = [output 'w'];
                        n=n+4;
                    elseif string(n+3) == 1
                        output = [output 'p'];
                        n=n+5;
                    else
                        output = [output 'j'];
                        n=n+5;
                    end
                end
            end
        elseif string(n) == 2
            if string(n+1) == 3
                output = [output 't'];
                n=n+2;
            elseif string(n+1) == 1
                if string(n+2) == 3
                    output = [output 'n'];
                    n=n+3;
                elseif string(n+2) == 1
                    if string(n+3) == 3
                        output = [output 'd'];
                        n=n+4;
                    elseif string(n+3) == 1
                        output = [output 'b'];
                        n=n+5;
                    else
                        output = [output 'x'];
                        n=n+5;
                    end
                else
                    if string(n+3) == 3
                        output = [output 'k'];
                        n=n+4;
                    elseif string(n+3) == 1
                        output = [output 'c'];
                        n=n+5;
                    else
                        output = [output 'y'];
                        n=n+5;
                    end
                end
            else
                if string(n+2) == 3
                    output = [output 'm'];
                    n=n+3;
                elseif string(n+2) == 1
                    if string(n+3) == 3
                        output = [output 'g'];
                        n=n+4;
                    elseif string(n+3) == 1
                        output = [output 'z'];
                        n=n+5;
                    else
                        output = [output 'q'];
                        n=n+5;
                    end
                else
                    output = [output 'o'];
                    n=n+4;
                end
            end
        else
            output = [output ' '];
            n=n+1;
        end
    end
    
output_string = upper(output);
end

