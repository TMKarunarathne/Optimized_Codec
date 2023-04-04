function im_arr =Huff_decode(encoded,codebook)
arr=encoded';
im_arr=[];
start=1;
codebook_size=size(codebook);
for i = 1:length(arr)
    temp=arr(start:i);
    for j=1:codebook_size(1,1)
        if isequal(temp,codebook{j,2})
            im_arr=[im_arr , codebook{j,1} ];
            start=i+1;
            break
            
        end
    end
end
end