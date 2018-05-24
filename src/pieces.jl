abstract type Piece end
set_orientation!(p::Piece, o::Int) = p.orientation[1] = o%4
get_orientation!(p::Piece) = p.orientation[1]
set_mirrored!(p::Piece, b::Bool) = p.mirrored[1] = b
data(::Piece) = error("Needs to be implemented!")
copy(p::Piece) = typeof(p)([getfield(p, field)[:] for field in fieldnames(p)]...)

struct L <: Piece
    location::MVector{2, Int}
    orientation::MVector{1, Int}
    mirrored::MVector{1, Bool}
    color::MVector{1, Int}
end
L() = L([5,1], [0], [false], [2])
data(p::L) = SArray{Tuple{2,3}, Bool}([1 0 0; 1 1 1])*p.color[1]  |>
                x -> rotr90(x, p.orientation[1])        |>
                x -> p.mirrored[1] ? flipdim(x, 2) : x


struct Snake <: Piece
    location::MVector{2, Int}
    orientation::MVector{1, Int}
    mirrored::MVector{1, Bool}
    color::MVector{1, Int}
end
Snake() = Snake([5,1], [0], [false], [3])
data(p::Snake) = SArray{Tuple{2,3}, Bool}([0 1 1; 1 1 0])*p.color[1]   |>
                x -> rotr90(x, p.orientation[1])            |>
                x -> p.mirrored[1] ? flipdim(x, 2) : x


struct Bar <: Piece
    location::MVector{2, Int}
    orientation::MVector{1, Int}
    color::MVector{1, Int}
end
Bar() = Bar([5,1], [0], [4])
set_mirrored!(::Bar, b::Bool) = return
data(p::Bar) = SArray{Tuple{4,1}, Bool}([1,1,1,1])*p.color[1] |>
                x -> rotr90(x, p.orientation[1])


struct T <: Piece
    location::MVector{2, Int}
    orientation::MVector{1, Int}
    color::MVector{1, Int}
end
T() = T([5,1], [0], [5])
set_mirrored!(::T, b::Bool) = return
data(p::T) = SArray{Tuple{2,3}, Bool}([1 1 1; 0 1 0])*p.color[1] |>
                x -> rotr90(x, p.orientation[1])


struct Block <: Piece
    location::MVector{2, Int}
    color::MVector{1, Int}
end
Block() = Block([5,1], [1])
set_mirrored!(::Block, b::Bool) = return
set_orientation!(b::Block, o::Int) = return
get_orientation!(b::Block) = 0
data(p::Block) = SArray{Tuple{2,2}, Bool}([1 1; 1 1])*p.color[1]


const Pieces = [L, Snake, Bar, T, Block]
