function opimize_level(ref,img,I_P,req_bpf)
global level
q_level = [32, 16, 8, 4, 2, 1, .8, .4, .2, .1];
imag=cell(2,1);
imag{1,1} = ref;
imag{2,1} = img;
num_img = 2;
macro = cell(num_img  , 1);
for i=1:num_img
    macro{i,1} = macroblock(imag{i,1} , [8 8]);
end
[ row_mac , col_mac ] = size(macro{1,1});
distrotion = [] ;
bitrate = [] ; % bits per frame 

for index = 1:length(q_level)
    level = q_level(index);
    % optimizing using "I" 
    if I_P=='I'
        [dc_encoded , ac_encoded , codebook_dc , codebook_ac ] = encode_image(macro{1,1});
        encoded_im = cell(1,4);
        encoded_im{1,1} = dc_encoded;
        encoded_im{1,2} = ac_encoded;
        encoded_im{1,3} = codebook_dc;
        encoded_im{1,4} = codebook_ac;
        dec_macro = decode_image(encoded_im , row_mac , col_mac ,level);
        [row_im , col_im] = size(ref);
        dec_gray_im = inv_macroblock(dec_macro ,row_im , col_im );

        dist =  1/psnr(uint8(dec_gray_im) , ref ); % distrotion using PSNR 
        distrotion = [distrotion , dist] ;
        bpf = (length(dc_encoded) + length(ac_encoded))/1000; % kbits per frame without headings
        bitrate = [bitrate , bpf] ;

    else
        % Motion vector and residual
        [row_im , col_im] = size(imag{1,1});
        p=12;
        MV_res = motion_vect_video(macro, row_im , col_im , num_img , p);
        % encode frames
        encoded_vid_frames = encode_video_frames(MV_res);

        % decode frames
        decoded_vid_frames_res = decode_video_frames(encoded_vid_frames , row_mac , col_mac );
        %  inverse motion vector and residual
        dec_macro = inv_motion_vect_video(decoded_vid_frames_res, row_im , col_im , num_img ); 
        % from macro blocks to full image
        decoded_images=cell(num_img , 1);
        for i = 1:num_img
            dec_gray_im = inv_macroblock(dec_macro{i,1} ,row_im , col_im );
            decoded_images{i,1}= dec_gray_im;
        end

        dist =  1/psnr(uint8(decoded_images{2,1}) , img ); % distrotion using PSNR 
        distrotion = [distrotion , dist] ;
        bpf = (length(encoded_vid_frames{2,1}) + length(encoded_vid_frames{2,2})+ length(encoded_vid_frames{2,5}))/1000; % kbits per frame without headings
        bitrate = [bitrate , bpf] ;

    end
end
ind = find(bitrate<=req_bpf);
if length(ind)>0
    new_dist = distrotion(ind);
    [min_dist ,min_ind] = min(new_dist);
    level = q_level(ind(min_ind));
    fprintf('level = %.01f   distrotion = %f   bpf = %f\n',level,min_dist,bitrate(ind(min_ind)));
else
    fprintf('Cannot reach the required BPF. Minimum available BPF is %f kbpf.\n',min(bitrate));
    level = 1;
end
figure;
plot(distrotion,bitrate);
xlabel('Distrotion');
ylabel('KBPF');

% % figure;
% % plot(q_level,bitrate);
% % xlabel('q_level');
% % ylabel('KBPF');


end