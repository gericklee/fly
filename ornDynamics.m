%% orn dynamics - differential eqn model of ORN transduction
close all
clear all
clc

%% first order R <-> R*
tLength = 8; % seconds
fs = 1000; % sampling rate (samples per second)
N = tLength * fs; % samples
n = [1 : N].'; % samples
baseline = 10;

stimLeng = 0.5 * fs; % sec * fs
stimInt = 0.5; %intensity (arbitrary units)
numTrial = 6;
fBin = (n - (N / 2)) * (fs / N); % set center to zero, fs/N is freq res. (nyquist is fs/(2N))

odor = zeros(N, 1);
for j = 2 : 2 : floor(stimLeng \ N); % try with 1.2 instead of 3!
    odor(stimLeng * (j - 1) + 1 : j * stimLeng, 1) = stimInt;
end
% odor = repmat(odor, 1, numTrial) * diag(1 : numTrial);

% [ax h1 h2] = plotyy(n, ornDynamicSimWithInactivation(10, N, fs, odor), n, odor);
ornResp = ornDynamicSimWithInactivation(100, N, fs, odor);

figure(1), clf, subplot(3, 1, 1)
plot(n, odor, 'k'), title('Odor')
subplot(3, 1, 2)
plot(n, ornDynamicSim(10, N, fs, odor)), title('No inactivation')
subplot(3, 1, 3), 
plot(n, ornResp * 1000 + 10), title('With inactivation (R <> R* > Ri > R)')
xlabel('time (ms)')
%%
% for j = 2 : 7 : floor(stimLeng \ N);
%     odor(stimLeng * (j - 1) + 1 : j * stimLeng) = stimInt * j; % 0.1 conc. stimulus
% end
% odor = [odor odor odor];

kOn = 1 / fs; % convert to units of samples (larger = faster)
kOff = kOn * 4; % convert to units of samples (larger = faster)

for j = 1 : numTrial
    steadState(j) = max(odor(:, j)) / (max(odor(:, j)) + kOff / kOn);
end
rStar = zeros(N, numTrial);
% figure(1), clf
% subplot(2, 1, 1)
% plot(n, odor, 'k', 'LineWidth', 3)
cMap = viridis(numTrial);
% subplot(2, 1, 2), hold on
for j = 1 : numTrial
    C = 0;
    s = kOn * odor(:, j);
    constantVec = s + kOff;
    rStar(:, j) = (s ./ (s + kOff)) + C * exp(-constantVec .* n);
    rStar(rStar > 1) = 1;
    plot(n, rStar(:, j), 'Color', cMap(j, :), 'LineWidth', 2)
end

%%
% Euler 

rEuler = zeros(N, numTrial);
rEuler(1, :) = 0;
cMap = viridis(numTrial);
for j = 1 : numTrial
    for k = 2 : N
        rStep = kOn * odor(k, j) - (kOn * odor(k, j) + kOff) * rEuler(k - 1, j);
        rEuler(k, j) = rEuler(k - 1, j) + rStep;
    end
end
figure(2), clf
subplot(2, 1, 1)
set(gca, 'ColorOrder', cMap, 'NextPlot', 'replacechildren');
plot(n, odor, 'LineWidth', 2), hold on
subplot(2, 1, 2)
set(gca, 'ColorOrder', cMap, 'NextPlot', 'replacechildren');
plot(n, rEuler);%* inv(diag(steadState)), 'LineWidth', 2);
% figure(3), clf
% test = rEuler(:, 6) / steadState(6) - rEuler(:, 1) / steadState(1);
% plotyy(n, test, n, odor(:, 1))
%% 
func = @(t, R, od) (kOn * od) - (kOff + (kOn * od)) * R;
rTest = zeros(N, 1); rTest(1) = rStar(1);
for j = 2 : N
    rTest(j) = rTest(j - 1) + func(j, rTest(j - 1), odor(j));
end
plot(n, rTest, 'r', 'LineWidth', 1)


%% 
func = @(t, R) (kOn .* odor(t)) - (kOff + (kOn .* odor(t))) * R;
rTest = zeros(N, 1); rTest(1) = rStar(1);
for j = 2 : N
    rTest(j) = rTest(j - 1) + func(j, rTest(j - 1));
end
plot(n, rTest, 'Color', [1 0.15 0.7], 'LineWidth', 3)
[t1, r1] = ode45(func, [n], rStar(1));














%% System of eqns: R <-> R* <-> Ri



% arbitrary system of linear eqns
fun = @(t, x) [5 * x(1) - x(2); 3 * x(1) + x(2)];
[t1, x1] = ode45(fun, [0 : 0.5 : 10], [2 -1]);
figure(2)
plot(x1(:, 1), x1(:, 2))


test = -1.5 * exp(2 * t1) + 3.5 * exp(4 * t1);












%%
ratioVec = 0.25 : 0.5 : 6;
sTest = zeros(N, length(ratioVec));
for k = 1 : length(ratioVec)
for j = 1 : N
    sTest(j, k) = j / (j + (ratioVec(k)));
end
end
set(gca, 'ColorOrder', viridis(k), 'NextPlot', 'replacechildren');
semilogx(n, sTest)
legend(num2str(ratioVec'))
axis([0 10000 0 1])
axis square
