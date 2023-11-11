function runPanTompkinssleep()

    % Load and analyze ECG signals
    files = {'ECG_Wake.mat', 'ECG_N2.mat', 'ECG_N3.mat', 'ECG_REM.mat'};
    fs_original = 512; % Original sampling rate
    fs_downsampled = 200; % Target downsampled rate

    for i = 1:length(files)
        % Load ECG signal
        file_path = files{i};
        if endsWith(file_path, '.mat')
            data = load(file_path);
            field_names = fieldnames(data);
            % Assuming there is only one field in the structure, use that field
            ecg = data.(field_names{1});
        elseif endsWith(file_path, '.csv')
            ecg = csvread(file_path);
        else
            error('Unsupported file format. Use .mat or .csv files.');
        end

        ecg_downsampled = resample(ecg, fs_downsampled, fs_original);

        % Run Pan-Tompkins algorithm
        [qrs_indices, heart_rate, qrs_width] = panTompkins(ecg_downsampled, fs_downsampled);

        % Plot ECG signal with detected QRS complexes
        t = (0:length(ecg_downsampled)-1) / fs_downsampled;
        figure;
        plot(t, ecg_downsampled, 'b', t(qrs_indices), ecg_downsampled(qrs_indices), 'ro');
        title(['ECG Signal with QRS Detection - ', strrep(file_path, '_', ' ')]); % Remove underscores for better title
        xlabel('Time (s)');
        ylabel('ECG Amplitude');
        legend('ECG Signal', 'Detected QRS');

        % Display heart rate and QRS width
        disp(['File: ', file_path]);
        disp(['   Average Heart Rate: ', num2str(heart_rate), ' bpm']);
        disp(['   Average QRS Width: ', num2str(qrs_width), ' seconds']);
    end
end

% Rest of the code (panTompkins, bandpassFilter) remains the same
