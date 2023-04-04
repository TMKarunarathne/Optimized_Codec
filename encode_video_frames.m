function encoded_vid_frames = encode_video_frames(MV_res)
[row , col] = size(MV_res);
encoded_vid_frames = cell(row , 6);

for i = 1:row
    %%%[dc_encoded , ac_encoded , codebook_dc , codebook_ac ] = encode_image(MV_res{i,2});
    [encoded_vid_frames{i,1} , encoded_vid_frames{i,2} , encoded_vid_frames{i,3} , encoded_vid_frames{i,4} ] = encode_image(MV_res{i,2});
    
end

for i = 2:row
    %%%[MV_encoded , codebook_MV ] = encode_mv(mv)
    [encoded_vid_frames{i,5}  , encoded_vid_frames{i,6}  ] = encode_mv(MV_res{i,1});
    
end

end