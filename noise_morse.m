
morse('this is a test message');

morseText = awgn(morsearray, 20,'measured');

%morseText = morseText * (9/10) + randn(1, length(morseText)) * (1/10);
figure (1)
subplot(2,2,1)
plot(morseText);
hold on
plot(morsearray);

smoothed = smoothdata(morseText,'movmedian',3);

subplot(2,2,2)
plot(smoothed);
title('3pt Moving Avg')
%x(x < 0) = 0

subplot(2,2,3)
plot(conv([1 -1], morseText));
title('conv');

%subplot(2,2,4)
%plot(conv([1 -1], smoothed));
%title('conv smoothed');

figure (2)
cwtbase = cwt(morseText,1:10,'haar','plot');
figure (3)
cwtsmooth = cwt(smoothed,1:10,'haar','plot');
title('Smoothed')

figure (4)
plot(cwtbase(4,:));

%mat2gray(morseText) plot(abs(fftshift(fft(morseText))))

%makes pic of image with noise
morsepic = zeros(1,length(morseText));
for n = 1:10
    morsepic(n,:) = morseText;
end

figure(5)
imshow(mat2gray(morsepic));

%finds peaks above a certain threshold from cwt l3
[pksnoise,locsnoise] = findpeaks(cwtbase(4,:),'MinPeakHeight',0.3);

[npksnoise,nlocsnoise] = findpeaks((-1.*cwtbase(4,:)),'MinPeakHeight',0.3);

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

string = [string 3]

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
                output = [output 'o']
                n=n+4;
            end
        end
    else
        output = [output ' '];
        n=n+1;
    end
end

output
