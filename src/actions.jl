function checkcollision(b::Board, newtile::Tile)
    shape = data(newtile)
    x,y = newtile.location
    dy, dx = size(shape) .-1
    x+dx <= 10 && x >= 1 && y+dy <= 20 && !any((b[newtile] .!= 0 ) .& (shape .!= 0)) && return true
end

function affine!(board::Board, tile::Tile, rotation=0, translation=[0,0])
    oldboard = copy(board)
    newtile = copy(tile)
    set_orientation!(newtile, get_orientation!(newtile) - rotation)
    newtile.location += translation

    board[tile] -= data(tile)
    if checkcollision(board,newtile)
        set_orientation!(tile, get_orientation!(tile) - rotation)
        tile.location[:] += translation
        board[tile] += data(tile)
        update_board!(oldboard, board)
        return true
    end
    board[tile] += data(tile)
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

function add_tile!(board::Board, tile::Tile)
    if all(board[tile] .== 0)
        oldboard = copy(board)
        board[tile] += data(tile)
        update_board!(oldboard, board)
        return true
    end
    false
end
