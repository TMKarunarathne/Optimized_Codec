function [MV , res] = motion_intra_vect(mac , ref , MV_res_i, p)
% mac : macro block for singal image
% ref : refference image
[row , col] = size(mac); % size of macro cell array
[x , y] = size(mac{1,1}); % size of a singal macro block
[xr , yr] = size(ref); % size of the ref image
temp_ref = zeros(xr+x , yr+y , 'int16');
temp_ref(1:xr , 1:yr) = ref;
MV = MV_res_i{1,1};
res = MV_res_i{1,2};

for r=1:row
    for c=1:col
        count = 1;
        if ~isempty(MV{r,c})
            continue
        end
        test_block = int16(mac{r,c});
        for mx = -p:1:p
            for my =-p:1:p
                if((r-1)*x+1 + mx >0) * ((c-1)*y+1 + my >0) * ((r-1)*x+1 + mx <=xr) * ((c-1)*y+1 + my <=yr)==0 
                    continue
                end                
                
                if count == 1
                    ref_block = temp_ref((r-1)*x+1 + 0*mx:r*x + 0*mx  ,(c-1)*y+1 + 0*my:c*y + 0*my );
                    residu = test_block - ref_block;
                    min_err = sum(abs(residu),'all');
                    mv = [0 , 0];
                    count = count +1;                  
                end
                
                ref_block = temp_ref((r-1)*x+1 + mx:r*x + mx  ,(c-1)*y+1 + my:c*y + my );
                err = sum(abs(test_block - ref_block),'all');
                
                if err<min_err
                    residu = test_block - ref_block;
                    min_err = err;
                    mv = [mx , my];
                end

            end  
        end
        
        res{r,c} = residu;
        MV{r,c} = mv;
           
    end
end

end