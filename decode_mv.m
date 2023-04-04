function dec_mv = decode_mv(MV_encoded , codebook_mv  , row_mac , col_mac)
mv = Huff_decode(MV_encoded,codebook_mv); % huffman decoding the MV
decoded_mv=reshape(mv(:) , col_mac*2 , row_mac )';
dec_mv = mat2cell( decoded_mv , ones(1,row_mac) , 2*ones(1,col_mac));

end