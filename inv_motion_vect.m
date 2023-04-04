function dec_mac  = inv_motion_vect( mv, res , ref )
% mv : cell array of motion vector
% ref : refference image
% res : residual 
[row , col] = size(res); % size of macro cell array
[x , y] = size(res{1,1}); % size of a singal macro block
[xr , yr] = size(ref); % size of the ref image
temp_ref = zeros(xr+x , yr+y , 'int16');
temp_ref(1:xr , 1:yr) = ref;
dec_mac = cell(row , col);

for r=1:row
    for c=1:col
        res_block = int16(res{r,c});
        mx = mv{r,c}(1,1);
        my = mv{r,c}(1,2);
        %%ref_block = temp_ref((r-1)*x+1 + mx:r*x + mx  ,(c-1)*y+1 + my:c*y + my );
        ref_block = temp_ref((r-1)*x+1 + mx:r*x + mx  ,(c-1)*y+1 + my:c*y + my );
        dec_mac{r,c} = uint8(res_block + ref_block);
        
    end
end
%%% r = 1; c= 1;  
end