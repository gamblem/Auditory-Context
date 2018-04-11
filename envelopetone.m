function [audStim]=envelopetone(t1, denv, nen, sampleRate)
% [audStim]=envelopetone(t1, denv, nen, sampleRate)
% t1= Tone to create the envelope for
% denv= duration of the envelope (in ms)
% nen= Number of envelops (default = 1)
% samperate= sample rate of the auditory stimulus


tone=t1;
b=t1;

denv=denv/1000; %ms to seconds.

np=round(denv*sampleRate); %Gives the number of points for the envelope.
f=1/(denv*4); %duration of envelope x 4= 1 full sine cycle. divide this by 1 and you get cycles per second or hz (frequency).
dur=length(tone)/sampleRate; % 

% sine wave= A*sin(2*pi*frequency*time)
A= 1; % max amplitude of the tone

t=0:1/sampleRate:(dur-1/sampleRate);
env=A*sin(2*pi*f*t); %creates frequency of waveform.

%Here we create a new waveform that has the envelopes at each end and
%maximal amplitude in the center
if nen==1
    b(1:np)=env(1:np);
    b((np+1):(end-np))= 1; % max(tone);
    b((end-np)+1:end)= env((np+1):2*np);
elseif nen>1
end
   
 
nt=tone.*b; %Multiply the original tone by the newly created envelope 
audStim=nt;




