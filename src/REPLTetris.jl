__precompile__()
module REPLTetris

using Crayons, Compat
export tetris

include("../Terminal.jl/Terminal.jl")
using .Terminal

include("tiles.jl")
include("board.jl")
include("actions.jl")

function tetris(board = Board(), tile = rand(Tiles)())
    rawmode() do
        clear_screen()
        update_board!(Board(ones(Int, (20,10)),1,1,1), board)

        abort = [false]
        @async while !abort[1] && add_tile!(board, tile)
            nexttile = rand(Tiles)()
            print_tile_preview(nexttile)
            while !abort[1] && drop!(board, tile)
                sleep((0.8 - (board.level-1) * 0.007)^(board.level-1)) 
            end
            delete_lines!(board)
            tile = nexttile
        end

        while !abort[1]
            c = readKey()
            c in ["Up", "x"]    && rot_right!(board, tile)
            c in ["Down"]       && drop!(board, tile)
            c in ["Right"]      && move_right!(board, tile)
            c in ["Left"]       && move_left!(board, tile)
            c in [" "]          && fast_drop!(board, tile)
            c in ["Ctrl", "z"]  && rot_left!(board, tile)
            c in ["Ctrl-C"]     && (abort[1]=true)
        end
    end
end

end #module
