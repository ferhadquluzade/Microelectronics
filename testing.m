function testing()

    freqsin = [5000, 149000, 150000, 151000, 200000];
    freqrect = [10000, 16000, 150000, 200000];
    freqtriangle = [5000, 149000, 150000, 151000, 200000];    
    all_frequencies = {freqsin, freqrect, freqtriangle};
    degrees = [0, 30, 45, 90, 120];
    wave_names = ["Sine", "Square", "Triangle"];
    input_bit = 12;

    sample_rate = 4000000;
    target_freq = 150000;
    N = 135;
    t = 0:1/sample_rate:(N-1)/sample_rate;



    sinwave_magnitudes = zeros(length(freqsin), length(degrees));
    squarewave_magnitudes = zeros(length(freqrect), length(degrees));
    trianglewave_magnitudes = zeros(length(freqtriangle), length(degrees));

    all_magnitudes = {sinwave_magnitudes, squarewave_magnitudes, trianglewave_magnitudes};




    for k = 1:length(all_frequencies)
        frequencies = all_frequencies{k};
        wave_magnitudes = all_magnitudes{k};
        wave_name = wave_names(k);

        for i = 1:length(degrees)
            for j = 1:length(frequencies)

                deg = degrees(i);
                freq = frequencies(j);

                sinewave = sin(2*pi*freq*t + deg2rad(deg))*(2^input_bit-1);
                squarewave = square(2*pi*freq*t + deg2rad(deg))*(2^input_bit-1);
                trianglewave = sawtooth(2*pi*freq*t + deg2rad(deg))*(2^input_bit-1);
                

                all_waves = {sinewave, squarewave, trianglewave};

                wave_magnitudes(j, i) = Goertzel_Filter( all_waves{k}, sample_rate, target_freq);
                save_to_file("input", wave_name, freq, deg, all_waves{k});
                save_to_file("result", wave_name, freq, deg, wave_magnitudes(j, i)); 

            end
        end

        subplot(3,1,k)
        bar(wave_magnitudes, 'grouped');
        hold on
        title("Magnitudes for " + wave_name + " Waves");
        legendInfo = arrayfun(@(deg) [num2str(deg), ' Degree'], degrees, 'UniformOutput', false);
        legend(legendInfo, "Location", "bestoutside");
        xticklabels(arrayfun(@num2str, frequencies, 'UniformOutput', false));
    end
end



function save_to_file(folder_name, wave_name, freq, degree, data)

    if ~exist(folder_name, 'dir')
        mkdir(folder_name);
    end

    filename = sprintf('%s/%s_%ddegree_%dHz.txt', folder_name, lower(wave_name), degree, freq);
     
    if exist(filename, 'file')
        delete(filename);
    end

    fileID = fopen(filename, 'w');
    fprintf(fileID, '%d\n', uint16(round(data)));
    fclose(fileID);

end


