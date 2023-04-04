function dec_macro = inv_motion_intra_vect_video(decoded_vid_frames_res, row_im , col_im , num_im )

[row , col] = size(decoded_vid_frames_res{1,1}); % size of macro cell array
for r=1:row
    for c=1:col
        res_block = decoded_vid_frames_res{1,2}{r,c};
        if length(res_block)==1
            mx = decoded_vid_frames_res{1,1}{r,c}(1,1);
            my = decoded_vid_frames_res{1,1}{r,c}(1,2);
            %%ref_block = temp_ref((r-1)*x+1 + mx:r*x + mx  ,(c-1)*y+1 + my:c*y + my );
            ref_block = decoded_vid_frames_res{1,2}{r + mx ,c + my };
            decoded_vid_frames_res{1,2}{r,c} = ref_block;       
        end
    end
end

ref = inv_macroblock( decoded_vid_frames_res{1,2} ,row_im , col_im );
ref=int16(ref);
dec_macro = cell(num_im  , 1);
dec_macro {1,1} = decoded_vid_frames_res{1,2};

for i=2:num_im
    dec_macro {i,1} = inv_motion_intra_vect( decoded_vid_frames_res{i,1}, decoded_vid_frames_res{i,2} , ref );
end

%%% mv = decoded_vid_frames_res{i,1}; 
%%% res = decoded_vid_frames_res{i,2};
end

