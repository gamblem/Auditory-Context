function [audStim]=makeTone(A, duration, f, env, modulate, sampleRate)
%Make tone: creates a simple auditory stimulus .
%maketone(Amplitude, Duration, Frequency, Duration of Envelope

% Sine Wave=A*sin(2*pi*frequency*time)

dur=duration/1000;% converting ms into seconds

t=0:1/sampleRate:(dur-1/sampleRate); 

tone=A*sin(2*pi*f*t);

if modulate>1 %
    mod=A*sin(2*pi*30*t); % if modulate > 1, use 30 Hz?
   
    %set up modulation here
    ToneMod=ammod(mod, f, sampleRate);
    audStim=ToneMod; 
    
else
    % If not modulation- create a rise and fall of the stimulus
    [audStim]=envelopetone(tone,env,modulate,sampleRate); %
end