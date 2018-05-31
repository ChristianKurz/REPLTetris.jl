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

@compat function update_board!(old::Board, b::Board)
    buf = IOBuffer()
    for i in findall(old.data .⊻ b.data .!= 0)
        if VERSION < v"0.7.0-DEV.3025"
            y,x = ind2sub((20,10), i)
        else
            y,x = Tuple(i)
        end
        put(buf, [(3*x)-2,y], blocks(b.data[y,x]))
    end
    if (old.level != b.level) || (old.score != b.score)
        cursor_move_abs(buf, [0,21])
        print(buf, Crayon(foreground = COLORS[8]), 
                " Level: $(b.level)\tScore:$(b.score)")
    end
    print(String(take!(buf)))
end

update_board!(b::Board) = update_board!(Board(1), b)


function print_preview(b::Board)
    buf = IOBuffer()
    print(buf, Crayon(foreground = COLORS[8]))
    put(buf, [33, 2], string("Next Tiles:"))
    for (nr, tile) in enumerate(b.nexttiles)
        _print_tile(buf, tile, 2+(nr-1)*4)
    end
    print(String(take!(buf)))
end

function print_hold(b::Board)
    buf = IOBuffer()
    print(buf, Crayon(foreground = COLORS[8]))
    put(buf, [33, 16], string("Hold Tile:"))
    _print_tile(buf, b.holdtile, 16)
    print(String(take!(buf)))
end

function _print_tile(buf, tile, x)
    dt = data(tile)'
    _, dy = size(dt)
    for i in 1:2
        print(buf, Crayon(foreground = COLORS[8]))
        put(buf, [35, x+i+1], string(" □ "^4))
        i <= dy && put(buf, [35, x+i+1], string(blocks.(dt[:, i])...)) 
    end
end
