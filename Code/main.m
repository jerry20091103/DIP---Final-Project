clear;
close all;

inputNoiseImage = (im2single(imread("../Aligned Photos/2-1.png")));
inputBlurImage = (im2single(imread("../Aligned Photos/2-2.png")));
% aspect ratio is 3:2 !!!
inputNoiseImage = rgb2gray(inputNoiseImage(1201:1800, 1801:2700, :));
inputBlurImage = rgb2gray(inputBlurImage(1201:1800, 1801:2700, :));
% test
test_kernel = eye(13);
test_kernel = test_kernel ./ sum(sum(test_kernel));
inputBlurImage = conv2(inputNoiseImage, test_kernel, "same");
subplot(2, 3, 1); imshow(inputNoiseImage); title("noise image");
subplot(2, 3, 2); imshow(inputBlurImage); title("blur image");
inputDeNoise = imgaussfilt(inputNoiseImage, 1);
subplot(2, 3, 3); imshow(inputDeNoise); title("denoised image");

kernel = estimateKernel(inputDeNoise, (inputBlurImage), 17, 30)
subplot(2, 3, 4); imshow(kernel); title("kernel");
subplot(2, 3, 5); imshow(conv2(inputDeNoise, kernel, "same")); title("blur the denoised image using estimated kernel");
