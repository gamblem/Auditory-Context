function [ Response ] =GetResponse(timeuntil,ampkeycode,purekeycode)
%GetResponse,Checks to see if a response was pressed.\
% output is the keyboard response or none.

%This one works if you hold down the key response
[~, keycode, ~] = KbStrokeWait([], timeuntil);
   
     if (find(keycode,1)==ampkeycode | find(keycode,1)==purekeycode)
         Response = KbName(keycode);     
    else
        Response='none';
     end

end

