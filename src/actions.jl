function checkcollision(b::Board, newtile::Tile)
    shape = data(newtile)
    x,y = newtile.location
    dy, dx = size(shape) .-1
    x+dx <= 10 && x >= 1 && y+dy <= 20 && !any((b[newtile] .!= 0 ) .& (shape .!= 0)) && return true
end

function affine!(b::Board, tile::Tile, rotation=0, translation=[0,0])
    newtile = copy(tile)
    set_orientation!(newtile, get_orientation!(newtile) - rotation)
    newtile.location += translation

    b[tile] -= data(tile)
    if checkcollision(b,newtile)
        set_orientation!(tile, get_orientation!(tile) - rotation)
        tile.location[:] += translation
        b[tile] += data(tile)
        return true
    end
    b[tile] += data(tile)
    return false
end

rot_right!(b::Board, tile::Tile)  = affine!(b, tile, -1, [ 0, 0])
rot_left!(b::Board, tile::Tile)   = affine!(b, tile,  1, [ 0, 0])
move_right!(b::Board, tile::Tile) = affine!(b, tile,  0, [ 1, 0])
move_left!(b::Board, tile::Tile)  = affine!(b, tile,  0, [-1, 0])
drop!(b::Board, tile::Tile)       = affine!(b, tile,  0, [ 0, 1])

function fast_drop!(b::Board, tile::Tile)
    while drop!(b, tile) end
    return false
end

import Base: getindex, setindex!
function getindex(b::Board, tile::Tile)
    dy,dx = size(data(tile)) .-1
    x,y = tile.location
    return b.data[y:y+dy, x:x+dx]
end
function setindex!(b::Board, s::AbstractArray, tile::Tile)
    dy,dx = size(data(tile)) .-1
    x,y = tile.location
    b.data[y:y+dy, x:x+dx] = s
end

function add_tile!(b::Board, tile::Tile)
    if all(b[tile] .== 0)
        b[tile] += data(tile)
        return true
    end
    false
end

function print_tile_preview(tile::Tile)
    buf = IOBuffer()
    for i in 1:4
        cursor_move_abs(buf, [0, 10+i])
        cursor_deleteline(buf)
    end
    dt = data(tile)'
    _, dy = size(dt)
    for i in 1:dy
        put(buf, [35, 10+i], string(blocks.(dt[:, i])...)) 
    end
    print(String(take!(buf)))
end
