clc;
close all;
clearvars;

% Load row/col indices from current project folder
load(fullfile(pwd, 'data', 'Random_Discrete_Hadamard_Postive_and_Negetive_matrix_64_H', 'row_col_indices.mat'), 'row_col_indices');

%% 1) Load and preprocess image
obj = imread('Cameraman_256.bmp');
samplingFactor = 4;
obj = double(obj(1:samplingFactor:end, 1:samplingFactor:end));
obj = obj / max(obj(:));
npixels = size(obj, 1);

fprintf('Image size: %d pixels\n', npixels);

%% 2) Hadamard matrix
dim = 6;
Ht = Natural_Hadamard_Transform(dim);
Ht_inv = inv(Ht); 

figure(1);
imagesc(Ht); colormap('gray'); title('Hadamard Matrix');

%% 3) Load illumination patterns (PNG)
folderPath = fullfile(pwd, 'data', 'Random_Discrete_Hadamard_Postive_and_Negetive_matrix_64_H');
imageFiles = dir(fullfile(folderPath, '*.png'));
numImages = length(imageFiles);

imageData_P = cell(1, numImages/2);
imageData_N = cell(1, numImages/2);

for i = 1:numImages
    imagePath = fullfile(folderPath, imageFiles(i).name);
    img = im2double(imread(imagePath));
    img = handle_special_image_cases(img);

    if contains(imageFiles(i).name, 'matrix_P_random_64')
        idx = sscanf(imageFiles(i).name, 'matrix_P_random_64_%d.png');
        imageData_P{idx} = img;
    elseif contains(imageFiles(i).name, 'matrix_N_random_64')
        idx = sscanf(imageFiles(i).name, 'matrix_N_random_64_%d.png');
        imageData_N{idx} = img;
    end
end

%% 4) Single-pixel imaging sampling 
fprintf('Running single-pixel imaging (SPI)...\n');
S_P = perform_single_pixel_imaging(obj, imageData_P);
S_N = perform_single_pixel_imaging(obj, imageData_N);

S_diff = S_P - S_N;
target = reconstruct_image(S_diff, Ht_inv, row_col_indices, npixels, dim);

%% 5) Noisy reconstruction
snr = 20;
S_P_Noise = awgn(S_P, snr, 'measured');
S_N_Noise = awgn(S_N, snr, 'measured');

S_diff_Noise = S_P_Noise - S_N_Noise;
target_Noise = reconstruct_image(S_diff_Noise, Ht_inv, row_col_indices, npixels, dim);

%% 6) Show results
fprintf('Displaying results...\n');
figure(2);
subplot(2, 3, 1); imagesc(obj); colormap('gray'); title('Original');
subplot(2, 3, 2); imagesc(target); colormap('gray'); title('Reconstruction (clean)');
subplot(2, 3, 3); imagesc(target_Noise); colormap('gray'); title('Reconstruction (noisy)');

%% 7) PSNR 
psnr_values = [
    Inf, ...
    psnr(target, obj), ...
    psnr(target_Noise, obj)
];

labels = {'Original PSNR', 'Clean PSNR', 'Noisy PSNR'};
display_psnr_results(labels, psnr_values);

%% 

function img = handle_special_image_cases(img)
    if all(img(:) == 1)
        img = ones(size(img));
    elseif all(img(:) == 0)
        img = zeros(size(img));
    end
end

% SPI measurement
function S = perform_single_pixel_imaging(obj, imageData)
    k = length(imageData);
    S = zeros(1, k);
    for i = 1:k
        In_obj = imageData{i} .* obj;
        S(i) = sum(In_obj(:));
    end
end

% SHSI
function target = reconstruct_image(S, Ht_inv, row_col_indices, npixels, dim)
    target = zeros(npixels, npixels);
    for i = 1:(npixels^2/(2^dim))
        current_indices = row_col_indices{i};
        row_indices = current_indices(1:2^dim);
        col_indices = current_indices(2^dim+1:end);
        S_block = S((i-1)*2^dim + 1 : i*2^dim);
        block_vals = Ht_inv * S_block';
        target(sub2ind([npixels, npixels], row_indices, col_indices)) = block_vals;
    end
end

function display_psnr_results(labels, psnr_values)
    for i = 1:length(psnr_values)
        subplot(2, 3, 3 + i);
        text(0.1, 0.5, sprintf('%s: %.2f dB', labels{i}, psnr_values(i)), 'FontSize', 12);
        axis off;
    end
end