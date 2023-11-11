function filtered_signal = bandpassFilter(signal, fs)

    % Bandpass filter parameters
    f_low = 0.5;
    f_high = 50;
    order = 2;

    % Design bandpass filter
    [b, a] = butter(order, [f_low, f_high] / (fs / 2), 'bandpass');

    % Plot the frequency response
    figure;
    freqz(b, a, 256, fs);

    % Apply bandpass filter
    filtered_signal = filtfilt(b, a, signal);

    % Plot the original and filtered signals
    t = (0:length(signal)-1) / fs;
    figure;
    subplot(2,1,1);
    plot(t, signal);
    title('Original Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');

    subplot(2,1,2);
    plot(t, filtered_signal);
    title('Bandpass Filtered Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');

end

