__precompile__()
module REPLTetris

using Crayons
export tetris

include("../Terminal.jl/Terminal.jl")
using .Terminal
include("tiles.jl")
include("board.jl")
include("actions.jl")

function tetris(pause=0.3)
    board = Board()
    tile = rand(Tiles)()
    set_mirrored!(tile, rand(Bool))
    rawmode() do
        clear_screen()
        abort = [false]
        @async while !abort[1] && add_tile!(board, tile)
            nexttile = rand(Tiles)()
            set_mirrored!(nexttile, rand(Bool))
            print_tile_preview(nexttile)
            while !abort[1] && drop!(board, tile)
                @sync begin
                    @async print_board(board)
                    @async sleep(pause)
                end
            end
            delete_lines!(board)
            pause *= 0.99
            board.round += 1
            tile = nexttile
        end
        while !abort[1]
            c = readKey()
            c == "Up"       && rot_right!(board, tile)
            c == "Down"     && drop!(board, tile)
            c == "Right"    && move_right!(board, tile)
            c == "Left"     && move_left!(board, tile)
            c == " "        && fast_drop!(board, tile)
            c == "Ctrl-C"   && (abort[1]=true)
        end
    end
end

end #module
