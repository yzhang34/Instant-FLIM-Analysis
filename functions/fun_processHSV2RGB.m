function [ rgb_stack ] = fun_processHSV2RGB(I_stack, Imin, Imax, tau_stack, MinL, MaxL)
%FUN_SOSALGORITHM Summary of this function goes here
%   Detailed explanation goes here


hue_max = 0.7;
hue_min = 0;


                    
[n_x,n_y,n_slice] = size(tau_stack);
rgb_stack = zeros(n_x,n_y,3,n_slice);

tau_stack = mat2gray(tau_stack, [MinL MaxL]);
I_stack = mat2gray(I_stack,[Imin Imax]);


for i_slice = 1:n_slice
    % intensity
    gray_I_image = I_stack(:,:,i_slice);

    % lifetime
    gray_tau_image = hue_max + tau_stack(:,:,i_slice) * (hue_min - hue_max); % maybe need to change?


    % combine lifetime with image
    hsv_image = zeros([size(gray_tau_image) 3]);
    hsv_image(:,:,1) = gray_tau_image; % hue
    hsv_image(:,:,2) = ones(size(gray_tau_image)); % saturation
    hsv_image(:,:,3) = gray_I_image; % value
    rgb_stack(:,:,:,i_slice) = hsv2rgb(hsv_image);
end


end

