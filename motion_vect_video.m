function MV_res = motion_vect_video(macro, row_im , col_im ,num_im, p)

global level 
[row_mac , col_mac ]= size(macro{1,1});
[dc_encoded , ac_encoded , codebook_dc , codebook_ac ] = encode_image(macro{1,1});
encoded_im=cell(1,5);
encoded_im{1,1}=dc_encoded ;
encoded_im{1,2}=ac_encoded ;
encoded_im{1,3}=codebook_dc ;
encoded_im{1,4}=codebook_ac ;
dec_macro = decode_image(encoded_im , row_mac , col_mac ,level);
ref =int16(inv_macroblock(dec_macro ,row_im , col_im ));


%%ref = inv_macroblock(macro{1,1} ,row_im , col_im );
MV_res = cell(num_im  , 2);
MV_res{1,2} = macro{1,1};
for i=2:num_im
    [MV , res] = motion_vect( macro{i,1} , ref , p);
    MV_res{i,1} = MV;
    MV_res{i,2} = res;
end

end