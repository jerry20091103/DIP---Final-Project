clear;
close all;

inputNoiseImage = (im2single(imread("../Aligned Photos/2-1.png")));
inputBlurImage = (im2single(imread("../Aligned Photos/2-2.png")));
% aspect ratio is 3:2 !!!
inputNoiseImage = rgb2gray(imresize(inputNoiseImage, [2000, 3000]));
inputBlurImage = rgb2gray(imresize(inputBlurImage, [2000, 3000]));
%kernel = estimateKernel(rgb2gray(inputNoiseImage), rgb2gray(inputBlurImage), 65, 10);
%imshow(kenel);
h = fft2(inputBlurImage) ./ fft2(inputNoiseImage);
k = ifft2(h);
for i = 1:size(k, 1)
    for j = 2:size(k, 2)
        if k(i, j) < 0
            k(i, j) = 0;
        end
    end
end
k = k ./ sum(sum(k));

imshow(k);

%imshow(imfilter(inputNoiseImage, [0 0 0 0; 0 0 1 0; 0 0 0 0; 0 0 0 0], 'conv'));

