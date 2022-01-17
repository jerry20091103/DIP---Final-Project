%% INPUT
clear;
close all;

inputOriNoiseImage = (im2single(imread("../Aligned Photos/2-3.png")));
inputBlurImage = (im2single(imread("../Aligned Photos/2-2.png")));
% aspect ratio is 3:2 !!!
inputOriNoiseImage = (inputOriNoiseImage(1201:1800, 1801:2700, :));
inputBlurImage = (inputBlurImage(1216:1815, 1811:2710, :));
% test
test_kernel = ...
    [0 0 0 0 0 0 0 0 0 0 0 0;
     0 1 0 0 0 0 0 0 0 0 0 0;
     0 0 1 0 0 0 0 0 0 0 0 0; 
     0 0 0 1 0 0 0 0 0 0 0 0;
     0 0 0 0 1 0 0 0 0 0 0 0;
     0 0 0 0 0 2 0 0 0 0 0 0;
     0 0 0 0 0 0 1 0 0 0 0 0;
     0 0 0 0 0 0 0 1 0 0 0 0;
     0 0 0 0 0 0 0 0 1 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 1 0;
     0 0 0 0 0 0 0 0 0 0 0 2];
test_kernel = test_kernel ./ sum(sum(test_kernel));
subplot(3, 3, 1); imshow(inputOriNoiseImage); title("original image");
inputBlurImage = imfilter(inputOriNoiseImage, test_kernel, 'conv'); % add artificial blur
inputNoiseImage = imnoise(inputOriNoiseImage, 'gaussian'); % add artificial noise
%inputNoiseImage = inputOriNoiseImage; % not adding artificial noise
subplot(3, 3, 2); imshow(inputNoiseImage); title("noise image");
subplot(3, 3, 3); imshow(inputBlurImage); title("blur image");
iter = 0;

s = psnr(inputNoiseImage, inputOriNoiseImage);
fprintf("PSNR of added Noise image = %f\n", s);
s = psnr(inputBlurImage, inputOriNoiseImage);
fprintf("PSNR of blurred image = %f\n", s);

num_iter = 1;

%% DENOISE
while(num_iter > 0)

iter = iter + 1;
fprintf("Iteration %d\n", iter);
% matlab pretrained NN denoise
net = denoisingNetwork('DnCNN');
[noisyR,noisyG,noisyB] = imsplit(inputNoiseImage);
denoisedR = denoiseImage(noisyR,net);
denoisedG = denoiseImage(noisyG,net);
denoisedB = denoiseImage(noisyB,net);
inputDeNoise = cat(3,denoisedR,denoisedG,denoisedB);
%inputDeNoise = imgaussfilt(inputNoiseImage, 2);
subplot(3, 3, 4); imshow(inputDeNoise); title("denoised image");

%% KERNEL ESTIMATION

% use grayscale for kernel estimation
kernel = estimateKernel(rgb2gray(inputDeNoise), rgb2gray(inputBlurImage), 27, 20);
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

%% DECONVOLUTION 

[result, Id] = residualDeconvolution(inputBlurImage, test_kernel, inputDeNoise, 20);

subplot(3, 3, 7); imshow(result); title("deconv result");

s = psnr(result, inputOriNoiseImage);
fprintf("PSNR = %f\n", s);

num_iter = num_iter - 1;
pause;
% setup variable for next iteration
inputNoiseImage = result;
end




