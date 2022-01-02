function kernel = estimateKernel(inputNoise, inputBlur, n, iter)
    % params: inputNoise-> noisy image (after denoised) ; inputBlur-> image with motion blur
    %         n-> size of kernel (odd) ; iter-> number of iterations to run
    %         image value: single (0~1)
    % returns: an estimated kernel of size nxn

    %% init kernel as unit impluse
    kernel = single(zeros([n, n]));
    kernel(int32(n/2), int32(n/2)) = 1;
    %% convert to vector-matrix form
    B = inputBlur(:);
    K = kernel(:);
    [r, c] = size(inputNoise);
    % pad the image
    Ip = padarray(inputNoise, [(n+1)/2 - 1, (n+1)/2 - 1], "circular", "both");
    A = single(zeros(r*c, n*n));
    k = 0;
    for j=1:c
        for i=1:r
            k = k+1;
            Ak = Ip(i + (0:n-1), j + (0:n-1));
            A(k, :) = Ak(:)';
        end
    end
    
    %% solve the kernel
    %{
    rate = 1;
    lambda = 5;
    for i = 1:iter
        K = K + rate * (A'*B - (A'*A + lambda^2 * eye(size(A, 2))) * K);
        % set negative value to 0
        for a=1:size(K)
            if K(a) < 0
                K(a) = 0;
            end
        end
        % normalize
        K = K / sum(K);
        
    end
    %}
    K = A\B;
    %% reshape and get the kernel
    kernel = reshape(K, n, n);
end

