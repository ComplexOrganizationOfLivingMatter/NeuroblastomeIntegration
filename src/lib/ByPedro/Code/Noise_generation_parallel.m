
clear all

%num of images
N_imagenes=20;
%ratio used to random seed choice
noisy_ratio=5;
%image dimension resolution x resolution
resolution=1024;
%num of realizations
n_frames=1000;

list1 = [1 2 3 5 17 18 19 20];

parfor i=1:size(list1, 2)
   Noise_generation(list1(i),noisy_ratio,resolution,n_frames)
end