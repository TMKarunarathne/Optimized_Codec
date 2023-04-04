function video2frames(video,Folder)

v = VideoReader(video);
n = v.NumberOfFrames;
 
for iFrame = 1:n
  frames = read(v, iFrame);
  imwrite(frames, fullfile(Folder, sprintf('%04d.jpg', iFrame)));
end 

end