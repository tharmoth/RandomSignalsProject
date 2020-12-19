%% wavelets
clc; clear; clf; format compact; clear sound; clear all; close all;

%subplot(4,2,1);
morsearray = morse(' hello there ', 1000000, 0);
morseText = morsearray;
%title('Image of Message');

%rect wavelet

mother = [1 zeros(1,length(morsearray)-1)];

%generate nth daughter wavelet: a=number of 1s
d1 = [1 mother];
d1(length(d1)) = [];

d2 = [1 d1];
d2(length(d1)) = [];

d3 = [1 d2];
d3(length(d1)) = [];

d4 = [1 d3];
d4(length(d1)) = [];

d5 = [1 d4];
d5(length(d1)) = [];

d6 = [1 d5];
d6(length(d1)) = [];

d7 = [1 d6];
d7(length(d1)) = [];

d8 = [1 d7];
d8(length(d1)) = [];

%%%

data = morseText;

cwtmat=zeros(8,length(data));

for n = 1:8
   if n == 1
      for c = 1:length(data)
       cwtmat(n,c) = sum(data.*circshift(d1,c-1));
      end
   elseif n == 2
       for c = 1:length(data)
         cwtmat(n,c) = sum(data.*circshift(d2,c-1));
       end
   elseif n == 3
       for c = 1:length(data)
         cwtmat(n,c) = sum(data.*circshift(d3,c-1));
       end
   elseif n == 4
       for c = 1:length(data)
         cwtmat(n,c) = sum(data.*circshift(d4,c-1));
       end
   elseif n == 5
       for c = 1:length(data)
         cwtmat(n,c) = sum(data.*circshift(d5,c-1));
       end
   elseif n == 6
       for c = 1:length(data)
         cwtmat(n,c) = sum(data.*circshift(d6,c-1));
       end
   elseif n == 7
       for c = 1:length(data)
         cwtmat(n,c) = sum(data.*circshift(d7,c-1));
       end
   else
       for c = 1:length(data)
         cwtmat(n,c) = sum(data.*circshift(d8,c-1));
       end
   end
end
figure (4)
imagesc(cwtmat);

figure (3)
subplot(2,1,1)
plot(cwtmat(1,:));
title('Row 1')

subplot(2,1,2)
plot(cwtmat(2,:));
title('Row 2')


%row 1 wt
ele = cwtmat(1,:);
ele(ele > 1.5) = 2;
ele(ele < 0.5) = 0;

%[pksrect,locsspace,widths] = findpeaks(cwtmat(4,:),'MinPeakHeight',4);
[pksrect,locsele,widths] = findpeaks(ele,'MinPeakHeight',1);


locsdot = [];
locsdash = [];
for n = 1:length(widths)
    if widths(n) > 4
        locsdash = [locsdash locsele(n)];
        
    else
        locsdot = [locsdot locsele(n)];
    end
end

[pksspace,locsspaces,widths] = findpeaks(((ele-1).*(-1)));

figure (1)
plot(ele)
figure (2)
plot((ele-1).*(-1))

locswordsp = [];
locslettersp = [];
for n = 1:length(widths)
    if widths(n) > 9
        locswordsp = [locswordsp locsspaces(n)];
        
    elseif widths(n) < 3
        locswordsp = locswordsp;
    else
        locslettersp = [locslettersp locsspaces(n)];
    end
end


locsdash(2,:) = 2.*ones(1,length(locsdash));
locsdot(2,:) = ones(1,length(locsdot));
locswordsp(2,:) = 3.*ones(1,length(locswordsp));
locswordsp = [locswordsp locswordsp];
locslettersp(2,:) = 3.*ones(1,length(locslettersp));

enstring = horzcat(locslettersp, locsdot, locsdash, locswordsp);
%sortrows(enstring.',1).';
[~,inx]=sort(enstring(1,:));
enstring = enstring(:,inx);

enstring = [enstring(2,:) 3];


n=1;
output = '';
while n <= length(enstring)
    if enstring(n) == 1  
        if enstring(n+1) == 3 %.
            output = [output 'e'];
            n=n+2;
        elseif enstring(n+1) == 1  
            if enstring(n+2) == 3 %..
                output = [output 'i'];
                n=n+3;
            elseif enstring(n+2) == 1
                if enstring(n+3) == 3 %...
                    output = [output 's'];
                    n=n+4;
                elseif enstring(n+3) == 1 %....
                    output = [output 'h'];
                    n=n+5;
                else                    %...-
                    output = [output 'v'];
                    n=n+5;
                end
            else
                if enstring(n+3) == 3 %..-
                    output = [output 'u'];
                    n=n+4;
                else                    %..-.
                    output = [output 'f'];
                    n=n+5;
                end
            end
        else
            if enstring(n+2) ==3 %.-
                output = [output 'a'];
                n=n+3;
            elseif enstring(n+2) == 1
                if enstring(n+3) == 3
                    output = [output 'r'];
                    n=n+4;
                else
                    output = [output 'l'];
                    n=n+5;
                end
            else
                if enstring(n+3) == 3
                    output = [output 'w'];
                    n=n+4;
                elseif enstring(n+3) == 1
                    output = [output 'p'];
                    n=n+5;
                else
                    output = [output 'j'];
                    n=n+5;
                end
            end
        end
    elseif enstring(n) == 2
        if enstring(n+1) == 3
            output = [output 't'];
            n=n+2;
        elseif enstring(n+1) == 1
            if enstring(n+2) == 3
                output = [output 'n'];
                n=n+3;
            elseif enstring(n+2) == 1
                if enstring(n+3) == 3
                    output = [output 'd'];
                    n=n+4;
                elseif enstring(n+3) == 1
                    output = [output 'b'];
                    n=n+5;
                else
                    output = [output 'x'];
                    n=n+5;
                end
            else
                if enstring(n+3) == 3
                    output = [output 'k'];
                    n=n+4;
                elseif enstring(n+3) == 1
                    output = [output 'c'];
                    n=n+5;
                else
                    output = [output 'y'];
                    n=n+5;
                end
            end
        else
            if enstring(n+2) == 3
                output = [output 'm'];
                n=n+3;
            elseif enstring(n+2) == 1
                if enstring(n+3) == 3
                    output = [output 'g'];
                    n=n+4;
                elseif enstring(n+3) == 1
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

        