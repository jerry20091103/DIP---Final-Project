function kernel = estimateKernel(inputNoise, inputBlur, n, iter)
    % init kernel as unit impluse
    kernel = zeros([n, n]);
    kernel(int32(n/2), int32(n/2)) = 1;
    rate = 1;
    lambda = 5;
    % update the kernel
    for i = 1:iter
        kernel = kernel + rate * (inputNoise.' * inputBlur - (inputNoise.' * inputNoise + lambda^2 * eye(size(inputNoise, 2))) * kernel);
        % set negative value to 0
        for a = 1:n
            for b = 1:n
                if kernel(a, b) < 0
                    kernel(a, b) = 0;
                end
            end
        end
        % normalize
        kernel = kernel / sum(sum(kernel));
    end
end

