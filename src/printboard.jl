function block(i)
    color = [:dark_gray, :red, :light_red, :yellow, :green, :cyan, :blue, :magenta][i+1]
    return string(Crayon(foreground = color), i==0 ? " □ " : " ■ ")
end

function update_board!(old::Board, b::Board)
    buf = IOBuffer()
    for i in findall(old.data .⊻ b.data .!= 0)
        y,x = Tuple(i)
        put(buf, [(3*x)-2,y], string(block.(b.data[y,x])...))
    end
    if (old.level != b.level) || (old.score != b.score)
        put(buf, [3,21], :dark_gray, "Level: $(b.level)\tScore:$(b.score)")
    end
    print(String(take!(buf)))
end

update_board!(b::Board) = update_board!(Board(2), b)


function print_preview(b::Board)
    buf = IOBuffer()
    put(buf, [33, 2], :dark_gray, string("Next Tiles:"))
    for (nr, tile) in enumerate(b.nexttiles)
        _print_tile(buf, tile, 2+(nr-1)*4)
    end
    print(String(take!(buf)))
end

function print_hold(b::Board)
    buf = IOBuffer()
    put(buf, [33, 16], :dark_gray, string("Hold Tile:"))
    _print_tile(buf, b.holdtile, 16)
    print(String(take!(buf)))
end

function _print_tile(buf, tile, x)
    dt = data(tile)'
    _, dy = size(dt)
    for i in 1:2
        put(buf, [35, x+i+1], :dark_gray, string(" □ "^4))
        i <= dy && put(buf, [35, x+i+1], string(block.(dt[:, i])...)) 
    end
end
