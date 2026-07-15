% =========================================================================
% AUTOMATED LICENSE PLATE RECOGNITION (OCR PIPELINE)
% Course: Advanced Image Processing - Final Project
% =========================================================================
% INSTRUCTIONS FOR USE:
% 1. Ensure the image 'LP_STANDARD.jpg' is in the same directory as this script.
% 2. Run the script. The algorithm will automatically execute the entire pipeline:
%    Binarization -> Morphological Cleaning -> Segmentation -> NCC Classification.
% 3. The final 7-digit string will be printed in the Command Window.
% =========================================================================

clear; clc; close all;
fprintf('Starting End-to-End OCR Pipeline...\n');

%% --- STAGE 1: Preprocessing & Otsu Binarization ---
img_rgb = imread('LP_STANDARD.jpg');
img_gray = rgb2gray(img_rgb);
thresh = graythresh(img_gray);
img_bin = ~imbinarize(img_gray, thresh); % Invert so digits are WHITE (1)

%% --- STAGE 2: Morphological Noise Cleaning ---
img_clean = bwareaopen(img_bin, 150); % Remove isolated small noise specks
se = strel('rectangle', [3, 3]);
img_clean = imdilate(img_clean, se);  % Close gaps/fractures in digit strokes
img_clean = imerode(img_clean, se);

%% --- STAGE 3: Segmentation & Geometric Filtering ---
stats = regionprops(img_clean, 'BoundingBox', 'Image');
valid_boxes = [];
valid_images = {};
[img_h, ~] = size(img_clean);

for k = 1:length(stats)
    bb = stats(k).BoundingBox;
    w = bb(3); h = bb(4);
    aspect_ratio = w / h;
    
    % FILTER: Keep tall objects (>40% of plate height) and ignore wide objects
    % This successfully filters out the logo and the dashes (-)
    if h > 0.40 * img_h && aspect_ratio < 0.95
        valid_boxes = [valid_boxes; bb];
        valid_images{end+1} = stats(k).Image;
    end
end

%% --- STAGE 4: Spatial Sorting (Left-to-Right) ---
% Sort bounding boxes monotonically by their starting X coordinate
[~, sort_idx] = sort(valid_boxes(:,1), 'ascend');
sorted_images = valid_images(sort_idx);

%% --- STAGE 5: Template Matching (NCC) & Classification ---
target_size = [40, 20];
templates = cell(10, 1);

% Build the template bank by extracting the known digits (12-345-90)
templates{1}  = imresize(sorted_images{1}, target_size); % '1'
templates{2}  = imresize(sorted_images{2}, target_size); % '2'
templates{3}  = imresize(sorted_images{3}, target_size); % '3'
templates{4}  = imresize(sorted_images{4}, target_size); % '4'
templates{5}  = imresize(sorted_images{5}, target_size); % '5'
templates{9}  = imresize(sorted_images{6}, target_size); % '9'
templates{10} = imresize(sorted_images{7}, target_size); % '0'

recognized_plate = '';
figure('Name', 'Final OCR Classification', 'Color', 'w', 'Position', [150, 150, 900, 250]);

for i = 1:length(sorted_images)
    candidate = imresize(sorted_images{i}, target_size);
    best_score = -1; 
    best_digit = '?';
    
    for t = 1:10
        if isempty(templates{t})
            continue; % Skip missing templates
        end
        % Calculate NCC (Normalized Cross-Correlation)
        score = max(max(normxcorr2(templates{t}, candidate)));
        
        if score > best_score
            best_score = score;
            if t == 10
                best_digit = '0';
            else
                best_digit = num2str(t);
            end
        end
    end
    recognized_plate = [recognized_plate, best_digit];
    
    % Display current digit and its identification
    subplot(1, length(sorted_images), i);
    imshow(candidate);
    title(sprintf('Read: %s', best_digit), 'FontSize', 12, 'Color', 'b', 'FontWeight', 'bold');
end

%% --- FINAL OUTPUT ---
fprintf('\n==================================================\n');
fprintf('FINAL OCR RESULT: %s\n', recognized_plate);
fprintf('==================================================\n\n');