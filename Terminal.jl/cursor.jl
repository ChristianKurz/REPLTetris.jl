cursor_deleteline(buf::IO=terminal.out_stream)               = print(buf, "\x1b[2K")

cursor_hide(buf::IO=terminal.out_stream)                     = print(buf, "\x1b[?25l")
cursor_show(buf::IO=terminal.out_stream)                     = print(buf, "\x1b[?25h")

cursor_save_position(buf::IO=terminal.out_stream)            = print(buf, "\x1b[s")
cursor_restore_position(buf::IO=terminal.out_stream)         = print(buf, "\x1b[u")

cursor_move_abs(buf::IO, c::Vector{Int}=[0,0])  = print(buf, "\x1b[$(c[2]);$(c[1])H")
cursor_move_abs(c::Vector{Int}) = cursor_move_abs(terminal.out_stream, c)

# ToDo: Remove x offset after newline
function cursor_move_rel(buf::IO, c=[0,0])
    x = c[1] >= 0 ? "\x1b[$(abs(c[1]))A" : "\x1b[$(abs(c[1]))B"
    y = c[2] >= 0 ? "\x1b[$(abs(c[2]))C" : "\x1b[$(abs(c[2]))D"
    print(buf, x,y)
end
cursor_move_rel(c::Vector{Int}) = cursor_move_rel(terminal.out_stream, c)


function clear_screen()
    buf = IOBuffer()
    cursor_move_abs(buf, [0,0])
    for y in 1:50
        cursor_move_abs(buf, [0,y])
        cursor_deleteline(buf)
    end
    print(String(take!(buf)))
end

"""
    put(pos::Vector, s::String)
Put text `s` on screen at coordinates `pos`.
Does not change cursor position.
"""
function put(buf::IO, pos::Vector, s::String)
    cursor_save_position(buf)
    cursor_move_abs(buf, pos)
    print(buf, s)
    cursor_restore_position(buf)
end
put(pos::Vector, s::String) = put(terminal.out_stream, pos::Vector, s::String)
