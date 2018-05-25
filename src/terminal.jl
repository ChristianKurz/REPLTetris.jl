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

function raw_mode(f, terminal)
    rawenabled = enableRawMode(terminal)
    rawenabled && print(terminal.out_stream, "\x1b[?25l")
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