function lbarredh(dur,width,speed,contrast)
%RMd213
%horizontal bars on screen
%for res of 768 x 1024,17pixels per 100 microns, red version
% dur= total durtion in seconds
% width= in pixels
% speed=pixels per frame
% contrast 1 is 100%
Screen('Preference', 'SkipSyncTests', 1); %don't use this in real experiment
AssertOpenGL;
try
    myscreen=0;
    mywindow=Screen('OpenWindow',myscreen);
    [xsize ysize]=Screen('WindowSize', mywindow);
    black=BlackIndex(mywindow);
    white=WhiteIndex(mywindow);
    MeanIntensity=((black+white+1)/2)-1;
    % contrast=contrast/100;
    ifi=Screen('GetFlipInterval',mywindow);
    % FrameTime= ifi*2;
    [vbl]=Screen('Flip',mywindow);
    
    size=ysize+width;
    
    dist=size;
    step=speed;
    timeperrep=ifi*floor(size/step) % # of frame -> integer
    
    Reps=floor(dur/timeperrep)
    
    actualdur=Reps*timeperrep
    
    xstart=0;
    ystart=0-width;
    
    length=xsize;
    lum=MeanIntensity-contrast*MeanIntensity;
    
    x= 1:width;
    bar1(1,1:width,1) = lum;
    bar1(1,1:width,3) = 0;
    
    
    object=Screen('MakeTexture',mywindow,bar1);
    
    %    Reps=floor(Time*10/Time);
    %     totTime=Reps*Time+Time/2
    
    photodiode=ones(4,1);
    photodiode(1,:)=xsize/10*9;
    photodiode(2,:)=ysize/10*1;
    photodiode(3,:)=xsize/10*9+80;
    photodiode(4,:)=ysize/10*1+80;
    
    Screen('FillRect', mywindow, [MeanIntensity 0 0]);
    Screen('Flip',mywindow);
    
    %    KbWait;
    
    HideCursor
    
    Priority(MaxPriority(mywindow));
    
    Screen('FillRect', mywindow, black, photodiode);
    vbl=Screen('Flip',mywindow, vbl+.001);
    
    for r=1:Reps
        for inc=1:step:dist
            
            place=[xstart;ystart+inc;xstart+length;ystart+width+inc];
            Screen('DrawTexture', mywindow, object,[],place);
            if inc==1
                Screen('FillRect', mywindow, [white 0 0], photodiode);
            else
                Screen('FillRect', mywindow,black, photodiode);
            end
            vbl=Screen('Flip',mywindow, vbl+.001);
            if KbCheck
                break;
            end
        end
        if KbCheck
            break;
        end
    end
    Screen('CloseAll');
    ShowCursor
catch exception
    
    Screen('CloseAll');
    ShowCursor
    exception.identifier
end