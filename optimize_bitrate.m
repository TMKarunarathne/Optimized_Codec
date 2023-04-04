function optimize_bitrate(images,p)
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% decode frames
decoded_vid_frames_res = decode_opt_video_frames(encoded_vid_frames , row_mac , col_mac );%%%%%%%
%%  inverse motion vector and residual

dec_macro = inv_motion_intra_vect_video(decoded_vid_frames_res, row_im , col_im , num_im );
%dec_macro = inv_motion_vect_video(MV_res, row_im , col_im , num_im );

%%

%% from macro blocks to full image
decoded_images=cell(num_im , 1);
for i = 1:num_im
    fig1=figure;
    dec_gray_im = inv_macroblock(dec_macro{i,1} ,row_im , col_im );
    decoded_images{i,1}= dec_gray_im;
    imshow(dec_gray_im);
    %%saveas(fig1,'Reconstructed_Image_'+string(i)+'.jpg');
end

bpf = [];
for i =1:num_img
    bpf = [ bpf , length(encoded_vid_frames{i,1}) + length(encoded_vid_frames{i,2})+ length(encoded_vid_frames{i,4})];
end

end