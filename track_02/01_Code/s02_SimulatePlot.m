%% Simulate Data and Plot them
% Julian Keil keil@psychologie.uni-kiel.de

clear all
close all
clc

%% 1. Build an Oscillation
% First we need a time-vector
srate = 1000;
time = (-1000:1:1000)/srate; % 1 Second @ 1000 Hz

% Then we need a Frequency to Oscillate
freq = 2; % frequency in Hz

% now create the sinewave: Multiply Time and Frequency with 2Pi and take the
% Sine
sinewave = sin(2*pi*freq*time);

% now plot it!
plot(time,sinewave)

% Plot can also take multiple inputs:
% ---Question 1: How can we add the time-vector as X-Axis?
% ---Question 2: How can we plot stars or points instead of a line?
% ---Question 3: How can we have multiple plots?

% optional prettification of the plot
set(gca,'xlim',[-1.1 1.1],'ylim',[-1.1 1.1]); 
xlabel('Time (ms)')
ylabel('Amplitude')
title('My first sine wave plot!')

%% 2. Build a waveform: A sum of multiple sine waves
% First we need a time-vector
time = (-1000:1:1000)/srate; % 1 Second @ 1000 Hz

% Then we need some Frequencies to Oscillate
freqs = [3 5 10 15 35];

% Then we'll use different amplitudes for each frequency
amplit = [20 15 10 5 2];

% We can set a starting Phase for each frequency between -pi and pi
phases = [pi/7 pi/8 pi pi/2 -pi/4];

% now we loop through frequencies and create sine waves
sine_waves = zeros(length(freqs),length(time));
% If we define the output variable with zeros before hand, the loop can
% fill it up faster, as the new fields don't have to be created on the fly
for fi=1:length(freqs)
    sine_waves(fi,:) = amplit(fi) * sin(2*pi*time*freqs(fi) + phases(fi));
end

% now plot the result
plot(time,sum(sine_waves)) % Sum the Sine Waves and Plot the Waveform
title('sum of sine waves')
xlabel('Time (s)'), ylabel('Amplitude (arb. units)')

% now plot each wave separately
for fi=1:length(freqs)
    subplot(length(freqs),1,fi)
    plot(time,sine_waves(fi,:))
    axis([time([1 end]) -max(amplit) max(amplit)])
end

% ---Question 4: What does "subplot" do? What is the purpose of "axis"?

%% 3. Split up the waveform into the underlying frequencies
% First Sum the Sine Waves
wave = sum(sine_waves);

% Use the Fast Fourier Transform to split up the sine waves
sineX = fft(wave)/length(time); % Normalize by number of samples

% ---Question 5: Plot "sineX". What does it look like? What could be the
% reason for this? Hint: Use "whos" to inspect "sineX"

% define vector of frequencies in Hz
% linearly spaced elements from 0 to half the sample rate in 1001 points
hz = linspace(0,srate/2,floor(length(time)/2)+1);
% ---Question 6: Why only go up to half the sample rate? What is special
% about this number?

% Plot the Output of the Fourier Analyis on the Frequency Axis
plot(hz,2*abs(sineX(1:length(hz))),'ro-')
% --- Question: Why does this look different from plotting plot(sineX) or plot(hz,sineX(1:length(hz)))
% Hint: What is "abs"? What happens if I change "abs" to "real"? Why?

% make the plot look a bit nicer
set(gca,'xlim',[0 max(freqs)*1.2])
xlabel('Frequency (Hz)'), ylabel('Amplitude')
