function Z = WGIF_(X, G, r, lambda, gamma)
% X:        input image
% G:        guidance image, must be a single-channel image
% r:        window radius
% lambda:   regularization parameter
% gamma:    should be generated by EdgeAwareWeighting
% Z:        output image


[hei, wid] = size(X);
N = boxfilter(ones(hei, wid), r);

GX = G .* X;
mean_GX = boxfilter(GX, r) ./ N;
mean_X = boxfilter(X, r) ./ N;
mean_G = boxfilter(G, r) ./ N;

mean_GG = boxfilter(G.*G, r) ./ N;
var_G = mean_GG - mean_G .* mean_G;

gamma = EdgeAwareWeighting(G);

a = (mean_GX - mean_G.*mean_X) ./ (var_G + lambda./gamma);
b = mean_X - a .* mean_G;

mean_a = boxfilter(a, r) ./ N;
mean_b = boxfilter(b, r) ./ N;

Z = mean_a .* G + mean_b;       % Eqn(9) in the paper

end