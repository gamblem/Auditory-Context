function [ numSamp ] = ISItoSamp( timeInMs, sampleRate )
%ISItoSamp: Conversion of the timing (in ms, to samples)

dur=timeInMs/1000; % converting ms into seconds
t=0:1/sampleRate:dur-(1/sampleRate);
numSamp=length(t);

end

