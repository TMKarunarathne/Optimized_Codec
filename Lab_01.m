close all
clear all
clc
%% Step 2: Read the original image into a Matrix. 

ori_im = imread('Parrots-680x680.jpg');
full_size = size(ori_im);
figure;
imshow(ori_im);
title('Original Image');

%% Step 3: Select 16×16 cropped sub-image from your input at step2. 
% E/16/177 x = 1*50 = 50 y = 77*4 = 308
% Starting point to crop = (50,308)

crop_im = imcrop(ori_im , [50,308,15,15]);
figure;
imshow(crop_im);
title('Cropped Image');
crop_size = size(crop_im);

crop_gray = rgb2gray(crop_im);
figure;
imshow(crop_gray);
title('Cropped Gray Scale Image');

full_gray = rgb2gray(ori_im);
figure;
imshow(full_gray,[]);
title('Full Gray Scale Image');

%% Step 4: Quantize the output at Step 3 into 8 levels (level 0-7) using uniform quantization.
thresh = multithresh(crop_gray,7); % getting 7 threshold values
valuesMax = [thresh max(crop_gray(:))]; % level representing values 

% Quantize cropped image
[quant8_im, index1] = imquantize(crop_gray,thresh,valuesMax); % mapped values and levels
figure;
imshow(quant8_im,[]) ; title('Quantized Cropped Image');

% Quantize full image
[quant8_full_im, index2] = imquantize(full_gray,thresh,valuesMax); % mapped values and levels
figure;
imshow(quant8_full_im,[]) ; title('Quantized full Image');

%% Step 5: Find the probability of each symbol distribution of the output at Step 4. 
[g,~,Intensity_val] = grp2idx(quant8_im(:));
Frequency = accumarray(g,1);

prob = Frequency./(crop_size(1)*crop_size(2)); % probabilities
T = table(Intensity_val,Frequency,prob);


[gf,~,Intensity_valf] = grp2idx(quant8_full_im(:));
Frequencyf = accumarray(gf,1);
probf = Frequencyf./(full_size(1)*full_size(2)); % probabilities

[probability,index]=sort(prob);
Intensity_val =Intensity_val(index);

%% Step 6: Construct the Huffman coding algorithm for cropped image at Step 4
% Huffman Codebook
codebook = Huff_codebook(probability,Intensity_val);

%% Step 7: Compress both cropped and original images using the algorithm and the codebook generated at step 6.
% Encode the cropped image
crop_encoded=Huff_encode(quant8_im,codebook);

% Encode the full image
full_encoded=Huff_encode(quant8_full_im,codebook);

%% Step 8: Save the compressed image into a text file
% Encoded array save as a txt
a1=sprintf(num2str(crop_encoded));
text_1='text_1.txt';
fid = fopen(text_1,'wt');
fprintf(fid, a1);
fclose(fid);

% Encoded array save as a txt
a2=sprintf(num2str(full_encoded));
text_2='text_2.txt';
fid = fopen(text_2,'wt');
fprintf(fid, a2);
fclose(fid);

%% Decoding
im_arr =Huff_decode(text_1,codebook);
full_im_arr =Huff_decode(text_2,codebook);

decoded_im=reshape(im_arr(:),crop_size(1:2));
figure;
imshow(decoded_im,[]);
title('Reconstructed Cropped Image');

decoded_full_im=reshape(full_im_arr(:),full_size(1:2));
figure;
imshow(decoded_full_im,[]);
title('Reconstructed Full Image');
%%  Step 9,10: Compress the original image using Huffman encoding function in the Matlab tool box and save it into another text file.
codebook_inbuilt = huffmandict(Intensity_valf, probf);
enco = huffmanenco(quant8_full_im(:),codebook_inbuilt);
% Encoded array save as a txt
a3=sprintf(num2str(enco));
text_3='text_3.txt';
fid = fopen(text_3,'wt');
fprintf(fid, a3);
fclose(fid);

% decompress image
txt = fileread(text_3);
enco_full=str2num(txt');
decode_cropped = huffmandeco(enco_full,codebook_inbuilt);

dec_im=reshape(decode_cropped,full_size(1:2));
figure;
imshow(dec_im,[]);
title('Reconstructed Image with Inbuilt Functions');



%% Step 11: Calculate the entropy of the Source
entro_ori= entropy(ori_im) %entropy of the original image
entro_full_gray = entropy(full_gray) %entropy of the full gray image
entro_crop_gray = entropy(crop_gray) %entropy of the cropped gray image
entro_crop_gray_quantized = entropy(quant8_im) %entropy of the cropped quantized image
entro_crop_decoded = entropy(decoded_im)

%% Step 12: Evaluate the PSNR of 
% i. The original images 
% ii. The decompressed images 
psnr_ori_im = psnr(ori_im,ori_im) %PSNR for the originalimage
psnr_dec_im = psnr(decoded_full_im,full_gray) %PSNR for the decode gray image

%% Discussion 2
avg_length=0;
for i=1:8
avg_length=avg_length+probability(i)*numel(codebook{i,2});
end
fprintf("Average length = %f\n",avg_length)
%%
%% For RGB plans
ori_im_r = ori_im(:,:,1);
ori_im_g = ori_im(:,:,2);
ori_im_b = ori_im(:,:,3);
black =  zeros(full_size(1:2), 'uint8');

% Quantize full image
[quant8_r, index2] = imquantize(ori_im_r,thresh,valuesMax); % mapped values and levels
[quant8_g, index2] = imquantize(ori_im_g,thresh,valuesMax); % mapped values and levels
[quant8_b, index2] = imquantize(ori_im_b,thresh,valuesMax); % mapped values and levels

% Red
ori_red=cat(3,ori_im_r,black,black);
figure;
imshow(ori_red);title('Red Components in Original Image');
q_red=cat(3,quant8_r,black,black);
figure;
imshow(q_red);title('Red Components in Decodeed Image');


% Green
ori_green=cat(3,black,ori_im_g ,black);
figure;
imshow(ori_green);title('Green Components in Original Image');
q_green=cat(3,black,quant8_g,black);
figure;
imshow(q_green);title('Green Components in Decodeed Image');

% Blue
ori_blue=cat(3,black ,black,ori_im_b);
figure;
imshow(ori_blue);title('Blue Components in Original Image');
q_blue=cat(3,black,black,quant8_b);
figure;
imshow(q_blue);title('Blue Components in Decodeed Image');

q_full = cat(3,quant8_r,quant8_g,quant8_b);
figure;
imshow(q_full);title('Full Decoded Image');
