function PauseExperiment(pausekeycode,resumekeycode)
    [isPressed,endtime,keycode] = KbCheck;	% check for pause key
    if isPressed
        if keycode(pausekeycode)
            keyPressed=0;     
           while keyPressed==0;
            %Take a break while pause is pressed
             [isPressed,endtime,keycode] = KbCheck;
                if keycode(resumekeycode)
                    keyPressed=1;
                    WaitSecs(.5);
                else
                end
            end
        end
    end
end





