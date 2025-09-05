% 初始化
clear;
clc;

dim = 6; % 哈达玛矩阵的维度
matrix_size = 2^dim;  % 矩阵的行/列数

% 生成沃尔什-哈达玛矩阵
H = Natural_Hadamard_Transform(dim);

% 正负哈达玛矩阵
H_p = (H + 1) / 2;  % Positive Hadamard patterns
H_n = (1 - H) / 2;  % Negative Hadamard patterns

% 初始化结果矩阵的存储
total_matrices = matrix_size^2;  % 总共生成的矩阵数量是 4096
H_p_matrices = cell(total_matrices, 1);  % 存储正哈达玛矩阵
H_n_matrices = cell(total_matrices, 1);  % 存储负哈达玛矩阵

% 初始化行列索引的存储
row_col_indices = cell(matrix_size, 1);  % 存储每次随机选择的行列索引

% 获取所有点的线性索引
all_points = randperm(total_matrices);  % 随机排列所有的4096个点

% 生成 64 次随机取点的矩阵，每次取 64 个点
for iter = 1:matrix_size
    % 获取当前迭代中随机选择的64个不重复的点
    indices = all_points((iter-1)*matrix_size + 1 : iter*matrix_size);
    
    % 将这些索引转换为矩阵的行列坐标
    [row_indices, col_indices] = ind2sub([matrix_size, matrix_size], indices);
    
    % 保存当前迭代的行列坐标
    row_col_indices{iter} = [row_indices, col_indices];

    % 遍历哈达玛矩阵的每一行
    for i = 1:matrix_size
        % 生成新的 matrix_size×matrix_size 的随机点矩阵
        random_matrix_p = zeros(matrix_size, matrix_size);
        random_matrix_n = zeros(matrix_size, matrix_size);
        
        % 将 H_p 和 H_n 的第 i 行的值赋给这些随机点
        random_matrix_p(sub2ind([matrix_size, matrix_size], row_indices, col_indices)) = H_p(i, :);  
        random_matrix_n(sub2ind([matrix_size, matrix_size], row_indices, col_indices)) = H_n(i, :);  
        
        % 保存生成的矩阵
        index = (iter-1)*matrix_size + i;  % 计算全局索引
        H_p_matrices{index} = random_matrix_p;
        H_n_matrices{index} = random_matrix_n;
    end
end

% 设置输出文件夹路径
output_folder = 'C:\Users\hyy\Documents\MATLAB\Algorithm_GI\hadmard_GI\simulation_all\illimination_field\Random_Discrete_Hadamard_Postive_and_Negetive_matrix_64_H';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);  % 如果文件夹不存在，则创建
end

% 保存生成的矩阵为图像
disp('开始保存随机正负哈达玛矩阵图像...');
save_matrices_as_images(H_p_matrices, output_folder, 'matrix_P_random_64');  % 保存正哈达玛矩阵图像
save_matrices_as_images(H_n_matrices, output_folder, 'matrix_N_random_64');  % 保存负哈达玛矩阵图像
disp('所有随机矩阵图像已保存到指定目录。');

% 保存行列索引数据
indices_file = fullfile(output_folder, 'row_col_indices.mat');
save(indices_file, 'row_col_indices');  % 将行列索引保存为 .mat 文件
disp('行列索引已保存到指定目录。');

%% 辅助函数定义

% 保存矩阵为图像的辅助函数
function save_matrices_as_images(matrices, output_folder, prefix)
    num_matrices = numel(matrices);  % 获取矩阵的数量
    for i = 1:num_matrices
        matrix = matrices{i};  % 获取当前矩阵
        img = uint8(255 * mat2gray(matrix));  % 将矩阵转换为 uint8 图像
        filename = fullfile(output_folder, sprintf('%s_%d.png', prefix, i));  % 生成文件名
        imwrite(img, filename);  % 保存图像
    end
end