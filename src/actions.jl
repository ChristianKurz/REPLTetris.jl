function checkcollision(b::Board)
    x,y = b.location
    dy, dx = size(rotated_tile(b)) .-1
    x+dx <= 10 && x >= 1 && y+dy <= 20 && !any((b[b.tile] .!= 0 ) .& (rotated_tile(b) .!= 0))
end

function affine!(board::Board, rotation=0, translation=[0,0])
    oldboard = copy(board)

    board[board.tile] -= rotated_tile(board)
    board.orientation -= rotation
    board.location[:] += translation

    if checkcollision(board)
        board[board.tile] += rotated_tile(board)
        update_board!(oldboard, board)
        return true
    end
    board.orientation += rotation
    board.location[:] -= translation
    board[board.tile] += rotated_tile(board)
    return false
end

rot_right!(b::Board)  = affine!(b, -1, [ 0, 0])
rot_left!(b::Board)   = affine!(b,  1, [ 0, 0])
move_right!(b::Board) = affine!(b,  0, [ 1, 0])
move_left!(b::Board)  = affine!(b,  0, [-1, 0])
drop!(b::Board)       = affine!(b,  0, [ 0, 1])
fast_drop!(b::Board)  = (while drop!(b) end; return false)

function hold!(board::Board)
    if board.allowhold
        oldboard = copy(board)

        board[board.tile] -= data(board.tile)
        board.tile, board.holdtile = board.holdtile, board.tile
        board.orientation = 0
        board.location = start_location(board.tile)
        board[board.tile] += data(board.tile)

        update_board!(oldboard, board)
        
        print_hold_tile(board)
        board.allowhold = false
    end
end
