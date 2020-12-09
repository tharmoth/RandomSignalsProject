%%edge detection

global morsearray


subplot(4,2,1);
morse('this is a test message');
title('Image of Message');



subplot(4,2,2); 
plot(conv([1 -1],morsearray))
title('Conv of [1 -1] with message');


%COEFS = cwt(morsearray,1:10,'haar');
subplot(4,2,3);
COEFS = cwt(morsearray,1:10,'haar','plot');
%wscalogram('image',COEFS);

subplot(4,2,4);
plot(COEFS(2,:));
title('Row 2 of the CWT');

%calcs edges
edges=zeros(1,length(morsearray));
for k = 1:length(morsearray)-1
    edges(k) = morsearray(k)-morsearray(k+1);
    
    
end


%makes edges = 1
for c=1:length(edges)
    if edges(c) == -1
        edges(c)= 1;
    else
        edges(c)=edges(c);
    end
end

% corrects short dots not counting as two edges number of peaks should now
% be = elements*2
for c = 1:length(edges)-1
    if edges(c)+edges(c+1) == 2
        edges=[edges(1,1:c) 0 edges(1,c+1:length(edges))];
    else
        edges(c)=edges(c);
    end
end

subplot(4,2,5);
    plot(edges);
    title('Edges');

%calcs space between edges and plots the number of occurences of various
%lengths of 1s and 0s

[pks,locs] = findpeaks(edges);

%element lengths
element_lengths=zeros(1,length(locs)/2);
for c = 1:length(element_lengths)
    element_lengths(c) = locs(2*c)-locs(2*c-1);
    
end

%hist of element lengths
subplot(4,2,6);
    histogram(element_lengths);
    title('Element Lengths');
    
    
%space lengths
space_lengths=zeros(1,length(element_lengths)-1);    
for c = 1:length(space_lengths)
    space_lengths(c) = locs(2*c+1)-locs(2*c);
    
end    
    
%hist of space lengths
subplot(4,2,7);
    histogram(space_lengths);
    title('Space Lengths');



%signal to dots,dashes, and spaces in order
string = [];
for n = 1:length(locs)-1
    if mod(n,2) == 1
        if locs(n+1)-locs(n) < 4
            string = [string 1];
        else
            string = [string 2];
        end
    else 
        if locs(n+1)-locs(n) < 4
            string = string;
        elseif locs(n+1)-locs(n) > 10
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

%for c = 1:length(edges)
 %   if edges(c)==0
  %      c=c+1
   % elseif edges(c)==-1
    %    while edges(c+1) ~= 1
     %       c=c+1;
      %      stop = c;
            


%dashcoher=[zeros(1,length(morsearray)-4) ones(1,4)];





%cwt(morsearray) imagesc(COEFS) findpeaks(COEFS(4,:))

