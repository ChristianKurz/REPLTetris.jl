module Terminal

using REPL
export rawmode, clear_screen, readKey, cursor_move_abs, put, cursor_deleteline

function __init__()
    global terminal
    terminal = REPL.Terminals.TTYTerminal(get(ENV, "TERM", is_windows() ? "" : "dumb"), STDIN, STDOUT, STDERR)
end

include("rawmode.jl")
include("cursor.jl")
include("readkey.jl")

end #module     