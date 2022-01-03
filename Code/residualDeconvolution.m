function [res, Id] = residualDeconvolution(B, K, Nd, iter)
    % dB = B - Nd conv K
    dB = B - imfilter(Nd, double(K), 'conv');
    
    % calculate total gradient magnitude of gaussian pyramid.
    L = 0;
    gradientTotal = zeros(size(B));
    NdPyramid = rgb2gray(Nd);
    for i = 0 : L
        [Gmag Gdir] = imgradient(NdPyramid);
        gradientTotal = gradientTotal + Gmag;
        NdPyramid = imgaussfilt(NdPyramid, 0.5);
        NdPyramid = imresize(NdPyramid, 0.5);
    end
    % residual deconv without de-ringing
    I = dB;
    for i = 1:iter
        I = imfilter((dB+1) ./ imfilter((I+1), double(K), 'conv'), double(K)) .* (I+1) - 1;
    end

    % residual deconv with de-ringing
    dI = dB;
    alpha = 0.2;
    Ig = (1 - alpha) + alpha * gradientTotal;
    for i = 1 : (iter - 1)
        dI = Ig .* (imfilter((dB+1) ./ imfilter((dI+1), double(K), 'conv'), double(K)) .* (dI+1) - 1);
    end

    % Do not multiply Ig in last iter.
    dI = imfilter((dB+1) ./ imfilter((dI+1), double(K), 'conv'), double(K)) .* (dI+1) - 1;

    Igain = Nd + dI;

    % add details
    Id = I - imbilatfilt(I, 0.5, 1.6);
    res = Igain + Id;

end