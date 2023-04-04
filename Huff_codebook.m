function codebook = Huff_codebook(p,Intensity_val)
codebook=cell(length(p) , 2);
%codebook(:,2)=cellstr('');
temp_c=cell(length(p) , 2);
temp_p=p;

for i=1:length(p)
    codebook{i,1}=Intensity_val(i);
    temp_c{i,1}=i;
    temp_c{i,2}=p(i);
end

% codebook{1,2} = cellstr(string(0));
% codebook{2,2} = cellstr(string(1));
codebook{1,2} = 0;
codebook{2,2} = 1;
size_tem=size(temp_c);

while size_tem(1)>2
    temp_c{2,1}=[ temp_c{2,1},temp_c{1,1} ];
    temp_c{2,2}= temp_c{2,2} + temp_c{1,2} ;

    temp_c=temp_c(2:end,:);
    size_tem=size(temp_c);

    temp_p=[temp_p(1)+temp_p(2) ; temp_p(3:end)];
    [temp_p,index]=sort(temp_p);
    tmp_row=temp_c(1,:);

    for i=1:size_tem(1)
        if index(i)==1
            temp_c(i,:)= tmp_row;
            break
        else
            temp_c(i,:)=temp_c(index(i),:);
        end
    end
    % add '0' and'1' for front 
    set1=temp_c{1,1};
    size_1_1 = size(set1);
    set2 = temp_c{2,1};
    size_2_1 = size(set2);
    
    for i=1:size_1_1(2)
%         codebook{set1(i),2}=string(0)+codebook{set1(i),2};
        codebook{set1(i),2}=[0, codebook{set1(i),2}];
    end
    for i=1:size_2_1(2)
%         codebook{set2(i),2}=string(1)+codebook{set2(i),2};
        codebook{set2(i),2}=[1, codebook{set2(i),2}];
    end
end

end
