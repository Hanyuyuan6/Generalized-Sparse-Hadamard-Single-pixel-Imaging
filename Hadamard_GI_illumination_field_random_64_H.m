clc;  % 清空命令行窗口
close all;  % 关闭所有打开的图形窗口
clearvars;  % 清除工作区中的所有变量
load row_col_indices_random_64  % 加载行列索引

%% 1. 加载与预处理图像
obj = imread('Cameraman_256.bmp');  % 加载目标图像（摄像机人图像）
samplingFactor = 4;  % 设置采样因子
obj = double(obj(1:samplingFactor:end, 1:samplingFactor:end));  % 进行亚采样
obj = obj / max(obj(:));  % 将图像归一化到[0, 1]
npixels = size(obj, 1);  % 获取图像大小

fprintf('图像大小: %d 像素\n', npixels);  % 打印图像大小

%% 2. 生成Hadamard矩阵
dim = 6;  % 哈达玛矩阵的维度
Ht = Natural_Hadamard_Transform(dim);  % 生成Hadamard矩阵
Ht_inv = inv(Ht);  % 提前计算Hadamard矩阵的逆，减少重复计算

% 可视化Hadamard矩阵
figure(1);
imagesc(Ht); colormap('gray'); title('Hadamard矩阵');

%% 3. 加载照明模式图像
folderPath = 'C:\Users\hyy\Documents\MATLAB\Algorithm_GI\hadmard_GI\simulation_all\illimination_field\Random_Discrete_Hadamard_Postive_and_Negetive_matrix_64_H';
imageFiles = dir(fullfile(folderPath, '*.png'));
numImages = length(imageFiles);  % 动态获取图像数量

% 初始化正负Hadamard矩阵图像的cell数组
imageData_P = cell(1, numImages/2);
imageData_N = cell(1, numImages/2);

% 读取图像并分类存储
for i = 1:numImages
    imagePath = fullfile(folderPath, imageFiles(i).name);
    img = im2double(imread(imagePath));  % 读取并归一化图像
    img = handle_special_image_cases(img);  % 处理全黑全白图像

    % 根据文件名判断是正还是负Hadamard矩阵图像
    if contains(imageFiles(i).name, 'matrix_P_random_64')
        idx = sscanf(imageFiles(i).name, 'matrix_P_random_64_%d.png');
        imageData_P{idx} = img;
    elseif contains(imageFiles(i).name, 'matrix_N_random_64')
        idx = sscanf(imageFiles(i).name, 'matrix_N_random_64_%d.png');
        imageData_N{idx} = img;
    end
end

%% 4. 进行鬼成像
fprintf('进行鬼成像处理...\n');
B_P = perform_ghost_imaging(obj, imageData_P);
B_N = perform_ghost_imaging(obj, imageData_N);

% 无噪声重建
target = reconstruct_image(B_P - B_N, Ht_inv, row_col_indices, npixels, dim);

%% 5. 噪声场景下的鬼成像重建
snr = 20;  % 设置信噪比
B_P_Noise = awgn(B_P, snr, 'measured');  % 向正Hadamard矩阵桶探测强度添加噪声
B_N_Noise = awgn(B_N, snr, 'measured');  % 向负Hadamard矩阵桶探测强度添加噪声

% 有噪声重建
target_Noise = reconstruct_image(B_P_Noise - B_N_Noise, Ht_inv, row_col_indices, npixels, dim);

%% 6. 显示重建结果
fprintf('显示重建结果...\n');
figure(2);
subplot(2, 3, 1); imagesc(obj); colormap('gray'); title('原始图像');
subplot(2, 3, 2); imagesc(target); colormap('gray'); title('无噪声重建结果');
subplot(2, 3, 3); imagesc(target_Noise); colormap('gray'); title('有噪声重建结果');

%% 7. 计算和显示PSNR
psnr_values = [
    Inf, ...  % 原始图像PSNR设为无穷大或最大可能值
    calculate_psnr(obj, target),...
    calculate_psnr(obj, target_Noise)
];

labels = {'原始图像PSNR', '无噪声重建PSNR', '有噪声重建PSNR'};
display_psnr_results(labels, psnr_values);

%% 辅助函数定义

% 处理全黑或全白图像的函数
function img = handle_special_image_cases(img)
    if all(img(:) == 1)
        img = ones(size(img));  % 全白图像
    elseif all(img(:) == 0)
        img = zeros(size(img));  % 全黑图像
    end
end

% 进行鬼成像的函数
function B = perform_ghost_imaging(obj, imageData)
    k = length(imageData);
    B = zeros(1, k);
    for i = 1:k
        illumination_M_i = imageData{i};
        In_obj = illumination_M_i .* obj;
        B(i) = sum(In_obj(:));  % 计算每个模式下的总强度
    end
end

% 重建图像的函数
function target = reconstruct_image(B, Ht_inv, row_col_indices, npixels, dim)
    target = zeros(npixels, npixels);
    
    for i = 1:(npixels^2/(2^dim))
        % 获取当前行的随机索引
        current_indices = row_col_indices{i};
        row_indices = current_indices(1:2^dim);  % 行索引
        col_indices = current_indices(2^dim+1:end);  % 列索引
        
        % Hadamard逆变换重建
        B_tem = B((i-1)*2^dim + 1 : i*2^dim);
        for_target_tem = Ht_inv * B_tem';  % 使用提前计算的逆矩阵

        % 更新目标图像中的元素
        target(sub2ind([npixels, npixels], row_indices, col_indices)) = for_target_tem;
    end
end

% 显示PSNR结果的函数
function display_psnr_results(labels, psnr_values)
    for i = 1:length(psnr_values)
        subplot(2, 3, 3 + i);
        text(0.1, 0.5, sprintf('%s: %.2f dB', labels{i}, psnr_values(i)), 'FontSize', 12);
        axis off;
    end
end