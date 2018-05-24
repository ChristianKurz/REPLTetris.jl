__precompile__()
module REPLTetris

using StaticArrays, Crayons
export tetris

terminal = nothing  # The user terminal

function __init__()
    global terminal
    terminal = Base.Terminals.TTYTerminal(get(ENV, "TERM", is_windows() ? "" : "dumb"), STDIN, STDOUT, STDERR)
end

include("board.jl")
include("pieces.jl")
include("actions.jl")
include("game.jl")

end #module