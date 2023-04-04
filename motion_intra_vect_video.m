function MV_res = motion_intra_vect_video(macro, row_im , col_im ,num_im, p)

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
MV_res = cell(num_im  , 2);
% mac = macro{1,1};
%[MV , res] = intra_pred( macro{1,1}  );

for i=1:num_im
    [MV , res] = intra_pred( macro{i,1}  );
    
    if i==1
        for r=1:row_mac
            for c=1:col_mac
                if  isempty(MV{r,c})
                    res{r,c} = int16(macro{i,1}{r,c});
                    MV{r,c} = [0,0];
                end
            end
        end
    end
    
    MV_res{i,1} = MV;
    MV_res{i,2} = res;
end


for i=2:num_im
    [MV , res] = motion_intra_vect( macro{i,1} , ref , MV_res(i,:) , p);
    MV_res{i,1} = MV;
    MV_res{i,2} = res;
end

end