function dec_macro = decode_image(encoded_im , row_mac , col_mac ,level)
%% DC decoding
dec_dc_dif = Huff_decode(encoded_im{1,1},encoded_im{1,3}); % huffman decoding the dc
dec_dc_co = inv_differential_code(dec_dc_dif ); 
%% AC decoding
dec_ac_run = Huff_decode(encoded_im{1,2},encoded_im{1,4}); % huffman decoding the ac
dec_ac = inv_runlength(dec_ac_run);
%% Combine the decoded dc and ac 
dec_dct_cof= inv_dcac_extract(dec_dc_co , dec_ac , row_mac , col_mac);
%% inverse quantizer
dec_dct = inv_quantize8(dec_dct_cof,level);
%% inverse dct
dec_macro = inv_dctf(dec_dct);

end