% Initialize
clear;
clc;

dim = 6;                        % Hadamard dimension
matrix_size = 2^dim;            % N

% Generate Hadamard matrix
H = Natural_Hadamard_Transform(dim);

% Positive/negative patterns (0/1)
H_p = (H + 1) / 2;
H_n = (1 - H) / 2;

% Storage
total_matrices = matrix_size^2;         % 4096
H_p_matrices = cell(total_matrices, 1);
H_n_matrices = cell(total_matrices, 1);

% Store per-iteration row/col indices 
row_col_indices = cell(matrix_size, 1);

% Random permutation of all N^2 pixel indices
all_points = randperm(total_matrices);

% Generate 64 groups; each group selects 64 unique pixels
for iter = 1:matrix_size
    indices = all_points((iter-1)*matrix_size + 1 : iter*matrix_size);
    [row_indices, col_indices] = ind2sub([matrix_size, matrix_size], indices);
    row_col_indices{iter} = [row_indices, col_indices];

    % For each Hadamard row, place its N values onto the selected pixels
    for i = 1:matrix_size
        random_matrix_p = zeros(matrix_size, matrix_size);
        random_matrix_n = zeros(matrix_size, matrix_size);

        random_matrix_p(sub2ind([matrix_size, matrix_size], row_indices, col_indices)) = H_p(i, :);
        random_matrix_n(sub2ind([matrix_size, matrix_size], row_indices, col_indices)) = H_n(i, :);

        index = (iter-1)*matrix_size + i;
        H_p_matrices{index} = random_matrix_p;
        H_n_matrices{index} = random_matrix_n;
    end
end

% Output directory (current working directory)
output_folder = fullfile(pwd, 'data', 'Random_Discrete_Hadamard_Postive_and_Negetive_matrix_64_H');
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Save PNG images
disp('Saving positive/negative Hadamard pattern images...');
save_matrices_as_images(H_p_matrices, output_folder, 'matrix_P_random_64');
save_matrices_as_images(H_n_matrices, output_folder, 'matrix_N_random_64');
disp('All pattern images saved.');

% Save row/col indices
indices_file = fullfile(output_folder, 'row_col_indices.mat');
save(indices_file, 'row_col_indices');
disp('row_col_indices saved.');

%% Helper

function save_matrices_as_images(matrices, output_folder, prefix)
    num_matrices = numel(matrices);
    for i = 1:num_matrices
        img = uint8(255 * mat2gray(matrices{i}));
        filename = fullfile(output_folder, sprintf('%s_%d.png', prefix, i));
        imwrite(img, filename);
    end
end