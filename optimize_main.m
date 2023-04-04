%% =====   MINI PROJECT E/16/177   ===== %%
close all
clear all
clc
%% add to path 
cd 'D:\7th sem\EE596-Image and Video Coding\Mini Project\my_project\optimize';
%% globle variables
global level % quantize level : when increasing this, quality of the O\P reducing
level = 1;

%% read images
listing = dir('images_03\*.jpg');
cd 'images_03';
name = {listing.name};
num_im = 4;
images = cell(num_im  , 1);
for i=1:num_im
    images{i,1} = rgb2gray(imread(name{i}));
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% optimize the level parameter
% in my algorithm level parameter can ne optimizing by using I-frame or P-frame
% therefore there is an option to choose "I" or "P"
fprintf('optimize the level parameter\n');
bitrate =20;% kbits per frame
opimize_level(images{1,1},images{2,1},'I',bitrate);

% % ref=images{1,1};
% % img=images{2,1};
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Optimize  best bit-rate for a given quality level
fprintf('\nOptimize  best bit-rate for a given quality level\n');
level = 1;
p=12;
% optimize_bitrate(images,p);
num_img = length(images) ;
macro = cell(num_img  , 1);
for i=1:num_img
    macro{i,1} = macroblock(images{i,1} , [8 8]);
end
[ row_mac , col_mac ] = size(macro{1,1});
%% Motion vector and residual
[row_im , col_im] = size(images{1,1});
MV_res = motion_intra_vect_video(macro, row_im , col_im , num_im , p);
%% encode frames
encoded_vid_frames = encode_opt_video_frames(MV_res);

%% decode frames
decoded_vid_frames_res = decode_opt_video_frames(encoded_vid_frames , row_mac , col_mac );%%%%%%%
%%  inverse motion vector and residual
dec_macro = inv_motion_intra_vect_video(decoded_vid_frames_res, row_im , col_im , num_im );
%% from macro blocks to full image
decoded_images=cell(num_im , 1);
for i = 1:num_im
    %%%fig1=figure;
    dec_gray_im = inv_macroblock(dec_macro{i,1} ,row_im , col_im );
    decoded_images{i,1}= dec_gray_im;
    %%imshow(dec_gray_im);
    %%saveas(fig1,'Reconstructed_Image_'+string(i)+'.jpg');
end

bpf_opt = [];
for i =1:num_img
    bpf_opt = [ bpf_opt , (length(encoded_vid_frames{i,1}) + length(encoded_vid_frames{i,2})+ length(encoded_vid_frames{i,4}))/1000];
end
%% without optimizing
MV_res_2 = motion_vect_video(macro, row_im , col_im , num_im , p);
encoded_vid_frames_2 = encode_video_frames(MV_res_2);
% macro2 =MV_res_2{1,2};

bpf = [];
for i =1:num_img
    bpf = [ bpf , (length(encoded_vid_frames_2{i,1}) + length(encoded_vid_frames_2{i,2})+ length(encoded_vid_frames_2{i,4}))/1000];
end
%% comparison

for i =1:num_img
    fprintf('Image %i\t\tkBPF_opt = %f\tkBPF = %f\n',i,bpf_opt(i),bpf(i));
end

