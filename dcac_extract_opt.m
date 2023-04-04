function [dc ac] = dcac_extract_opt(quant_dct)

[x, y] = size(quant_dct);
dc=[];
ac=[];

for i = 1:1:x
    for j = 1:1:y
        if length(quant_dct{i,j})==1
            dc = [ dc ,quant_dct{i,j} ];
            %ac = [ ac ,quant_dct{i,j} ];
        else
            zigzag_dct = zigzag(quant_dct{i,j}); 
            dc = [ dc , zigzag_dct(1) ];
            ac = [ ac , zigzag_dct(2:end) ];
        end        
    end
end
% 
% i=1;
% j=2;

end