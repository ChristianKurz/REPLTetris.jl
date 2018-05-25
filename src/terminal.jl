function __init__()
    global terminal
    terminal = Base.Terminals.TTYTerminal(get(ENV, "TERM", is_windows() ? "" : "dumb"), STDIN, STDOUT, STDERR)
end

@enum(Key,
    ARROW_LEFT = 1000,
    ARROW_RIGHT,
    ARROW_UP,
    ARROW_DOWN,
    SPACE,
    ABORT)

function readKey(stream::IO=STDIN)::UInt32
    readNextChar() = Char(read(stream,1)[1])

    c = readNextChar()
    c == ' ' && return SPACE
	if c == '\x1b'
        esc_a = readNextChar()
        stream.buffer.size < 3 && return ABORT
        esc_b = readNextChar()

		if esc_a == '['
            esc_b == 'A' && return ARROW_UP
            esc_b == 'B' && return ARROW_DOWN
            esc_b == 'C' && return ARROW_RIGHT
            esc_b == 'D' && return ARROW_LEFT
        end
    end
    return ABORT
end

function raw_mode(f, terminal, hide_cursor=true)
    rawenabled = enableRawMode(terminal)
    rawenabled && hide_cursor && print(terminal.out_stream, "\x1b[?25l")
    try
        f()
    finally
        rawenabled && disableRawMode(terminal); print(terminal.out_stream, "\x1b[?25h")
    end
end

function enableRawMode(terminal)
    try
        Base.Terminals.raw!(terminal, true)
        return true
    catch err
        warn("TerminalMenus: Unable to enter raw mode: $err")
    end
    return false
end

function disableRawMode(terminal)
    try
        Base.Terminals.raw!(terminal, false)
        return true
    catch err
        warn("TerminalMenus: Unable to disable raw mode: $err")
    end
    return false
end

cursor_move_abs(buf::IO, c::Vector{Int}=[0,0]) = print(buf, "\x1b[$(c[2]);$(c[1])H")
cursor_move_abs(c::Vector{Int}) = cursor_move_abs(STDOUT, c)

# ToDo: Remove x offset after newline
function cursor_move_relative(buf::IO, c=[0,0])
    x, y = c
    x = x >= 0 ? "\x1b[$(abs(x))A" : "\x1b[$(abs(x))B"
    y = y >= 0 ? "\x1b[$(abs(y))C" : "\x1b[$(abs(y))D"
    print(buf, x,y)
end
cursor_move_relative(c::Vector{Int}) = cursor_move_relative(STDOUT, c)

cursor_deleteline(buf::IO=STDOUT) = print(buf, "\x1b[2K")

function clear_screen()
    buf = IOBuffer()
    cursor_move_abs(buf, [0,0])
    for y in 1:50
        cursor_move_abs(buf, [0,y])
        cursor_deleteline(buf)
    end
    print(String(take!(buf)))
end
