
im0 = double(imread('paris.jpg'));
im0 = rgb2gray(im0);
im = im0 / max(im0(:));

%%%% Parameters of Non-Local means filter
t = 7; f = 5; a = 1; h = 0.1;
[fim, seg_im, w_map, std_map] = NLmeans(im, t,f,a,h);

im_graph = build_graph(fim);
%%%% Parameters of graph partion
K = 0.2;
d_th = .05;
label = segment_graph(roi_graph, K, fim, std_map, d_th);
label(find(label == 0)) = 2*max(label(:));

figure, imagesc(log(label)), axis image

