function [magnitude, X_final, Y_final] = gradient_magnitude(im_input, sigma)

% im = imread(im_input);
im = double(rgb2gray(im_input))/255;

% Determine filter length
filterLength = 8*ceil(sigma);
n = (filterLength - 1)/2;
x = -n:n;

%Create 1D Gaussian Kernel
gaussKernel = (1/(sqrt(2*pi)*sigma)) * exp(-(x.^2)/(2*sigma^2));

%Normalize kernel to make all values sum to one
gaussKernel = gaussKernel/sum(gaussKernel);

%Take Derivative of Gaussian Kernel in 1D
derivGaussKernel = gradient(gaussKernel);

% Normalize to ensure kernel sums to zero
negVals = derivGaussKernel < 0;
posVals = derivGaussKernel > 0;
derivGaussKernel(posVals) = derivGaussKernel(posVals)/sum(derivGaussKernel(posVals));
derivGaussKernel(negVals) = derivGaussKernel(negVals)/abs(sum(derivGaussKernel(negVals)));

X = imfilter(im, gaussKernel', 'conv', 'replicate');
X_final = imfilter(X, derivGaussKernel, 'conv', 'replicate');

Y = imfilter(im, gaussKernel, 'conv', 'replicate');
Y_final  = imfilter(Y, derivGaussKernel', 'conv', 'replicate');

magnitude = hypot(X_final, Y_final);
imshow(magnitude);

end