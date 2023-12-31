Fs=2000;
t0 = 1/Fs;
theta = cumsum(GYRO_X, 1)*t0;
maxNumM = 100;
L = size(theta, 1);
maxM = 2.^floor(log2(L/2));
m = logspace(log10(1), log10(maxM), maxNumM).';
m = ceil(m); % m must be an integer.
m = unique(m); % Remove duplicates.

tau = m*t0;

avar = zeros(numel(m), 1);
for i = 1:numel(m)
    mi = m(i);
    avar(i,:) = sum( ...
        (theta(1+2*mi:L) - 2*theta(1+mi:L-mi) + theta(1:L-2*mi)).^2, 1);
end
avar = avar ./ (2*tau.^2 .* (L - 2*m));
adev = sqrt(avar);

figure
loglog(tau, adev)
title('Allan Deviation')
xlabel('\tau');
ylabel('\sigma(\tau)')
grid on
axis equal

AngularRandomWalk=ARW(tau,adev)
BiasInstabilityValue=BiasIns(adev)

function Angular = ARW(tau,adev)
closest = find(tau==interp1(tau,tau,1,'nearest'));
Angular=adev(closest)*60;
end
function BiasInstability =BiasIns(value)
[Maxima,MaxIdx] = findpeaks(value);
DataInv = 1.01*max(value) - value;
[Minima,MinIdx] = findpeaks(DataInv);
Minima = value(MinIdx);
BiasInstability=Minima(1)/0.664*3600;
end