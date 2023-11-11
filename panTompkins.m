function [qrs_indices, heart_rate, qrs_width] = panTompkins(ecg, fs)

    % Plot original signal
    t = (0:length(ecg)-1) / fs;
    figure;
    subplot(6,1,1);
    plot(t, ecg);
    title('Original ECG Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');

    % Bandpass filter the signal
    filtered_ecg = bandpassFilter(ecg, fs);

    % Plot filtered signal
    subplot(6,1,2);
    plot(t, filtered_ecg);
    title('Bandpass Filtered Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');

    % Compute derivative
    derivative_ecg = diff(filtered_ecg);

    % Plot derivative
    subplot(6,1,3);
    plot(t(2:end), derivative_ecg);
    title('Derivative of Filtered Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');

    % Square the derivative
    squared_ecg = derivative_ecg.^2;

    % Plot squared signal
    subplot(6,1,4);
    plot(t(2:end), squared_ecg);
    title('Squared Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');

    % Moving average filter
    window_width = round(0.150 * fs); % 150 ms window
    ma_ecg = movmean(squared_ecg, window_width);

    % Hilbert Transform to enhance peak detection
    hilbert_ecg = abs(hilbert(ma_ecg));

    % Plot integrated signal
    subplot(6,1,5);
    plot(t(2:end), ma_ecg);
    title('Integrated Signal (Moving Average)');
    xlabel('Time (s)');
    ylabel('Amplitude');
    

    rou = 0.2;
    th = 0.05;
    % Find peaks in the Hilbert-transformed signal
    threshold = th * max(squared_ecg); % Adjust this threshold value
    [~, locs] = findpeaks(squared_ecg, 'MinPeakHeight', threshold, 'MinPeakDistance', round(rou * fs));

    % Post-processing to select peaks with highest amplitude
    window_size = round(0.15 * fs); % 150 ms window
    selected_locs = [];
    for i = 1:length(locs)
        start_idx = max(1, locs(i) - window_size);
        end_idx = min(length(squared_ecg), locs(i) + window_size);
        [~, max_idx] = max(squared_ecg(start_idx:end_idx));
        selected_locs = [selected_locs, start_idx + max_idx - 1];
    end

    % Plot detected peaks
    subplot(6,1,6);
    plot(t, ecg, 'b', t(selected_locs), ecg(selected_locs), 'ro');
    title('ECG Signal with Detected Peaks');
    xlabel('Time (s)');
    ylabel('Amplitude');
    legend('ECG Signal', 'Detected Peaks');

    % Calculate RR intervals
    rr_intervals = diff(selected_locs) / fs;

    % Compute heart rate
    heart_rate = 60 / mean(rr_intervals);

    % Compute QRS width
    qrs_width = mean(rr_intervals) / 2;

    % QRS indices
    qrs_indices = selected_locs;

end
