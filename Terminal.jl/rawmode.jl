function rawmode(f, terminal=terminal, hide_cursor=true)
    rawenabled = enableRawMode(terminal)
    rawenabled && hide_cursor && cursor_hide(terminal.out_stream)
    try
        f()
    finally
        rawenabled && disableRawMode(terminal); cursor_show(terminal.out_stream)
    end
end

function enableRawMode(terminal)
    try
        REPL.Terminals.raw!(terminal, true)
        return true
    catch err
        warn("TerminalMenus: Unable to enter raw mode: $err")
    end
    return false
end

function disableRawMode(terminal)
    try
        REPL.Terminals.raw!(terminal, false)
        return true
    catch err
        warn("TerminalMenus: Unable to disable raw mode: $err")
    end
    return false
end