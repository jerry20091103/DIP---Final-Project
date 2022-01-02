clear;
close all;

inputNoiseImage = (im2single(imread("../Aligned Photos/2-3.png")));
inputBlurImage = (im2single(imread("../Aligned Photos/2-2.png")));
% aspect ratio is 3:2 !!!
inputNoiseImage = (inputNoiseImage(1201:1800, 1801:2700, :));
inputBlurImage = (inputBlurImage(1216:1815, 1811:2710, :));
% test
test_kernel = ...
    [0 0 0 0 0 2 0 0 0 0 0 0;
     0 0 0 0 0 1 0 0 0 0 0 0;
     0 0 0 0 0 1 0 0 0 0 0 0; 
     0 0 0 0 0 1 0 0 0 0 0 0;
     0 0 0 0 0 1 0 0 0 0 0 0;
     0 0 0 0 0 2 0 0 0 0 0 0;
     0 0 0 0 0 0 1 0 0 0 0 0;
     0 0 0 0 0 0 0 1 0 0 0 0;
     0 0 0 0 0 0 0 0 1 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 1 0;
     0 0 0 0 0 0 0 0 0 0 0 2];
test_kernel = test_kernel ./ sum(sum(test_kernel));
subplot(2, 3, 1); imshow(inputNoiseImage); title("original image");
inputBlurImage = imfilter(inputNoiseImage, test_kernel, 'conv'); % add artificial blur
inputNoiseImage = imnoise(inputNoiseImage, 'gaussian'); % add artificial noise
subplot(2, 3, 2); imshow(inputNoiseImage); title("noise image");
subplot(2, 3, 3); imshow(inputBlurImage); title("blur image");
inputDeNoise = imgaussfilt(inputNoiseImage, 2);
subplot(2, 3, 4); imshow(inputDeNoise); title("denoised image");
pause;

% use grayscale for kernel estimation
kernel = estimateKernel(rgb2gray(inputDeNoise), rgb2gray(inputBlurImage), 21, 20)
% filp the kernel
kernel = flipud(fliplr(kernel));

subplot(2, 3, 5); imshow(kernel); title("kernel");
subplot(2, 3, 6); imshow(imfilter(inputDeNoise, double(kernel), 'conv')); title("blur the denoised image using estimated kernel");
