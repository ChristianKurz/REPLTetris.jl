import Base: getindex, setindex!, copy

mutable struct Board
    data::Array{Int}
    score::Int
    level::Int
    lines_to_goal::Int
end
Board() = Board(zeros(Int, 20, 10), 0, 1, 5)
copy(b::Board) = Board(copy(b.data), b.score, b.level, b.lines_to_goal)

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
    nr_lines = 0
    for i in 1:20
        if all(board.data[i, :] .!= 0)
            board.data[2:i, :] = board.data[1:i-1, :]
            board.data[1,:] .= 0
            nr_lines += 1
        end
    end
    board.lines_to_goal -= nr_lines
    board.score += [0 1 3 5 8][nr_lines+1] * board.level * 100
    if board.lines_to_goal ≤ 0 
        board.level += 1
        board.lines_to_goal += board.level*5
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

@compat function update_board!(b1::Board, b2::Board)
    buf = IOBuffer()
    for I in findall(b1.data .⊻ b2.data .!= 0)
        if VERSION < v"0.7.0-DEV.3025"
            y,x = ind2sub(I)
        else
            y,x = Tuple(I)
        end
        put(buf, [(3*x)-2,y], blocks(b2.data[y,x]))
    end
    if (b1.level != b2.level) || (b1.score != b2.score)
        cursor_move_abs(buf, [0,21])
        print(buf, Crayon(foreground = 7), " Level: $(b2.level)\tScore:$(b2.score)")
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
