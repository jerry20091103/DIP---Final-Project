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
subplot(3, 3, 1); imshow(inputNoiseImage); title("original image");
inputBlurImage = imfilter(inputNoiseImage, test_kernel, 'conv'); % add artificial blur
inputNoiseImage = imnoise(inputNoiseImage, 'gaussian'); % add artificial noise
subplot(3, 3, 2); imshow(inputNoiseImage); title("noise image");
subplot(3, 3, 3); imshow(inputBlurImage); title("blur image");
inputDeNoise = imgaussfilt(inputNoiseImage, 2);
subplot(3, 3, 4); imshow(inputDeNoise); title("denoised image");
%% 


% use grayscale for kernel estimation
kernel = estimateKernel(rgb2gray(inputDeNoise), rgb2gray(inputBlurImage), 21, 20)
% filp the kernel
kernel = flipud(fliplr(kernel));

for i = 1:size(kernel, 1)
    for j = 1:size(kernel, 2)
        if kernel(i, j) < 0
            kernel(i, j) = 0;
        end
    end
end
kernel = kernel / sum(sum(kernel));



subplot(3, 3, 5); imshow(kernel); title("kernel");
blur_test = imfilter(inputDeNoise, double(kernel), 'conv');
subplot(3, 3, 6); imshow(blur_test); title("blur the denoised image using estimated kernel");

%% 
[result, Id] = residualDeconvolution(inputBlurImage, kernel, inputDeNoise, 20);
subplot(3, 3, 7); imshow(result); title("deconv result");
subplot(3, 3, 8); imshow(Id);
