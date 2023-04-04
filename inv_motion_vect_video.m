function dec_macro = inv_motion_vect_video(decoded_vid_frames_res, row_im , col_im , num_im )

ref = inv_macroblock(  decoded_vid_frames_res{1,2} ,row_im , col_im );
ref=uint16(ref);
dec_macro = cell(num_im  , 1);
dec_macro {1,1} = decoded_vid_frames_res{1,2};
for i=2:num_im
    dec_macro {i,1} = inv_motion_vect( decoded_vid_frames_res{i,1}, decoded_vid_frames_res{i,2} , ref );
end

%%% mv = decoded_vid_frames_res{i,1}; 
%%% res = decoded_vid_frames_res{i,2};
end

