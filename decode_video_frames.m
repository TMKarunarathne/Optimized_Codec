function decoded_vid_frames_res = decode_video_frames(encoded_vid_frames , row_mac , col_mac )
[row , col] = size(encoded_vid_frames);
decoded_vid_frames_res = cell(row , 2);
global level 
for i = 1:row
    %%%[dc_encoded , ac_encoded , codebook_dc , codebook_ac ] = encode_image(MV_res{i,2});
    decoded_vid_frames_res{i,2} = decode_image(encoded_vid_frames(i,:) , row_mac , col_mac ,level );

end

for i = 2:row    
    %%% dec_mv = decode_mv(MV_encoded , codebook_mv  , row_mac , col_mac)
    decoded_vid_frames_res{i,1} = decode_mv(encoded_vid_frames{i,5}, encoded_vid_frames{i,6}  , row_mac , col_mac);
end
% MV_encoded = encoded_vid_frames{i,5}; 
%  codebook_mv=encoded_vid_frames{i,6};
end