function checkcollision(b::Board, p::Piece, newpiece::Piece)
    shape = data(newpiece)
    x,y = newpiece.location
    dy, dx = size(shape) .-1
    x+dx <= 10 && x >= 1 && y+dy <= 20 && !any((b[newpiece] .!= 0 ) .& (shape .!= 0)) && return true
end

function affine!(b::Board, p::Piece, rotation=0, translation=[0,0])
    newpiece = copy(p)
    set_orientation!(newpiece, get_orientation!(newpiece) - rotation)
    newpiece.location[:] += translation

    b[p] -= data(p)
    if checkcollision(b,p,newpiece)
        set_orientation!(p, get_orientation!(p) - rotation)
        p.location[:] += translation
        b[p] += data(p)
        return true
    end
    b[p] += data(p)
    return false
end

rot_right!(b::Board, p::Piece)  = affine!(b, p, -1, [ 0, 0])
rot_left!(b::Board, p::Piece)   = affine!(b, p,  1, [ 0, 0])
move_right!(b::Board, p::Piece) = affine!(b, p,  0, [ 1, 0])
move_left!(b::Board, p::Piece)  = affine!(b, p,  0, [-1, 0])
drop!(b::Board, p::Piece)       = affine!(b, p,  0, [ 0, 1])

function fast_drop!(b::Board, p::Piece)
    while drop!(b, p) end
    return false
end

import Base: getindex, setindex!
function getindex(b::Board, p::Piece)
    dy,dx = size(data(p)) .-1
    x,y = p.location
    return b.data[y:y+dy, x:x+dx]
end
function setindex!(b::Board, s::AbstractArray, p::Piece)
    dy,dx = size(data(p)) .-1
    x,y = p.location
    b.data[y:y+dy, x:x+dx] = s
end