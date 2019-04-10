function PPDelay(file, delayMs, wet, dry, fb) %signal, delay in miliseconds, wet, dry, feedback coeficients, sampling frequency
% PPDelay('120BPM - Bass Synth.wav', 250, 0.7, 0.5, 0.6);
[x, Fs] = audioread(file);
% convert the delay in miliseconds to delay in samples(we can only work with delay in samples)
delaySamples = fix(delayMs/1000 * Fs);
% create an empty array for our output the size of input + three times the delay lenght to accomodate for (some) Feedback
y = zeros(length(x)+(delaySamples*3),2); 
% create a temporary array that will be used for the feedback part
s = y; 

% create the feedback delay part
for n = 1:length(x) 
    % Ensure that the algorithm works before the first delay can occur, by copying the input to output
    if n < delaySamples+1
        s(n,1) = x(n,1);
        s(n,2) = x(n,2);
    else % the output is the input + the delayed version of the output
        s(n,1) = x(n,1) + fb*s(n-delaySamples,1); 
        s(n,2) = x(n,2) + fb*s(n-delaySamples,2);  
    end
end

% create the output 
for n = 1:length(x) 
    % Ensure that the algorithm works before the first delay can occur, by copying the input to output
    if n < delaySamples+1
        y(n,1) = s(n,2);
        y(n,2) = s(n,1);
    else % the output is the input scaled down by the "dry" coeff, + the delayed version. Note the channel flipping at s(n)
        y(n,1) = dry*x(n,1) + wet*s(n,2);
        y(n,2) = dry*x(n,2) + wet*s(n,1);
    end
    
out(n,:) = [y(n,1), y(n,2)];
end
sound(out,Fs);
end