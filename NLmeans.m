function [output, seg_im1, seg_im2, seg_im3] = NLmeans(input,t,f,a,h)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Mddified third party

%  input   : image to be filtered
%  t       : radius of search window
%  f       : radius of similarity window
%  a,h   : w(i,j) = exp(-||GaussFilter(a) .* (p(i) - p(j))||_2^2/h^2)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Size of the image
[m n]=size(input);


% Memory for the output
output=zeros(m,n);

% Replicate the boundaries of the input image
input2 = padarray(input,[f f],'symmetric');

% Used kernel
psize = 2*f+1;
kernel = fspecial('gaussian', [psize psize], a);

h=h*h;

seg_im1 = zeros(m,n);
seg_im2 = zeros(m,n);
seg_im3 = zeros(m,n);

s_vec = [];
sw_vec = [];

for i=1:m
    for j=1:n
        
        if i == 50 && j == n
            stop = 1;
        end
        
        i1 = i+ f;
        j1 = j+ f;
        
        W1= input2(i1-f:i1+f , j1-f:j1+f);
        
        wmax=0;
        average=0;
        sweight=0;
        
        rmin = max(i1-t,f+1);
        rmax = min(i1+t,m+f);
        smin = max(j1-t,f+1);
        smax = min(j1+t,n+f);
        
        tmp_av = [];
        tmp_sw = [];
        w_max = [];
        
        A = 0;
        Q = 0;
        k = 0;
        W0 = 0;
        Qw = 0;
        Aw = 0;
        s1 = 0;
        s2 = 0;
        for r=rmin:1:rmax
            for s=smin:1:smax
                
                if(r==i1 && s==j1)
                    continue;
                end;
                
                W2= input2(r-f:r+f , s-f:s+f);
                
                d = sum(sum(kernel.*(W1-W2).*(W1-W2)));
                
                w=exp(-d/h);
                
                k = k + 1;
                
                Q = Q + (k - 1)*(input2(r, s) - A)^2 / k;
                A = A + (input2(r, s) - A)/k;
                
                W = W0 + w;
                Qw = Qw + (w*W0*(input2(r, s) - Aw)^2) / W;
                Aw = Aw + w*(input2(r, s) - Aw)/W;
                
                W0 = W;
                
                s1 = s1 + w*input2(r, s);
                s2 = s2 + w*input2(r, s)^2;
                
                if w>wmax
                    wmax=w;
                end
                
                sweight = sweight + w;
                average = average + w*input2(r,s);
                
                tmp_sw = [tmp_sw sweight];
                tmp_av = [tmp_av average];
                w_max = [w_max w];
                
            end
        end
        
        sig = Q/(k - 1);
        s_vec = [s_vec sig];
        
        s = sqrt( (k*s2 - s1^2)/(k*(k - 1)) );
        
%         sw = (Qw/(W - 1));
        sw = 2*sqrt(Qw/W);
        sw_vec = [sw_vec sw];
        
        average = average + wmax*input2(i1,j1);
        sweight = sweight + wmax;
        
%         [beta, error] = line_fit(1:length(tmp_sw), tmp_sw);
        %         if error < th
        seg_im1(i,j) =  sig;
        %         end
        seg_im2(i,j) =  sweight;
        seg_im3(i,j) =  sw;
        
        if sweight > 0
            output(i,j) = average / sweight;
        else
            output(i,j) = input(i,j);
        end
    end
end

end

function [w, error] = line_fit(x_train, y_train)

n = length(x_train);
w = pinv([ones(n,1) x_train'])*y_train';
y_test = [ones(n,1) x_train']*w;
error = norm(y_train - y_test');

end
