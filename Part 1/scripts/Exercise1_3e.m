clear; clc;
load('../../font_sizes.mat');

sampling_frequency = 1;
overlap_samples = 0;
signal_lengths = [15, 30, 80];
num_of_trials = 100;


for i = 1: length(signal_lengths)
    current_signal_length = signal_lengths(i);
    n = (0: current_signal_length-1);
    exponentials = exp(1j*2*pi*0.3*n)+exp(1j*2*pi*0.32*n);
    for j = 1: num_of_trials
        noise = 0.2/sqrt(2)*(randn(size(n))+1j*randn(size(n)));
        x = exponentials + noise;
        [X,R] = corrmtx(x,14,'mod');
        [S{i,j},F{i,j}] = pmusic(R,2,[ ],1,'corr');
    end
%     PSDs_sum = sum(S{i, :});
    mean_PSD{i} = mean(cell2mat(S(i,:)), 2);
    PSDs_std{i} = std(cell2mat(S(i,:)), [], 2);
end


figure;
for i = 1: length(signal_lengths)
    subplot(length(signal_lengths), 2, (2*i)-1)
    current_signal_length = signal_lengths(i);
    for j = 1: num_of_trials
        if j == 1
            plot(F{i,j}, S{i,j}, 'Color',	'#4DBEEE', 'DisplayName', 'Individual Realisations');
        else
            plot(F{i,j}, S{i,j}, 'Color', '#4DBEEE', 'HandleVisibility', 'off');
        end
        hold on;
    end
    plot(F{i,1}, mean_PSD{i}, 'LineWidth', 3, 'Color', 'r', 'DisplayName', 'Mean');
    set(gca,'xlim',[0.25 0.40]);
    grid on; grid minor;
    title(sprintf('MUSIC Pseudospectrum (%i samples)', current_signal_length), 'FontSize', title_font);
    xlabel('Frequency (Hz)');
    ylabel('Pseudospectrum');
    set(gca,'FontSize', axes_font);
    legend('FontSize', legend_font);

    subplot(length(signal_lengths), 2, (2*i))
    plot(F{i,1}, PSDs_std{i}, 'LineWidth', 3);
    set(gca,'xlim',[0.25 0.40]);
    grid on; grid minor;
    title(sprintf('MUSIC Pseudospectrum Standard Deviation (%i samples)', current_signal_length), 'FontSize', title_font);
    xlabel('Frequency (Hz)');
    ylabel('Pseudospectrum');
    set(gca,'FontSize', axes_font);
end

