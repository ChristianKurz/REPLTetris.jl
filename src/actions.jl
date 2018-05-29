function checkcollision(board::Board, tile::Tile)
    x,y = tile.location
    dy, dx = size(data(tile)) .-1
    x+dx <= 10 && x >= 1 && y+dy <= 20 && !any((board[tile] .!= 0 ) .& (data(tile) .!= 0))
end

function affine!(board::Board, tile::Tile, rotation=0, translation=[0,0])
    oldboard = copy(board)

    board[tile] -= data(tile)
    tile.orientation -= rotation
    tile.location[:] += translation

    if checkcollision(board, tile)
        board[tile] += data(tile)
        update_board!(oldboard, board)
        return true
    end
    tile.orientation += rotation
    tile.location[:] -= translation
    board[tile] += data(tile)
    return false
end

rot_right!(b::Board, tile::Tile)  = affine!(b, tile, -1, [ 0, 0])
rot_left!(b::Board, tile::Tile)   = affine!(b, tile,  1, [ 0, 0])
move_right!(b::Board, tile::Tile) = affine!(b, tile,  0, [ 1, 0])
move_left!(b::Board, tile::Tile)  = affine!(b, tile,  0, [-1, 0])
drop!(b::Board, tile::Tile)       = affine!(b, tile,  0, [ 0, 1])
fast_drop!(b::Board, tile::Tile)  = (while drop!(b, tile) end; return false)

function add_tile!(board::Board, tile::Tile)
    if all(board[tile] .== 0)
        oldboard = copy(board)
        board[tile] += data(tile)
        update_board!(oldboard, board)
        return true
    end
    false
end
