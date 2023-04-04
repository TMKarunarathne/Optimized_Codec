function A=Huff_encode(img,codebook)
[row,col]=size(img);
A=[];
for j=1:col
    for i = 1:row
        A = [A,codebook{find(cell2mat(codebook(:,1)) == img(i,j)),2}];
    end    
end
A=A(:);

end