function [color,Correct,Incorrect,FalseAlarms,Misses, CorrectRej, CatchCorrectRej, CatchFalseAlarms ] = CheckResponseAcc(Cue,Targ,Response,purekey,ampkey,Correct,Incorrect,FalseAlarms,Misses,CorrectRej, CatchCorrectRej, CatchFalseAlarms)
%CheckResponseAcc -Checks for the accuracy of the participant response.
%  Input based on the Cue (whether it was a high 'H' or 'L', or search for
%  Both the 'B'), the response mapping (purekey, and ampkey), and the event
%  code for the Target stimulus.  The overall correct responses, incorrect
%  responses, false alarms, etc, are updated as well.
% By returning the color red or green, participants get visual feedback
% whether their response was correct (i.e. green) or incorrect (i.e., red).

if Response==purekey % strcmp(Response,purekey)
    if Targ==1 &&...
            (strcmp(Cue,'L')==1 || strcmp(Cue,'B')==1)
        Correct=Correct+1;
        color='green';
    elseif Targ==2 &&...
            (strcmp(Cue,'H')==1 || strcmp(Cue,'B')==1)
        Correct=Correct+1;
        color='green';
    elseif  Targ==3 &&...
            (strcmp(Cue,'L')==1 || strcmp(Cue,'B')==1)
        Incorrect=Incorrect+1;
        color='red';
    elseif  Targ==4 &&...
            (strcmp(Cue,'H')==1 || strcmp(Cue,'B')==1)
        Incorrect=Incorrect+1;
        color='red';
    elseif  Targ==5 &&...
            (strcmp(Cue,'L')==1 || strcmp(Cue,'B')==1)
        Correct=Correct+1;
        color='green';
    elseif  Targ==6 &&...
            (strcmp(Cue,'H')==1 || strcmp(Cue,'B')==1)
        Correct=Correct+1;
        color='green';
    elseif  Targ==7 &&...
            (strcmp(Cue,'L')==1 || strcmp(Cue,'B')==1)
        Incorrect=Incorrect+1;
        color='red';
    elseif  Targ==8 &&...
            (strcmp(Cue,'H')==1 || strcmp(Cue,'B')==1)
        Incorrect=Incorrect+1;
        color='red';
    elseif Targ==0
        CatchFalseAlarms=CatchFalseAlarms+1;
        color='red';
    elseif (Targ==1 || Targ==3 || Targ==5 || Targ==7) && (strcmp(Cue,'H')==1)
        FalseAlarms=FalseAlarms+1;
        color='red';
    elseif (Targ==2 || Targ==4 || Targ==6 || Targ==8) && (strcmp(Cue, 'L')==1)
        FalseAlarms=FalseAlarms+1;
        color='red';
    end
elseif Response==ampkey %strcmp(Response,ampkey)==1
    if Targ==3 &&...
            (strcmp(Cue,'L')==1 || strcmp(Cue,'B')==1)
        Correct=Correct+1;
        color='green';
    elseif Targ==4 &&...
            (strcmp(Cue,'H')==1 || strcmp(Cue,'B')==1)
        Correct=Correct+1;
        color='green';
    elseif  Targ==1 &&...
            (strcmp(Cue,'L')==1 || strcmp(Cue,'B')==1)
        Incorrect=Incorrect+1;
        color='red';
    elseif  Targ==2 &&...
            (strcmp(Cue,'H')==1 || strcmp(Cue,'B')==1)
        Incorrect=Incorrect+1;
        color='red';
    elseif  Targ==7 &&...
            (strcmp(Cue,'L')==1 || strcmp(Cue,'B')==1)
        Correct=Correct+1;
        color='green';
    elseif  Targ==8 &&...
            (strcmp(Cue,'H')==1 || strcmp(Cue,'B')==1)
        Correct=Correct+1;
        color='green';
    elseif  Targ==5 &&...
            (strcmp(Cue,'L')==1 || strcmp(Cue,'B')==1)
        Incorrect=Incorrect+1;
        color='red';
    elseif  Targ==6 &&...
            (strcmp(Cue,'H')==1 || strcmp(Cue,'B')==1)
        Incorrect=Incorrect+1;
        color='red';
        
    elseif Targ==0
        CatchFalseAlarms=CatchFalseAlarms+1;
        color='red';
    elseif (Targ==1 || Targ==3 || Targ==5 || Targ==7 ) && (strcmp(Cue,'H')==1)
        FalseAlarms=FalseAlarms+1;
        color='red';
    elseif (Targ==2 || Targ==4 || Targ==6 || Targ==8) && (strcmp(Cue, 'L')==1)
        FalseAlarms=FalseAlarms+1;
        color='red';
    end
elseif isnan(Response)==1 %strcmp(Response,'NaN')==1
    if Targ==0
        CatchCorrectRej=CatchCorrectRej+1;
        color='green';
    elseif (Targ==1 || Targ==3) && (strcmp(Cue,'H')==1)
        CorrectRej=CorrectRej+1;
        color='green';
    elseif (Targ==2 || Targ==4) && (strcmp(Cue,'L')==1)
        CorrectRej=CorrectRej+1;
        color='green';
    else
        Misses=Misses+1;
        color='red';
    end
else
    color='red';
    Incorrect=Incorrect+1;
end

end

