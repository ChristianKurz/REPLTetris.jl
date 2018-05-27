abstract type Tile end
set_orientation!(tile::Tile, o::Int) = tile.orientation = o%4
get_orientation!(tile::Tile) = tile.orientation
set_mirrored!(tile::Tile, b::Bool) = tile.mirrored = b
copy(tile::T) where T<:Tile= T([getfield(tile, field) for field in fieldnames(T)]...)
data(::Tile) = error("Needs to be implemented!")

mutable struct L <: Tile
    location::Array{Int}
    orientation::Int
    mirrored::Bool
end
L() = L([5,1], 0, false)
data(tile::L) = [1 0 0; 1 1 1] |> x -> rotr90(x, tile.orientation) |>
                x -> tile.mirrored ? reverse(x * 9 #=orange=#, dims=2) : x * 4 #=blue=#


mutable struct Snake <: Tile
    location::Array{Int}
    orientation::Int
    mirrored::Bool
end
Snake() = Snake([5,1], 0, false)
data(tile::Snake) = [1 1 0; 0 1 1] |> x -> rotr90(x, tile.orientation) |>
                x -> tile.mirrored ? reverse(x * 2 #=green=# , dims=2) : x #=red=#


mutable struct Bar <: Tile
    location::Array{Int}
    orientation::Int
end
Bar() = Bar([5,1], 0)
set_mirrored!(::Bar, b::Bool) = return
data(tile::Bar) = [1 1 1 1] |> x -> rotr90(x * 6 #=cyan=#, tile.orientation)


mutable struct T <: Tile
    location::Array{Int}
    orientation::Int
end
T() = T([5,1], 0)
set_mirrored!(::T, b::Bool) = return
data(tile::T) = [1 1 1; 0 1 0] |> x -> rotr90(x * 5 #=magenta=#, tile.orientation)


mutable struct Block <: Tile
    location::Array{Int}
end
Block() = Block([5,1])
set_mirrored!(::Block, b::Bool) = return
set_orientation!(b::Block, o::Int) = return
get_orientation!(b::Block) = 0
data(tile::Block) = [1 1; 1 1] * 3 #=yellow=#

const Tiles = [L, Snake, Bar, T, Block]
