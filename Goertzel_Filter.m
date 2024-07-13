

function magnitude = Goertzel_Filter(signal, sampleRate, targetFreq)
    w = 2 * pi * targetFreq / sampleRate;
    coef = 2*cos(w);

    q1 = 0;
    q2 = 0;

    for n = 1:length(signal)
        q0 = signal(n) + coef * q1 - q2;
        q2 = q1;
        q1 = q0;
    end

    % real = q1 - q2*cos(w);
    % imag = q2*sin(w);
    % magnitude2 = real^2 + imag^2;  

    %Optimized Goertzel
    magnitude = q1^2+q2^2-coef*q2*q1;

end




