  % KITTI TRACKING BENCHMARK DEMONSTRATION
% 
% This tool displays the images and the object labels for the benchmark and
% provides an entry point for writing your own interface to the data set.
% Before running this tool, set root_dir to the directory where you have
% downloaded the dataset. 'root_dir' must contain the subdirectory
% 'training', which in turn contains 'image_02', 'label_02' and 'calib'.
% For more information about the data format, please look into readme.txt.
%
% Usage:
%   SPACE: next frame
%   '-':   last frame
%   'x':   +50 frames
%   'y':   -50 frames
%   'c':   previous sequence
%   'v':   next sequence
%   q:     quit
%
% Occlusion Coding:
%   green:  not occluded
%   yellow: partly occluded
%   red:    fully occluded
%   white:  unknown
%
% Truncation Coding:
%   solid:  not truncated
%   dashed: truncated

% clear and close everything
clear all; close all; clc;
disp('======= KITTI DevKit Demo =======');

% options
root_dir = '/Users/jkuck/rotation3/KITTI/data';
data_set = 'training';

% set camera
cam = 2; % 2 = left color camera

% show data for tracking sequences
nsequences = numel(dir(fullfile(root_dir,'testing', sprintf('image_%02d',cam))))-2;
seq_idx=1;
% get sub-directories
image_dir = fullfile(root_dir,'testing', sprintf('image_%02d/%04d',cam, seq_idx));
%label_dir = fullfile(root_dir,data_set, sprintf('label_%02d',cam))
%label_dir = fullfile(root_dir,data_set, 'det_02');
%label_dir = '/Users/jkuck/rotation3/KITTI/data_tracking_det_2_regionlets/training/det_02';
%label_dir = '/Users/jkuck/rotation3/KITTI/data_tracking_det_2_lsvm/training/det_02';
%label_dir = '/Users/jkuck/rotation3/KITTI/data_tracking_det_2_regionlets/testing/det_02'
%label_dir = '/Users/jkuck/rotation3/KITTI/devkit_tracking/python/results/sha_key/data';
%label_dir = '/Users/jkuck/rotation3/KITTI/devkit_tracking/python/results/R_on_intervals/data';
%estimate_label_dir = '/Users/jkuck/rotation3/KITTI/devkit_tracking/matlab/rbpf_results';

estimate_label_dir = '/Users/jkuck/rotation3/KITTI/devkit_tracking/python/results/temp_test0/data'

%estimate_label_dir = '/Users/jkuck/scratch_sherlock/debugged_death_probs_3TimeStepsMarkovChain_onlineResults_goodIDS_variable_R/regionlets_only_with_score_intervals/100_particles/results_by_run/run_1';
gt_label_dir = fullfile(root_dir,data_set, sprintf('label_%02d',cam));
regionlets_label_dir = '/Users/jkuck/rotation3/KITTI/data_tracking_det_2_regionlets/training/det_02'

calib_dir = fullfile(root_dir,'testing', 'calib');
P = readCalibration(calib_dir,seq_idx,cam);

% get number of images for this dataset
nimages = length(dir(fullfile(image_dir, '*.png')));

% load labels
estimated_tracklets = readLabels(estimate_label_dir, seq_idx);
gt_tracklets = readLabels(gt_label_dir, seq_idx);
regionlets_tracklets = readLabels(regionlets_label_dir, seq_idx);
% set up figure
h = visualization('init',image_dir);

% main loop
img_idx=0;
while 1

  % load projection matrix


  % visualization update for next frame
  visualization('update',image_dir,h,img_idx,nimages,'testing');
  % for all annotated t racklets do


 for obj_idx=1:numel(gt_tracklets{img_idx+1})

   % plot 2D bounding box
    drawBox2D(h,gt_tracklets{img_idx+1}(obj_idx),'b');

%    % plot 3D bounding box
%    [corners,face_idx] = computeBox3D(gt_tracklets{img_idx+1}(obj_idx),P);
%    orientation = computeOrientation3D(gt_tracklets{img_idx+1}(obj_idx),P);
%    drawBox3D(h, gt_tracklets{img_idx+1}(obj_idx),corners,face_idx,orientation);

 end

%   for obj_idx=1:numel(regionlets_tracklets{img_idx+1})
% 
%     % plot 2D bounding box
%      drawBox2D_detection(h,regionlets_tracklets{img_idx+1}(obj_idx),'b', 2.0);
% 
% %     % plot 3D bounding box
% %     [corners,face_idx] = computeBox3D(regionlets_tracklets{img_idx+1}(obj_idx),P);
% %     orientation = computeOrientation3D(regionlets_tracklets{img_idx+1}(obj_idx),P);
% %     drawBox3D(h, regionlets_tracklets{img_idx+1}(obj_idx),corners,face_idx,orientation);
% 
%   end

  for obj_idx=1:numel(estimated_tracklets{img_idx+1})

    % plot 2D bounding box
     drawBox2D(h,estimated_tracklets{img_idx+1}(obj_idx),'g');

%     % plot 3D bounding box
%     [corners,face_idx] = computeBox3D(estimated_tracklets{img_idx+1}(obj_idx),P);
%     orientation = computeOrientation3D(estimated_tracklets{img_idx+1}(obj_idx),P);
%     drawBox3D(h, estimated_tracklets{img_idx+1}(obj_idx),corners,face_idx,orientation);

  end

  % force drawing and tiny user interface
  try
    waitforbuttonpress; 
  catch
    fprintf('Window closed. Exiting...\n');
    break
  end
  key = get(gcf,'CurrentCharacter');
  switch lower(key)                         
    case 'q',  break;                                 % quit
    case '-',  img_idx = max(img_idx-1,  0);          % previous frame
    case 'x',  img_idx = min(img_idx+50,nimages-1);   % +50 frames
    case 'y',  img_idx = max(img_idx-50,0);           % -50 frames
    case 'v'
      seq_idx   = min(seq_idx+1,nsequences);
      img_idx   = 0;
      image_dir = fullfile(root_dir,'testing', sprintf('image_%02d/%04d',cam, seq_idx));
%      estimate_label_dir = fullfile(root_dir,data_set, sprintf('label_%02d',cam)); %jdk edit 
      calib_dir = fullfile(root_dir,'testing', 'calib');
      nimages   = length(dir(fullfile(image_dir, '*.png')));
%      estimated_tracklets = readLabels(estimate_label_dir,seq_idx,nimages);
      estimated_tracklets = readLabels(estimate_label_dir,seq_idx);
      regionlets_tracklets = readLabels(regionlets_label_dir,seq_idx);
      gt_tracklets = readLabels(gt_label_dir,seq_idx);

      P = readCalibration(calib_dir,seq_idx,cam);
    case 'c'
      seq_idx   = max(seq_idx-1,0);
      img_idx   = 0;
      image_dir = fullfile(root_dir,'testing', sprintf('image_%02d/%04d',cam, seq_idx));
%      estimate_label_dir = fullfile(root_dir,data_set, sprintf('label_%02d',cam)); %jdk edit
      calib_dir = fullfile(root_dir,'testing', 'calib');
      nimages   = length(dir(fullfile(image_dir, '*.png')));
%      estimated_tracklets = readLabels(estimate_label_dir,seq_idx,nimages);
      estimated_tracklets = readLabels(estimate_label_dir,seq_idx);
      regionlets_tracklets = readLabels(regionlets_label_dir,seq_idx);
      gt_tracklets = readLabels(gt_label_dir,seq_idx);

      P = readCalibration(calib_dir,seq_idx,cam);
    otherwise, img_idx = min(img_idx+1,  nimages-1);  % next frame
  end
end

% clean up
close all;
