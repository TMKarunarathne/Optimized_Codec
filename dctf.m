function dct_cof = dctf(macro)

[x, y] = size(macro);
dct_cof = cell(x,y);

for i = 1:1:x
    for j = 1:1:y
        if length(macro{i,j})==1
            dct_cof{i,j} = macro{i,j};
        else
            %2-D discrete cosine transform
            dct_cof{i,j} = dct2(macro{i,j});
        end
         
    end
end

end