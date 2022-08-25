function label = segment_graph(graph, K, im, std_map, d_th)

num_edges = size(graph, 1);
label = zeros(size(im));
for i = 1:num_edges
    edge = graph(i,:);
    [y1,x1] = ind2sub(size(im),edge(1));
    [y2,x2] = ind2sub(size(im),edge(2));
    
    if edge(3) > d_th
        continue
    end
    
    if (y1 + 1) < size(im,1) && (x1 + 1) < size(im,2)
        std1 = std_map(y1:y1 + 1,x1:x1 + 1) > K;
    else
        std1 = std_map(y1,x1) > K;
    end
    if (y2 + 1) < size(im,1) && (x2 + 1) < size(im,2)
        std2 = std_map(y2:y2 + 1,x2:x2 + 1) > K;
    else
        std2 = std_map(y2,x2) > K;
    end
        
    if (~any(std1(:)) && ~any(std2(:))) 
        
        if label(y1,x1) == 0 && label(y2,x2) == 0
            label(y1,x1) = max(label(:)) + 1;
            label(y2,x2) = max(label(:)) + 1;
            continue;
        end
        
        if label(y1,x1) ~= label(y2,x2)            
            
            if label(y1,x1) > 0 && label(y2,x2) == 0
                label(y2,x2) = label(y1,x1);
                continue;
            end
            if label(y2,x2) > 0 && label(y1,x1) == 0
                label(y1,x1) = label(y2,x2);
                continue;
            end
            if label(y1,x1) > label(y2,x2)
                tmp = find(label == label(y1,x1));
                label(tmp) = label(y2,x2);
                continue;
            else
                tmp = find(label == label(y2,x2));
                label(tmp) = label(y1,x1);
                continue;
            end
            
        end
         
    end
    
end
