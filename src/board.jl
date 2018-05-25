mutable struct Board
    data::Array{Int}
    score::Int
    round::Int
    Board() = new(zeros(Int, 20, 10), 0, 0)
end

function add_tile!(b::Board, tile=rand(Tiles)())
    set_mirrored!(tile, rand(Bool))
    if all(b[tile] .== 0)
        b[tile] += data(tile)
        return tile
    end
    error("Lost!")
end

function delete_lines!(b::Board)
    for i in 1:20
        if all(b.data[i, :] .!= 0)
            b.data[2:i, :] = b.data[1:i-1, :]
            b.data[1,:] = 0
            b.score += b.round
        end
    end
end

function blocks(i)
    buf = IOBuffer()
    colors =  [:blue, :light_blue, :light_cyan, :light_green, :light_red, :light_yellow, :magenta]
    block = i==0 ? " ◻ " : " ◼ "
    print(buf, Crayon(foreground = colors[i+1]), block )
    return String(take!(buf))
end

function print_board(b)
    buf = IOBuffer()
    for y in 1:21
        print("\x1b[999D\x1b[$(y)A")
        print(buf, "\x1b[2K")
        if y == 21
            print(buf, " Round:", b.round,"\t    Score:",b.score)
            continue
        end
        print(buf, blocks.(b.data'[1+10*(y-1):10+10*(y-1)])..., "\r\n")
    end
    print(String(take!(buf)))
end
