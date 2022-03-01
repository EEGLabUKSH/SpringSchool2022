%% Simulate Data and Filter into Frequency Bands
% Julian Keil keil@psychologie.uni-kiel.de

clear all
close all
clc

%% 1. First Build a Signal
srate = 1000;

% First we need a time-vector
time = (-1000:1:1000)/srate; % 1 Second @ 1000 Hz

% Then we need some Frequencies to Oscillate
freqs = [2:2:50];

% Then we'll use different amplitudes for each frequency
amplit = 1./freqs;

% We can set a starting Phase for each frequency between -pi and pi
tmp = randi(100,1,length(freqs));
phases = tmp./(1/pi);

% now we loop through frequencies and create sine waves
sine_waves = zeros(length(freqs),length(time));
% If we define the output variable with zeros before hand, the loop can
% fill it up faster, as the new fields don't have to be created on the fly
for fi=1:length(freqs)
    sine_waves(fi,:) = amplit(fi) * sin(2*pi*time*freqs(fi) + phases(fi));
end

signal = sum(sine_waves);

%Plot
plot(time,signal);
%% 2. Filter-Settings
band = [15 25]; % Band for Bandstop or Notch-Filters
high = 3; % Highpass
low = 30; % Lowpass

%% 3. Build a High-Pass analog (Butterworth) filter
[b, a] = butter(4, high/(srate/2),'high'); % "butter" is the Butterworth-Function
freqz(b, a, srate); % Plot Filter response.

% ---Question 1: What happens if we change the Filter order? Inspect the
% Magnitude and Phase Response. What will this mean for the signal?

%% 3.1. Apply the Filter to the Data
onepass_highpass = filter(b,a,signal);
twopass_highpass = filtfilt(b,a,signal);

% Compare the original and the filtered data

figure;
subplot(211); plot(time,signal); ylim([-1,1]);
subplot(212); plot(time,onepass_highpass,'r'); ylim([-1,1]);

% ---Question 2: What could be the difference between "filter" and "filtfilt"?
% Compare Filtered Signals. What happens to the signal? Pay attention to
% the Amplitude and Phase.

figure;
subplot(211); plot(time,onepass_highpass); ylim([-1,1]);
subplot(212); plot(time,twopass_highpass,'r'); ylim([-1,1]);

%% 4. Build a Low-Pass Butterworth filter
[b, a] = butter(8, low/(srate/2),'low');
freqz(b, a, srate);

%% 4.1. Apply the Filter to the Data
onepass_lowpass = filter(b,a,signal); 
twopass_lowpass = filtfilt(b,a,signal); 

% Compare the original and the filtered data

figure;
subplot(211); plot(time,signal); ylim([-1,1]);
subplot(212); plot(time,onepass_lowpass,'r'); ylim([-1,1]);

% ---Question 3: What could be the difference between highpass and lowpass?
% Compare Filtered Signals. What happens to the signal? Pay attention to
% the Amplitude and Phase.
figure;
subplot(311); plot(time,signal); ylim([-1,1]);
subplot(312); plot(time,onepass_highpass,'k'); ylim([-1,1]);
subplot(313); plot(time,onepass_lowpass,'r'); ylim([-1,1]);

figure;
subplot(211); plot(time,onepass_lowpass); ylim([-1,1]);
subplot(212); plot(time,twopass_lowpass,'r'); ylim([-1,1]);

%% 5. Now build a digital (FIR) filter
b = fir1(100, high/(srate/2),'high');
freqz(b, 1, srate);

% ---Question 4: What could be the difference between "butterworth" and "fir"?
% Inspect the Magnitude and Phase Response. What will this mean for the signal?

%% 5.1. Apply the Filter to the Data
onepass_fir = filter(b,1,signal);
twopass_fir = filtfilt(b,1,signal);

figure;
subplot(211); plot(time,signal); ylim([-1,1]);
subplot(212); plot(time,onepass_fir,'r'); ylim([-1,1]);

% ---Question 5: What could be the difference between fir and butterworth?
% Compare Filtered Signals. What happens to the signal? Pay attention to
% the Amplitude and Phase.
figure;
subplot(311); plot(time,signal); ylim([-1,1]);
subplot(312); plot(time,onepass_highpass,'k'); ylim([-1,1]);
subplot(313); plot(time,onepass_fir,'r'); ylim([-1,1]);

figure;
subplot(211); plot(time,onepass_fir); ylim([-1,1]);
subplot(212); plot(time,twopass_fir,'r'); ylim([-1,1]);
%% 6. Additional Filters
% Band-Stop-Filter
b = fir1(100, band/(srate/2),'stop');
fvtool(b, 1, 'Fs', srate);

twopass_fir_bs = filtfilt(b,1,signal);

b = fir1(100, band/(srate/2),'bandpass');
fvtool(b, 1, 'Fs', srate);

twopass_fir_bp = filtfilt(b,1,signal);

% ---Question 6: What could be the difference between bandstop and bandpass
% filters?
% Compare Filtered Signals. What happens to the signal? When would they be
% useful?

figure;
subplot(211); plot(time,twopass_fir_bs); ylim([-1,1]);
subplot(212); plot(time,twopass_fir_bp,'r'); ylim([-1,1]);