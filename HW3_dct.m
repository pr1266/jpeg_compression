function out = HW3_dct(I, K, T)
    [row, col] = size(I);
    if mod(row, K) ~= 0
        n = K;
        row_padding = n - mod(row, n);
        col_padding = n - mod(col, n);
        
        for i = 1:row
            for j = 1:col
                pad_image(i + row_padding, j + col_padding) = I(i,j);  
            end
        end

        for i = 1:row_padding
              pad_image(i,:) = pad_image(i + row_padding,:);
        end

        for j = 1:col_padding
              pad_image(:,j) = pad_image(:,j + col_padding);
        end

        I = pad_image;
    end
    
    df = zeros(row, col);
    dff = df;
    
    s = 0;
    for i=1:K:row
        for j=1:K:col        
            f = I(i:i+K-1,j:j+K-1);            
            temp = dct2(f);
            s = s + sum(abs(temp(:)) < T);
            temp(abs(temp) < T) = 0;
            
            %DCT
            df(i:i+K-1,j:j+K-1) = temp;
            %DCT Inverse
            dff(i:i+K-1,j:j+K-1) = idct2(temp);
                    
        end
    end
    disp(size(s));
    disp(s/numel(I));
    figure;
    imshow(I, []);

    figure;
    imshow(dff, []);
    
    %% mse
    mse = sum(sum(double(I)-dff).^2)/numel(I);
    fprintf("mse : %f\n", mse);
    %% psnr
    psnr = 10 * log10(1/mse);
    fprintf("psnr : %f\n", psnr);
    out = 0;
end