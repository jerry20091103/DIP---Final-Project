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
    dI = dB;
    I = deconvlucy(dI, K, 20);

    % residual deconv with de-ringing
    dI = dB;
    alpha = 0.5;
    Ig = (1 - alpha) + alpha * gradientTotal;
    for i = 1 : (iter - 1)
        dI = Ig .* deconvlucy(dI, K, 1);
    end

    % Do not multiply Ig in last iter.
    dI = deconvlucy(dI, K, 1);

    Igain = Nd + dI;

    % add details
    Id = I - imbilatfilt(I, 0.08, 1.6);
    res = Igain + Id;

end