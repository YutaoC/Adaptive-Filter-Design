%% plot the four different noises
[pink, Fs_1] = audioread("PinkNoise.wav");
[white, Fs_2] = audioread("WhiteNoise.wav");
[flying, Fs_3] = audioread("FlyingBillboard.wav");
[car, Fs_4] = audioread("DriveinSnow.wav");

figure
subplot(2,2,1)
plot(pink)
title("Pink Noise")
subplot(2,2,2)
plot(white)
title("White Noise")
subplot(2,2,3)
plot(flying)
title("Flying Billboard")
subplot(2,2,4)
plot(car)
title("Drive in Snow")
