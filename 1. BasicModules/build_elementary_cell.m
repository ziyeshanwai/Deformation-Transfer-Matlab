function [ E ] = build_elementary_cell( TS, len )
%Build elementary matrices(cell type) for each triangle
%   TS : cell sized in # of triangle Triangular representation, See detail for supplementary material
%   len : # of triangle scalar
%   E : Elementary cell with length of length(TS)

% B matrix for each triangles
E = cell(len,1);

parfor i=1:len
    V = inv(TS{i}); % 
    E{i} = [-sum(V)' V']; % 变成列向量 3 x 4
end

end

