function [MV , res] = intra_pred(mac)
% mac : macro block for singal image
% ref : refference image
[row , col] = size(mac); % size of macro cell array
pp = 1;
MV = cell(row , col);
res = cell(row , col);

for r=1:row
    for c=1:col
%         count = 1;
        test_block = mac{r,c};
        for mx = -pp:1:0
            for my =-pp:1:pp
                condition_1 = (r + mx >0) * (c + my >0) * (r + mx <=row) * (c + my <=col);
                condition_2 = (mx==0) && (my>-1);
                if (condition_1==0 || condition_2==1)
                    %%fprintf('mx = %i   my = %i\n',mx,my);
                    continue
                end                
                
%                 if count == 1
%                     ref_block = temp_ref((r-1)*x+1 + 0*mx:r*x + 0*mx  ,(c-1)*y+1 + 0*my:c*y + 0*my );
%                     residu = test_block - ref_block;
%                     min_err = sum(abs(residu),'all');
%                     mv = [0 , 0];
%                     count = count +1;                  
%                 end
%                 
                ref_block = mac{r + mx , c + my };
                
                if isequal( ref_block , test_block )
                    residu = int16(1000);
                    mv = [mx , my];
                    res{r,c} = residu;
                    MV{r,c} = mv;
                end

            end  
        end
        
        
           
    end
end

end