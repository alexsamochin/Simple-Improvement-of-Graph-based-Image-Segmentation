# Simple-Improvement-of-Graph-based-Image-Segmentation

In [1] graph based segmentation algorithm every pixel is a graph node. The pixels are grouped based on difference of their gray level. Here the graph partition and pixel grouping is based on standard deviation of the values of weights obtained from Non-Local means image pre-filtering. 

WARNING: The implementation code is based on the third parties [2] and [3]


[1] Efficient graph-based image segmentation, Felzenszwalb, P.E. and Huttenlocher,              D.P., International Journal of Computer Vision, 2004   

[2] https://www.mathworks.com/matlabcentral/fileexchange/13176-non-local-means-         filter


[3] https://github.com/kuangliu/graph_seg

![tmp](https://user-images.githubusercontent.com/6189744/186584098-5183cc6c-6dd8-4aa0-80b9-2030ac0c3410.jpg)

![result](https://user-images.githubusercontent.com/6189744/186583649-b86efbf3-df11-4cde-8856-5a7a9fa09732.jpg)
