clear;
close all;

inputNoiseImage = (im2single(imread("../Aligned Photos/2-1.png")));
inputBlurImage = (im2single(imread("../Aligned Photos/2-2.png")));
% aspect ratio is 3:2 !!!
inputNoiseImage = rgb2gray(imresize(inputNoiseImage, [2000, 3000]));
inputBlurImage = rgb2gray(imresize(inputBlurImage, [2000, 3000]));
% test
%test_kernel = [0 0 0 0 0 0 1; 0 0 0 0 0 1 0; 0 0 0 0 1 0 0; 0 0 0 1 0 0 0; 0 0 1 0 0 0 0; 0 1 0 0 0 0 0; 0 0 0 0 0 0 0];
%test_kernel = test_kernel ./ sum(sum(test_kernel));
%inputBlurImage = conv2(inputNoiseImage, test_kernel, "same");
subplot(2, 2, 1); imshow(inputNoiseImage);
subplot(2, 2, 2); imshow(inputBlurImage);
net = denoisingNetwork('DnCNN');
inputDeNoise = denoiseImage(inputNoiseImage, net);
subplot(2, 2, 3); imshow(inputDeNoise);

kernel = estimateKernel(inputDeNoise, (inputBlurImage), 11, 30)
subplot(2, 2, 4); imshow(kernel);
