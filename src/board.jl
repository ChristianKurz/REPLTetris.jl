import Base: getindex, setindex!, copy

mutable struct Board
    data::Array{Int}
    score::Int
    level::Int
    lines_to_goal::Int
    tile::Tile
    location::Vector{Int}
    orientation::Int
    nexttiles::Vector{Tile}
    holdtile::Tile
    allowhold::Bool
end
Board(i=0) = Board(ones(Int, 20, 10)*i, 0, 1, 5, 
            rand(Tiles)(), [4,1], 0,
            [rand(Tiles)() for i in 1:3], rand(Tiles)(), true)

copy(b::Board) = Board(copy(b.data), b.score, b.level, b.lines_to_goal, 
                    b.tile, b.location, b.orientation,
                    copy(b.nexttiles), b.holdtile, b.allowhold)

function getindex(b::Board, tile::Tile)
    dy,dx = size(rotated_tile(b)) .-1
    x,y = b.location
    return b.data[y:y+dy, x:x+dx]
end

function setindex!(b::Board, s::AbstractArray, tile::Tile)
    dy,dx = size(rotated_tile(b)) .-1
    x,y = b.location
    b.data[y:y+dy, x:x+dx] = s
end

rotated_tile(board::Board) = rotr90(data(board.tile), board.orientation)

function nexttile!(board::Board)
    push!(board.nexttiles, rand(Tiles)())
    board.tile = popfirst!(board.nexttiles)
end

function add_tile!(board::Board)
    nexttile!(board)
    board.location = start_location(board.tile)
    board.orientation = 0
    if all(board[board.tile] .== 0)
        oldboard = copy(board)
        board[board.tile] += data(board.tile)
        update_board!(oldboard, board)
        return true
    end
    false
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
