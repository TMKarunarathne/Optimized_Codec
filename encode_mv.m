function [MV_encoded , codebook_mv ] = encode_mv(mv)
mv_mat = cell2mat(mv);
% mvc huffman coding
% mv sybol probability calculation 
[prob_mv,symb_mv] = prob_symb(mv_mat');
% Huffman Codebook
codebook_mv = Huff_codebook( prob_mv , symb_mv );
% Encode the dc
MV_encoded=Huff_encode( mv_mat' ,codebook_mv);


end