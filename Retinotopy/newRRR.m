function  newRRR(matname);
Screen('Preference', 'SkipSyncTests', 0);
[im params] = matpro(matname);

leadin = params.lagg;
leadout = params.lagg;
TR = params.secsPerImg;


 scr = 0;

triggerchar = '5';



[w rect] = Screen('openwindow',scr,0,[0 0 1024 768],32,2);
origLUT=Screen('ReadNormalizedGammaTable', scr);
Screen('Preference', 'TextAntiAliasing',0);
hz=Screen('FrameRate',w);      % frames per second
ifi=Screen('GetFlipInterval', w);
if hz==0
    hz=1/ifi;
end;

frames = round(hz/params.tf/2);



newLUT = zeros(256,3);
newLUT(1,:) = 0.5; % gray;
newLUT(2,:) = 0; % Black;
newLUT(3,:) = 1; % White;
newLUT(4,:) = [1 0 0]; % Red;

clut=[0 0 0; 1 1 1; ...
    1 0 0; 0 1 1; ...
    0 1 0; 1 0 1; ...
    0 0 1; 1 1 0];

gray = 0; black = 1; white = 2; red = 3;
resp = zeros(1,3);

Screen('LoadNormalizedGammaTable',w,newLUT);


FlushEvents('keydown');
while KbCheck; end % Wait until all keys are released.

HideCursor;	% Hide the mouse cursor
Priority(MaxPriority(w));
Screen('fillrect',w,gray);
Screen(w,'TextSize',24);
msg = 'Press key when you see fixation change';
Screen('DrawText', w, msg, [(rect(3)/2)-240], [rect(4)/2], red);
Screen('flip',w);
Screen('LoadNormalizedGammaTable',w,newLUT);

for i = 1:params.numImages
    tex(i) = Screen('Maketexture',w, im{i});
end

keyIsDown = 0;
% while ~keyIsDown
%     [keyIsDown,secs,keyCode] = KbCheck;
% end
% while keyIsDown
%     [keyIsDown,ignore,ignore] = KbCheck;
% end
    while ~CharAvail
    end
%     [key, secs] = getchar;
    while CharAvail
        GetChar;
    end

% ResponseSame = find(keyCode);
% SameChar = kbname(keyCode);

rest0 = params.secsBetweenRepeats;




eyecalibration(w,gray,white,black);
FlushEvents('keydown')
Screen(w, 'fillrect', [gray], rect);
Screen(w,'TextSize',48);
Screen(w, 'DrawText', 'READY!', [(rect(3)/2)-100], [rect(4)/2], [white]);
Screen('flip',w);

ListenChar(2)

while 1
    while ~CharAvail
    end
    [key, secs] = GetChar;
    while CharAvail
        GetChar;
    end
    if key == triggerchar
        break;
    end
end
FlushEvents('keyDown');
start = GetSecs;
ListenChar(0)

endtime = start + leadin * TR;
fc = 1;
drawfix(w,fc);
Screen('flip',w);
while GetSecs <endtime
end
ii = 2;
changetime = GetSecs + rand*4 + 2;
for i = 1:params.repeats
    for j = 1:length(tex)
        Screen('Drawtexture',w,tex(j));
        drawfix(w,fc);
        Screen('Flip',w);
        
        Screen('Drawtexture', w,tex(j));
        endtime = start + (leadin + (i-1)*(params.numImages + rest0) + j ) * TR;
        disclut = newLUT;
        
        while GetSecs < endtime
            m = (mod(ii,frames*2)>frames)+1;
            n = mod(floor(ii/frames/2),4)*2;
            if m == 1
                disclut(5:6,:) = clut(n+1:n+2,:);
            else
                disclut(5:6,:) = clut(n+2:-1:n+1,:);
            end
            Screen('WaitBlanking', w, 1);
            Screen('LoadNormalizedGammaTable',w,disclut);
            ii = ii + 1;
            if GetSecs > changetime
                fc = 1 - fc;
                
                changetime = GetSecs + rand*4 + 3;
            end
            
        end
    end
    if rest0 > 0;
        Screen('fillrect',w,gray);
        drawfix(w,fc);
        Screen('flip',w);
        endtime = start + (leadin + i*(params.numImages + rest0)) * TR;
        while GetSecs<endtime
        end
    end
end
Screen('fillrect',w,gray);
drawfix(w,fc);
Screen('flip',w);
endtime = start + (leadin + params.repeats*(params.numImages + rest0)+leadout) * TR;
while GetSecs < endtime
end
GetSecs - start
Screen('LoadNormalizedGammaTable',w,origLUT);
Screen('closeall');




    function drawfix(w,fc)
        lineWidth = 4;
        rad = 40;
        xc = rect(3)/2;
        yc = rect(4)/2;
        os = round(lineWidth/2);

        if fc == 1
            sz = floor(rad/2);
            Screen('DrawLine',w, black, xc-os-sz, yc-os, xc-os+sz, yc-os, lineWidth);
            Screen('DrawLine',w, black, xc-os, yc-os-sz, xc-os, yc-os+sz, lineWidth);
        else
            lineWidth = lineWidth * sqrt(2);
            sz = ceil(rad/2/sqrt(2));
            Screen('DrawLine',w,black, xc-os-sz, yc-os-sz, xc-os+sz, yc-os+sz, lineWidth);
            Screen('DrawLine',w,black, xc-os-sz, yc-os+sz, xc-os+sz, yc-os-sz, lineWidth);
        end
    end
end

