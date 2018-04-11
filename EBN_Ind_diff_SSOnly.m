% Created by Marissa Gamble
% last Edited 2/08/2016 3:48 pm

%In this experiment participants are given a visual cue (letter 'H' or
% 'L') indicating the to-be-searched-for tone ('H'= High tone, 'L'= Low
% Tone).  This is followed by 10 tones.  9 out of 10 tones are the same, one differs.

% Participants are instructed to respond as quickly and accurately as
% possible to whether the target tone (indicated by the visual cue) is Pure
% or Amplitude Modulated. If the Target tone is noe present (i.e., a low
% tone is presented but the Target is a High tone), participants are
% instructed to withold their responses.

% The format of the experiment is as follows
% Visual Cue- indicating item to be searched for
% Create auditory stimulus
% Presentation of the trial (using TDT)
% Participant Response 
% Rest breaks every 8 minutes or so
% Updates on participant behavior sent to experimeter screen

%---------------------------------------------------------------------
%                   Psychtoolbox Header Information
%%---------------------------------------------------------------------

close all; clear mex; clear all; clc; sca
commandwindow;

%Insert information from command line
subID = upper(input('Enter subject ID: ','s')); %Subject ID
GainNum = upper(input('Enter Gain: ','s')); % Gain
purekey=input('Enter Pure Response key: ');
ampkey=input('Enter AMP Response key:  ');
startTime = datestr(now);
mkdir(['Behavioral_Data/', subID]);

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1); 

% Set the screen number to the external secondary monitor if there is one
% connected
%screenNumber = max(Screen('Screens'));
screens=Screen('Screens');
screenNumber=1;

% Define black and white and Grey
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);

% Flip to clear
Screen('Flip', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Set the text size
Screen('TextSize', window, 42);
Screen('TextFont', window, 'Ariel');

% Query the maximum priority level
topPriorityLevel = MaxPriority(window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Hides the cursor from the Experimental Window
HideCursor(window);
%-------------------------------------------------------------------
%                               TDT Header Information
%---------------------------------------------------------------------
% Setting the basic paramaters for TDT, 1 channel, sample rate 48 kHz
% (actual sample rate is 48828.125)
% default trigger duration (5 ms), changed button hold duration to 500 ms
myTDT=tdt('playback_2channel_16bit',12, [1 1], [], 0.5, 15);


%------------------------------------------------------------------
%                        Timing Information
%------------------------------------------------------------------
ifi = Screen('GetFlipInterval', window);
waitframes=1;
vbl = Screen('Flip', window);
CueDuration=0.3;
CueAudInterval=[600 800]; % in ms
ResponseInterval=[1500 1800];% in ms
ITI=[500 800];
%---------------------------------------------------------------
%                       Basic Variables
%----------------------------------------------------------
trialsPerCondition =30; %
pausekey='p';
pausekeycode=KbName(pausekey);
resumekey='r';
resumekeycode=KbName(resumekey);


Correct=0;
Incorrect=0;
CorrectRej=0;
FalseAlarms=0;
Misses=0; % regular trial and no response
CatchCorrectRej=0; %Catch trial & no response
CatchFalseAlarms=0; % Catch Trial & response
p=1;%(display variable)
AudDur=50; %How long is the sound in Ms
A=1; %Aud Amplitude
env=8; % duration of sound envelope
writepath='C:\Experiments\Marissa\EBN_Ind_Diff_MX\';  %location to write the output file
q=1; %number of trials between breaks
LBCount=1;

%EventCodes
Standard=90;
LowPure=10;
HighPure=20;
LowAmp=30;
HighAmp=40;

%------------------------------------------------------------------
%                           Cue Information
%------------------------------------------------------------------
% Searching for the High Tone (H)
% Searching for the Low Tone (L)
% Searching for Both the High and Low tones (B)
% Respond as Quickly and accurately as possible
%
SearchList = {'L','H'};

% Make the matrix which will determine our condition combinations
condMatrixBase = [sort(repmat([1 2], 1, 4));repmat([1 2 3 4], 1, 2)];

% Duplicate the condition matrix to get the full number of trials
condMatrix = repmat(condMatrixBase, 1, trialsPerCondition);

%Trial Matrix
%FirstRow=condition 1=L, 2=H 3=B
%SecondROw=Trial type= 1= low tone,pure, 2=High tone,pure, 3=Low,amp 4=High, amp,

TrialMatrix= condMatrix;
% Get the size of the matrix
[~, numTrials] = size(TrialMatrix);

% Randomize the conditions
shuffler = Shuffle(1:numTrials);
TrialMatrixShuffled = TrialMatrix(:, shuffler);

%------------------------------------------------------------------
%                         Visual Stimuli
%------------------------------------------------------------------
% Fixation Cross
% Here we set the size of the arms of our fixation cross
fixCrossDimPix = 15;

% Set the coordinates (relative to zero )
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];

% Set the line width for our fixation cross
lineWidthPix = 4;

% Short Break\
ShortBreak= 'Take a short break';
Pause='Pause';
LongBreak='Take a break \n\n\n\n Please wait for the Experimenter to Continue...';

%For precise visual timing information use photoDiode
%PhotoDiode placement
params.diode1 = [0 1060 20 1080]; % default for Rm 314 [0 1060 20 1080]
params.diode2 = [660 1060 680 1080]; % default for Rm 314 [660 1060 680 1080]
params.diode3 = [1300 1060 1320 1080]; % default for Rm 314 [1300 1060 1320 1080]

diodePatch = white*ones(1,3); %


%-------------------------------------------------------------------
%                         Auditory Stimuli
%-------------------------------------------------------------------
%
StandA=0.0308;
LowPA=0.0388;
LowAA=0.0503;
HighPA=0.0203;
HighAA=0.0264;


%Identify the first deviant position (in position 6-10)
Devpos=randi([6,10],1,numTrials);
StreamISI=randi([80,120],numTrials,10);
AudStream=zeros(numTrials,10,2);




for j=1:numTrials;
    AudStream(j,:,2)=StreamISI(j,:); % This appends the jittered ISI to the Stims (
    if TrialMatrixShuffled(2,j) == 0
    elseif TrialMatrixShuffled(2,j) == 1
        AudStream(j,:,1)=[9 9 9 9 9 9 9 9 9 9];
        % Deviant Tone is a Low tone, pure
        AudStream(j,Devpos(j))=1;
        
    elseif TrialMatrixShuffled(2,j) == 2
        AudStream(j,:,1)=[9 9 9 9 9 9 9 9 9 9];
        % Deviant Tone is a Hight tone, pure
        AudStream(j,Devpos(j))=2;
    elseif TrialMatrixShuffled(2,j)== 3
        AudStream(j,:,1)=[9 9 9 9 9 9 9 9 9 9];
        % Deviant Tone is a low tone, amp
        AudStream(j,Devpos(j))=3;
    elseif TrialMatrixShuffled(2,j)==4
        AudStream(j,:,1)=[9 9 9 9 9 9 9 9 9 9];
        % Deviant Tone is a high tone, amp
        AudStream(j,Devpos(j))=4;
    end
    
end

%Make the auditory stimuli (the whole stream according to the above
%paramaters
toneStreamLength = length(0:1/myTDT.sampleRate:(AudDur/1000 - 1/myTDT.sampleRate));
ToneStream=zeros(toneStreamLength,10);
EcodeSamp=ones(j,11);
EventCode=zeros(numTrials,10);
RespISI=randi(ResponseInterval,numTrials,1); % Create a jittered array

for j=1:numTrials
    Esamp=0;
    for k=1:10
        if AudStream(j,k,1)==9 %Create the Standard Tone
            ToneStream(:,k)=makeTone(StandA,AudDur,1396,env,1, myTDT.sampleRate);
            EventCode(j,k)=Standard+k;
        elseif AudStream(j,k,1)==1 %Create the Low Pure Tone
            ToneStream(:,k)=makeTone(LowPA,AudDur,500,env,1, myTDT.sampleRate);
            EventCode(j,k)=LowPure+k;
        elseif AudStream(j,k,1)==2 %Create the High Pure Tone
            ToneStream(:,k)=makeTone(HighPA,AudDur,3000,env,1, myTDT.sampleRate);
            EventCode(j,k)=HighPure+k;
        elseif AudStream(j,k,1)==3 %Create the Low Amp Tone
            ToneStream(:,k)=makeTone(LowAA,AudDur,500,env,2, myTDT.sampleRate);
            EventCode(j,k)=LowAmp+k;
        elseif AudStream(j,k,1)==4 % Create the High Amp Tone
            ToneStream(:,k)=makeTone(HighAA,AudDur,3000,env,2, myTDT.sampleRate);
            EventCode(j,k)=HighAmp+k;
        end
        
        if k==10
            EventCode(j,k)=EventCode(j,k)-10;
        end
        
        %Inserting the rests here
        [RestISI]=ISItoSamp(AudStream(j,k,2), myTDT.sampleRate);
        RestStream{k}=zeros(1,RestISI);
        EcodeSamp(j,k+1)=Esamp+toneStreamLength+RestISI+1;
        Esamp=Esamp+toneStreamLength+RestISI;
    end
    
    [RespInt]=ISItoSamp(RespISI(j), myTDT.sampleRate);
    RespInt=zeros(1,RespInt);
    StimStream{j}=[ToneStream(:,1)' RestStream{1} ToneStream(:,2)' RestStream{2} ToneStream(:,3)' RestStream{3} ToneStream(:,4)' RestStream{4}...
        ToneStream(:,5)' RestStream{5} ToneStream(:,6)' RestStream{6} ToneStream(:,7)' RestStream{7} ToneStream(:,8)' RestStream{8} ...
        ToneStream(:,9)' RestStream{9} ToneStream(:,10)' RestStream{10} RespInt];
end

%------------------------------------------------------------------
%                          Experimental Loop
%------------------------------------------------------------------
CueAudISI=randi(CueAudInterval,numTrials,1); %Create a jittered array
ITInt=randi(ITI,numTrials,1);
 % Start timer- will check below with toc;
 tic
 send_event(myTDT, 254)  % per my .cfg file for the Biosemi, a trigger of 254 unpauses and 255 pauses the EEG recording

for j=1:numTrials
    % If this is the first trial we present a start screen and wait for a
    %     key-press
    if j == 1
        DrawFormattedText(window,...
            'In this experiment you will be searching for \n\n one of the following: \n\n the HIGH tone... \n\n or \n\n the LOW tone  \n\n\n\n Press any key to continue...',...
            'center', 'center', black);
        Screen('Flip', window);
        KbStrokeWait;
        
        DrawFormattedText(window,...
            'Before each trial \n\n a letter will appear in the center of the screen \n\n\n\n Press any key to continue...',...
            'center', 'center', black);
        Screen('Flip', window);
        KbStrokeWait;
        
        DrawFormattedText(window,...
            'If you see \n\n H \n\n Search for the HIGH tone \n\n\n\n Press any key to continue...',...
            'center', 'center', black);
        Screen('Flip', window);
        KbStrokeWait;
        
        DrawFormattedText(window,...
            'If you see \n\n L \n\n Search for the LOW tone \n\n\n\n Press any key to continue...',...
            'center', 'center', black);
        Screen('Flip', window);
        KbStrokeWait;
        
%         DrawFormattedText(window,...
%             'If you see \n\n B \n\n Search for BOTH the high and low tone \n\n\n\n Press any key to continue...',...
%             'center', 'center', black);
%         Screen('Flip', window);
%         KbStrokeWait;
%         
        if purekey==1 % Left Hand
            leftH='PURE';
            rightH='MODULATED';
        elseif purekey==2 %RightHand
            leftH='MODULATED';
            rightH='PURE';
        end
        
        DrawFormattedText(window,...
            ['Press the LEFT Button \n\n          for the \n\n      ' leftH '\n\n           Tone' ],...
            xCenter-800, 'center', black);
        
        DrawFormattedText(window,...
            ['Press the RIGHT Button \n\n           for the \n\n     ' rightH '\n\n           Tone' ],...
            xCenter+200, 'center', black);
        
        DrawFormattedText(window,...
            ' Press any key to continue...' ,...
            'center', yCenter+350, black);
        
        
        
        Screen('Flip', window);
        KbStrokeWait;

        %BreakTime=tic;
        Screen('DrawLines', window, allCoords, lineWidthPix, black, [xCenter yCenter], 2);
        %Flip to the screen-with precise timing
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        WaitSecs(0.5);
        
    end
    
    %At the beginnig of each Trial, load the auditory Stimulus and Trigger
    %information
    trigInfo=[EcodeSamp(j,1),EventCode(j,1);
        EcodeSamp(j,2),EventCode(j,2);
        EcodeSamp(j,3),EventCode(j,3);
        EcodeSamp(j,4),EventCode(j,4);
        EcodeSamp(j,5),EventCode(j,5);
        EcodeSamp(j,6),EventCode(j,6);
        EcodeSamp(j,7),EventCode(j,7);
        EcodeSamp(j,8),EventCode(j,8);
        EcodeSamp(j,9),EventCode(j,9);
        EcodeSamp(j,10),EventCode(j,10)];
    
    %At the beginning of each Trial, set the photodiode 
    
    
    % Drawing the Fixation Cross  %Note-The 2 at the end of the line deals with
    % smoothing lookmore into this based 'BlendFunction'
    Screen('DrawLines', window, allCoords, lineWidthPix, black, [xCenter yCenter], 2);
    
    % Flip to the screen-with precise timing
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    
    % Presentation of the Cue
    Screen('DrawLines', window, allCoords, lineWidthPix, black, [xCenter yCenter], 2);
    % TEMPORARY FIX TO THE OFFCENTER TEXT ISSUE
    xCueCord=20;
    yCueCord=80;
    Screen('DrawText', window, SearchList{TrialMatrixShuffled(1,j)}, xCenter-xCueCord, yCenter-yCueCord, black);
    photoLoc=TrialMatrixShuffled(1,j);
    if photoLoc==1 %Low Cue, Left Diode
        Screen('FillRect', window, diodePatch, params.diode1); % diode 1/left
    elseif photoLoc==2 %High cue, Right Diode
        Screen('FillRect', window, diodePatch, params.diode2); % diode 2/right
    elseif photoLoc==3 % Both Cue, Left and Right Diode
        Screen('FillRect', window, diodePatch, params.diode3); % diode center
    end
        
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    WaitSecs(CueDuration);
    PauseExperiment(pausekeycode,resumekeycode);
    %Draw Fixation Cross again
    Screen('DrawLines', window, allCoords, lineWidthPix, black, [xCenter yCenter], 2);
    [vbl, tResp] = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    
    loadStart = tic;
    Targ=TrialMatrixShuffled(2,j);
    Cue=SearchList{TrialMatrixShuffled(1,j)};
   
    myTDT.reset();
    myTDT.load_stimulus([StimStream{j}' StimStream{j}'], trigInfo);
       
    PauseExperiment(pausekeycode,resumekeycode);

    elapsedTime = toc(loadStart);
    if elapsedTime > (CueAudISI(j)/1000)
        warning('Load/prep time is longer than ISI.')
    end
    
    WaitSecs(CueAudISI(j)/1000 - elapsedTime);
    
    PauseExperiment(pausekeycode,resumekeycode);
    % present Auditory stimuli
    
    if Targ==0
        %don't present auditory stimuli
        WaitSecs(0.3);
    else
        %Present auditory stimuli
        myTDT.play_blocking();
    end
    
     PauseExperiment(pausekeycode,resumekeycode);
    
    %Get Response key
    [pressVals, pressSamples]=get_button_presses(myTDT);
    
    Response=pressVals;
    
    RTinSamp=pressSamples - EcodeSamp(j,Devpos(j)); % RT time minus the sample time of Targ
    RespT=(RTinSamp./myTDT.sampleRate)* 1000;
    [color,Correct,Incorrect,FalseAlarms,Misses, CorrectRej,CatchCorrectRej, CatchFalseAlarms ] = CheckResponseAcc(Cue,Targ,Response,purekey,ampkey,Correct,Incorrect,FalseAlarms,Misses,CorrectRej,CatchCorrectRej,CatchFalseAlarms);
    
    %Feedback information based on response. Red for incorrect, Green for correct,
    if strcmp(color,'red')==1
        Screen('DrawLines', window, allCoords, lineWidthPix, [0 0 0], [xCenter yCenter], 2);
    elseif strcmp(color,'green')==1
        Screen('DrawLines', window, allCoords, lineWidthPix, [0 0 0], [xCenter yCenter], 2);
    end
    [vbl, tResp] = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    WaitSecs(0.1); %feedback is on the screen for 100 ms
    % Black fixation cross for 500 ms before the start of the next trial.
    Screen('DrawLines', window, allCoords, lineWidthPix, black, [xCenter yCenter], 2);
    [vbl, tResp] = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    WaitSecs(ITInt(j)/1000);
    
    %Print trial information to the Command Window
    disp(['     ' num2str(j) '  ' Cue '    ' num2str(Targ) '      ' num2str(Response) '    ' num2str(RespT) '    ' color ' ' ])
    
    if p<=10
        p=p+1;
    else
        %Printing summary to the command window
        disp(['Summary:  Percent Correct ' num2str(((Correct+CorrectRej)/(Correct+CorrectRej+Incorrect+Misses+FalseAlarms))*100) '%    Percent Correct Catch ' num2str(((CatchCorrectRej)/(CatchCorrectRej+CatchFalseAlarms))*100) '%  ' ])
        p=1;
    end
    
   % LBCount=LBCount+1;
    if LBCount==91;
        disp(['*******************Long Break***********************' ])
        Screen('DrawLines', window, allCoords, lineWidthPix, black, [xCenter yCenter], 2);
        % TEMPORARY FIX TO THE OFFCENTER TEXT ISSUE
        xCueCord=200;
        yCueCord=80;
        DrawFormattedText(window, LongBreak, xCenter-xCueCord, yCenter-yCueCord, black);
          DispCorrect= num2str(((Correct+CorrectRej)/(Correct+CorrectRej+Incorrect+Misses+FalseAlarms))*100);
          DrawFormattedText(window,...
            ['Percent Correct: ' DispCorrect '%'] ,...
            xCenter-xCueCord,  yCenter+(2*yCueCord), black);
   
       % Screen('DrawFormattedText', window, LongBreak, xCenter-xCueCord, yCenter-yCueCord, black);
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
       %  Screen('FillRect', window, diodePatch, params.diode3); % diode Center
     %KbStrokeWait;
     KbTriggerWait([KbName('s')]);
   % KbEventFlush;
        
        %Check for pauses 
        PauseExperiment(pausekeycode,resumekeycode);
        
        Screen('DrawLines', window, allCoords, lineWidthPix, black, [xCenter yCenter], 2);
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        WaitSecs(.5)
        q=1;
        LBCount=1;
    else
    end
    
    if q <= 30 %2 1/2 minutes
        q=q+1;
        LBCount=LBCount+1;
    else
       disp(['*******************Short Break***********************' ])
        toc
        %shortbreaktime=toc(breaktime);
        Screen('DrawLines', window, allCoords, lineWidthPix, black, [xCenter yCenter], 2);
        % TEMPORARY FIX TO THE OFFCENTER TEXT ISSUE
        xCueCord=200;
        yCueCord=80;
%         DrawFormattedText(window,...
%             'If you see \n\n H \n\n Search for the HIGH tone \n\n\n\n Press any key to continue...',...
%             'center', 'center', black);
%         Screen('Flip', window);
        DrawFormattedText(window, ShortBreak, xCenter-xCueCord, yCenter-yCueCord, black);
        DispCorrect= num2str(((Correct+CorrectRej)/(Correct+CorrectRej+Incorrect+Misses+FalseAlarms))*100);
          DrawFormattedText(window,...
            ['Percent Correct: ' DispCorrect '%'] ,...
            xCenter-xCueCord,  yCenter+yCueCord, black);
   
        %Screen('DrawFormattedText', window, ShortBreak, xCenter-xCueCord, yCenter-yCueCord, black);
       % Screen('FillRect', window, diodePatch, params.diode3); % diode Center
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        WaitSecs(10);
        
        %Check for pauses
        PauseExperiment(pausekeycode,resumekeycode);
        
        Screen('DrawLines', window, allCoords, lineWidthPix, black, [xCenter yCenter], 2);
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        WaitSecs(.5)
        q=1;
        LBCount=LBCount+1;
    end
   
 
  %  Save results to result.mat .
  CueType{j}=Cue;
  TargType{j}=Targ;
  TargLoc{j}= Devpos(j);
  Resp{j}=Response;
  RT{j}=RespT;
 %results
    
    myTDT.reset();
end

%Print all of the relevant information to a .mat file
TrialInfo=[CueType' TargType' TargLoc' Resp' RT'];
TrialInfo = mat2dataset(TrialInfo, 'VarNames',{'CueType','TargetType','TargLoc', 'Response', 'RT'});

PresentationData.SubID=subID;
PresentationData.GainNum=GainNum;
PresentationData.ResponseMapping.Pure=purekey;
PresentationData.ResponseMapping.Amp=ampkey;
PresentationData.TrialInfo=TrialInfo;
PresentationData.TrialMatrix=TrialMatrixShuffled;
PresentationData.AudStream=AudStream(:,:,1);
PresentationData.ISI.CueAudISI=CueAudISI;
PresentationData.ISI.RespISI=RespISI;
PresentationData.ISI.StreamISI=StreamISI;
PresentationData.Results.Correct=Correct;
PresentationData.Results.Incorrect=Incorrect;
PresentationData.Results.Misses=Misses;
PresentationData.Results.CorrectRej=CorrectRej;
PresentationData.Results.FalseAlarms=FalseAlarms;
PresentationData.Results.Total=Correct+Incorrect+Misses+CorrectRej+FalseAlarms;
PresentationData.Results.PercentCorrect=((Correct+CorrectRej)/(Correct+Incorrect+Misses+CorrectRej+FalseAlarms))*100;

save(([writepath 'Behavioral_Data\' subID '\' subID '_bdata_SS.mat']), '-struct', 'PresentationData' );

clear myTDT
% Clear the screen.
ShowCursor;
sca;
commandwindow;

