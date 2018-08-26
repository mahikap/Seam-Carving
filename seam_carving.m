function im_change = seam_carving(im_input)

[Mag, X, Y] = gradient_magnitude(im_input, 1.4);
[m, n] = size(Mag);

M = zeros(m, n);
%copying first row
M(1,:) = Mag(1,:);
%building M and adding up minimum gradients
for i = 2 : m
    for j = 1 : n
        row = [M(i-1, j), M(i-1, j), M(i-1, j)];
        if (j-1 >= 1)
            row(1) = M(i-1, j-1);
        end
        if (j+1 <= n)    
            row(3) = M(i-1, j+1);
        end
        M(i, j) = Mag(i, j) + min(row);
    end
end

last_row = M(m,:);
min_g = min(last_row);
min_i = find(last_row==min_g,1);

%going backwards to find the minimum path
seam = zeros(1,m);
seam(m) = min_i;
j = min_i;
for i = m-1: -1 :1
    row_above = [999999, M(i, j), 999999];
    if (j-1 >= 1)
        row_above(1) = M(i, j-1);
    end
    if (j+1 <= m)    
        row_above(3) = M(i, j+1);
    end
    min_e = min(row_above);
    min_j = find(row_above==min_e,1);
    %keeping track of column indices
    if (min_j == 1)
        j= j - 1;
    end
    if (min_j == 3)
        j= j + 1;
    end
    seam(i) = j;
end

%removing the seam in original image- im
im_change = zeros(m, n-1);
for i = 1: m
    v = seam(i);
    im_change(i, 1:v-1) = im_input(i, 1:v-1);
    im_change(i, v:n-1) = im_input(i, v+1:n);
end
disp(im_change);
end