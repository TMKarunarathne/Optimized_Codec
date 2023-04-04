function dec_dct_cof= inv_dcac_extract_opt(dc , ac , x ,y)
% x : number of rows in the macro block
% y : number of columns in the macro block
% len_dc = length(dc);
% ac_len = length(ac)/len_dc; %number of ac components for one macro block
ac_len = 63;
dec_dct_cof = cell(x,y);
n = 1;
m = 1;

for i = 1:x
    for j = 1:y
        if dc(n)==1000
            ac_dc_arr = 1000;
            %m=m+1;
        else
            arr=[dc(n) , ac( m :m+ac_len-1 )];
            ac_dc_arr = inv_zigzag(arr,8,8);
            m=m+ac_len;
        end
        
        dec_dct_cof{i,j}=ac_dc_arr;
 
        n=n+1;
    end
end
% dc=dec_dc_co ;ac= dec_ac ;
% x = 40; y = 60;
% i = 1 ; j = 2 ;
end