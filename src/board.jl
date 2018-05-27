mutable struct Board
    data::Array{Int}
    score::Int
    round::Int
end
Board() = Board(zeros(Int, 20, 10), 0, 0)
copy(b::Board) = Board(copy(b.data), b.score, b.round)

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

function delete_lines!(board::Board)
    oldboard = copy(board)
    for i in 1:20
        if all(board.data[i, :] .!= 0)
            board.data[2:i, :] = board.data[1:i-1, :]
            board.data[1,:] .= 0
            board.score += board.round
        end
    end
    update_board!(oldboard, board)
end

function blocks(i)
    buf = IOBuffer()
    block = " ◼ "
    if i==0 
        block =" ◻ "
        i += 8
    end 
    print(buf, Crayon(foreground = i), block )
    return String(take!(buf))
end

function update_board!(b1::Board, b2::Board)
    buf = IOBuffer()
    for I in findall(b1.data .⊻ b2.data .!= 0)
        y,x = Tuple(I)
        put(buf, [(3*x)-2,y], blocks(b2.data[y,x]))
    end
    if (b1.round != b2.round) || (b1.score != b2.score)
        cursor_move_abs(buf, [0,21])
        print(buf, Crayon(foreground = 7), " Round: $(b2.round)\t    Score:$(b2.score)")
    end
    print(String(take!(buf)))
end

function print_tile_preview(tile::Tile)
    buf = IOBuffer()
    print(buf, Crayon(foreground = 7))
    put(buf, [35, 9], string("Next Tile:"))
    for i in 1:4
        put(buf, [35, 10+i], string(" "^15))
    end
    dt = data(tile)'
    _, dy = size(dt)
    for i in 1:dy
        put(buf, [35, 10+i], string(blocks.(dt[:, i])...)) 
    end
    print(String(take!(buf)))
end