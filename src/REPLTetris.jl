__precompile__()
module REPLTetris

using Crayons, Compat
export tetris

include("../Terminal.jl/Terminal.jl")
using .Terminal

include("tiles.jl")
include("board.jl")
include("actions.jl")

function tetris(board = Board())
    rawmode() do
        clear_screen()
        update_board!(board)
        abort = [false]
        @async while !abort[1] && add_tile!(board, board.tile)
            board.allowhold = true
            print_hold_tile(board)
            print_tile_preview(board)
            while !abort[1] && drop!(board, board.tile)
                sleep((0.8 - (board.level-1) * 0.007)^(board.level-1)) 
            end
            delete_lines!(board)
            board.tile = nexttile(board)
        end

        while !abort[1]
            c = readKey()
            c in ["Up", "x"]    && rot_right!(board, board.tile)
            c in ["Down"]       && drop!(board, board.tile)
            c in ["Right"]      && move_right!(board, board.tile)
            c in ["Left"]       && move_left!(board, board.tile)
            c in [" "]          && fast_drop!(board, board.tile)
            c in ["Ctrl", "z"]  && rot_left!(board, board.tile)
            c in ["c"]          && hold!(board)
            c in ["Ctrl-C"]     && (abort[1]=true)
        end
    end
end

end #module
