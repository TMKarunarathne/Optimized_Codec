function [dc_encoded , ac_encoded , codebook_dc , codebook_ac ] = encode_image(macro)
%% DCT 
dct_cof = dctf(macro);
%% Quantizing 
global level  % by changing the level we can change the quality
quant_dct = quantize8(dct_cof,level);
%% DC and AC extraction
[dc , ac] = dcac_extract(quant_dct);
%% Differential coding for dc components
dif_dc_co = differential_code(dc);
%% Apply run length for ac components
run_len_ac = runlength(ac);

%% dc huffman coding
% dc sybol probability calculation 
[prob_dc,symb_dc] = prob_symb(dif_dc_co);
% Huffman Codebook
codebook_dc = Huff_codebook( prob_dc , symb_dc );
% Encode the dc
dc_encoded=Huff_encode( dif_dc_co ,codebook_dc);

%% ac huffman coding
% ac sybol probability calculation 
[prob_ac,symb_ac] = prob_symb(run_len_ac);
% Huffman Codebook
codebook_ac = Huff_codebook( prob_ac , symb_ac );
% Encode the ac
ac_encoded=Huff_encode( run_len_ac ,codebook_ac);

end