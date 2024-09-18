function map = generate_map(t)
%%
% @file: generate_map.m
% @breif: generate a map for the given time t
% @author: Dante van Gemert
% @update: 2024.9.12
% @param t: the time for which to generate the map
%%

map_size = [20, 30];

% border
border = [1:map_size(1), ...
        map_size(1):map_size(1):map_size(1) * map_size(2), ...
        1:map_size(1):(map_size(1) - 1) * map_size(2), ...
        map_size(1) * (map_size(2) - 1):map_size(1) * map_size(2)];

% ship starting coords, direction and size (x, y, dx, dy, w, h)
ship1 = [3, 3, 1, 0, 5, 5];
ship2 = [23, 6, -1, 0, 4, 2];

map = generate_grid(map_size, [ ...
    border, ...
    generate_ship(map_size, ship1, t), ...
    generate_ship(map_size, ship2, t)]);
end

%%
function cells = generate_ship(map_size, start, t)
pos = start(1:2) + start(3:4) * t;
size = start(5:6) - [1,1];

tl = pos2idx(map_size, pos); % top left corner
tr = pos2idx(map_size, pos + [size(1), 0]); % top right corner
bl = pos2idx(map_size, pos + [0, size(2)]); % bottom left corner
br = pos2idx(map_size, pos + size); % bottom right corner

cells = [
    tl:bl, ... % left edge
    tl:map_size(1):tr, ... % top edge
    bl:map_size(1):br, ... % bottom edge
    tr:br, % right edge
];
end

function index = pos2idx(map_size, pos)
index = pos(2) + (pos(1)-1) * map_size(1);
end