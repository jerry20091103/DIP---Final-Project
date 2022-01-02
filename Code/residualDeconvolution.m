function I = residualDeconvolution(B, K, Nd, iter)
    % dB = B - Nd conv K
    dB = B - conv2(Nd, K, 'same');
    
    % calculate total gradient magnitude of gaussian pyramid.
    L = 5;
    gradientTotal = 0;
    NdPyramid = Nd;
    for i = 0 : L
        [Gmag Gdir] = imgradient(NdPyramid);
        gradientTotal = gradientTotal + Gmag;
        NdPyramid = imgaussfilt(NdPyramid, 0.5);
        NdPyramid = imresize(NdPyramid, 0.5);
    end

    % residual deconv with de-ringing
    dI = dB;
    alpha = 0.2;
    Ig = (1 - alpha) + alpha * gradientTotal;
    for i = 1 : (iter - 1)
        dI = Ig * deconvlucy(dI, K, 1);
    end

    % Do not multiply Ig in last iter.
    dI = deconvlucy(dI, K, 1);

    I = Nd + dI;
end