abstract type Tile end
set_orientation!(tile::Tile, o::Int) = tile.orientation = o%4
get_orientation!(tile::Tile) = tile.orientation
set_mirrored!(tile::Tile, b::Bool) = tile.mirrored = b
copy(tile::Tile) = typeof(tile)([getfield(tile, field) for field in fieldnames(tile)]...)
data(::Tile) = error("Needs to be implemented!")

mutable struct L <: Tile
    location::Array{Int}
    orientation::Int
    mirrored::Bool
    color::Int
end
L() = L([5,1], 0, false, 2)
data(tile::L) = [1 0 0; 1 1 1] * tile.color |> x -> rotr90(x, tile.orientation) |>
                x -> tile.mirrored ? flipdim(x, 2) : x


mutable struct Snake <: Tile
    location::Array{Int}
    orientation::Int
    mirrored::Bool
    color::Int
end
Snake() = Snake([5,1], 0, false, 3)
data(tile::Snake) = [0 1 1; 1 1 0] * tile.color |> x -> rotr90(x, tile.orientation) |>
                x -> tile.mirrored ? flipdim(x, 2) : x


mutable struct Bar <: Tile
    location::Array{Int}
    orientation::Int
    color::Int
end
Bar() = Bar([5,1], 0, 4)
set_mirrored!(::Bar, b::Bool) = return
data(tile::Bar) = [1 1 1 1] * tile.color |> x -> rotr90(x, tile.orientation)


mutable struct T <: Tile
    location::Array{Int}
    orientation::Int
    color::Int
end
T() = T([5,1], 0, 5)
set_mirrored!(::T, b::Bool) = return
data(tile::T) = [1 1 1; 0 1 0] * tile.color |> x -> rotr90(x, tile.orientation)


mutable struct Block <: Tile
    location::Array{Int}
    color::Int
end
Block() = Block([5,1], 1)
set_mirrored!(::Block, b::Bool) = return
set_orientation!(b::Block, o::Int) = return
get_orientation!(b::Block) = 0
data(tile::Block) = [1 1; 1 1] * tile.color

const Tiles = [L, Snake, Bar, T, Block]
