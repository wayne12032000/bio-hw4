

    % Load ECG signals
    files = {'ECG3.dat','ECG4.dat','ECG5.dat','ECG6.dat'};
    fs = 200; % Sampling rate

    for i = 1:length(files)
        % Load ECG signal
        ecg = load(files{i});

        % Run Pan-Tompkins algorithm
        [qrs_indices, heart_rate, qrs_width] = panTompkins(ecg, fs);
        
        
        % Plot ECG signal with detected QRS complexes
        t = (0:length(ecg)-1) / fs;
        figure;
        plot(t, ecg, 'b', t(qrs_indices), ecg(qrs_indices), 'ro');
        title(['ECG Signal with QRS Detection - Record ', num2str(i)]);
        xlabel('Time (s)');
        ylabel('ECG Amplitude');
        legend('ECG Signal', 'Detected QRS');

        % Display heart rate and QRS width
        disp(['Record ', num2str(i), ':']);
        disp(['   Average Heart Rate: ', num2str(heart_rate), ' bpm']);
        disp(['   Average QRS Width: ', num2str(qrs_width), ' seconds']);
    end



