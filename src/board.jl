import Base: getindex, setindex!, copy

mutable struct Board
    data::Array{Int}
    score::Int
    level::Int
    lines_to_goal::Int
    tile::Tile
    nexttiles::Vector{Tile}
    holdtile::Tile
    allowhold::Bool
end
Board(i=0) = Board(ones(Int, 20, 10)*i, 0, 1, 5, 
            rand(Tiles)(), [rand(Tiles)() for i in 1:3], rand(Tiles)(), true)

copy(b::Board) = Board(copy(b.data), b.score, b.level, b.lines_to_goal, b.tile, copy(b.nexttiles), b.holdtile, b.allowhold)

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

nexttile(board::Board) = (push!(board.nexttiles, rand(Tiles)()); popfirst!(board.nexttiles))

const COLORS = [:red, :light_red, :yellow, :green, :cyan, :blue, :magenta, :dark_gray]

function blocks(i)
    buf = IOBuffer()
    block = " ■ "
    if i==0 
        block =" □ "
        i += 8
    end 
    print(buf, Crayon(foreground = COLORS[i]), block )
    return String(take!(buf))
end

@compat function update_board!(oldboard::Board, newboard::Board)
    buf = IOBuffer()
    for i in findall(oldboard.data .⊻ newboard.data .!= 0)
        if VERSION < v"0.7.0-DEV.3025"
            y,x = ind2sub((20,10), i)
        else
            y,x = Tuple(i)
        end
        put(buf, [(3*x)-2,y], blocks(newboard.data[y,x]))
    end
    if (oldboard.level != newboard.level) || (oldboard.score != newboard.score)
        cursor_move_abs(buf, [0,21])
        print(buf, Crayon(foreground = COLORS[8]), 
                " Level: $(newboard.level)\tScore:$(newboard.score)")
    end
    print(String(take!(buf)))
end
update_board!(newboard::Board) = update_board!(Board(1), newboard)

function print_tile_preview(board::Board, x = 2)
    buf = IOBuffer()
    print(buf, Crayon(foreground = COLORS[8]))
    put(buf, [33, x], string("Next Tiles:"))
    for (nr, tile) in enumerate(board.nexttiles)
        dt = data(tile)'
        _, dy = size(dt)
        for i in 1:2
            print(buf, Crayon(foreground = COLORS[8]))
            put(buf, [35, x+i+1+(nr-1)*4], string(" □ "^4))
            i <= dy && put(buf, [35, x+i+1+(nr-1)*4], string(blocks.(dt[:, i])...)) 
        end
    end
    print(String(take!(buf)))
end

function print_hold_tile(board::Board, x = 16)
    buf = IOBuffer()
    print(buf, Crayon(foreground = COLORS[8]))
    put(buf, [33, x], string("Hold Tile:"))

    dt = data(board.holdtile)'
    _, dy = size(dt)
    for i in 1:2
        print(buf, Crayon(foreground = COLORS[8]))
        put(buf, [35, x+i+1], string(" □ "^4))
        i <= dy && put(buf, [35, x+i+1], string(blocks.(dt[:, i])...)) 
    end
    print(String(take!(buf)))
end
