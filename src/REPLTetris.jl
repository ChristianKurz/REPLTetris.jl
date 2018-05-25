__precompile__()
module REPLTetris

using Crayons
export tetris

include("terminal.jl")
include("board.jl")
include("tiles.jl")
include("actions.jl")

function tetris(pause=0.4)
    board = Board()
    tile = add_tile!(board)
    raw_mode(terminal) do
        clear_screen()
        abort = [false]
        @async while !abort[1]
            while !abort[1] && drop!(board, tile)
                @sync begin
                    @async print_board(board)
                    @async sleep(pause)
                end
            end
            delete_lines!(board)
            pause *= 0.97
            board.round += 1
            tile = add_tile!(board)
        end
        while !abort[1]
            c = readKey()
            c == Int(ARROW_UP)      && rot_right!(board, tile)
            c == Int(ARROW_DOWN)    && drop!(board, tile)
            c == Int(ARROW_RIGHT)   && move_right!(board, tile)
            c == Int(ARROW_LEFT)    && move_left!(board, tile)
            c == Int(SPACE)         && fast_drop!(board, tile)
            c == Int(ABORT)         && (abort[1]=true)
        end
    end
end

end #module
