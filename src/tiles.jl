abstract type Tile end
copy(tile::N) where N<:Tile= N(tile.location, tile.orientation)
data(::Tile) = error("Needs to be implemented!")

mutable struct L <: Tile
    location::Array{Int}
    orientation::Int
end
L() = L([4,1], 0)
data(tile::L) = [0 0 1; 1 1 1] * 9 #=orange=#   |> x -> rotr90(x, tile.orientation)

mutable struct J <: Tile
    location::Array{Int}
    orientation::Int
end
J() = J([4,1], 0)
data(tile::J) = [1 0 0; 1 1 1] * 4 #=blue=#     |> x -> rotr90(x, tile.orientation)

mutable struct S <: Tile
    location::Array{Int}
    orientation::Int
end
S() = S([4,1], 0)
data(tile::S) = [0 1 1; 1 1 0] * 2 #=green=#    |> x -> rotr90(x, tile.orientation)

mutable struct Z <: Tile
    location::Array{Int}
    orientation::Int
end
Z() = Z([4,1], 0)
data(tile::Z) = [1 1 0; 0 1 1] * 1 #=red=#      |> x -> rotr90(x, tile.orientation)

mutable struct T <: Tile
    location::Array{Int}
    orientation::Int
end
T() = T([4,1], 0)
data(tile::T) = [1 1 1; 0 1 0] * 5 #=magenta=#  |> x -> rotr90(x , tile.orientation)

mutable struct I <: Tile
    location::Array{Int}
    orientation::Int
end
I() = I([4,2], 0)
data(tile::I) = [1 1 1 1] * 6 #=cyan=#          |> x -> rotr90(x , tile.orientation)

mutable struct O <: Tile
    location::Array{Int}
    orientation::Int
end
O() = O([5,1], 0)
data(tile::O) = [1 1; 1 1] * 3  #=yellow=#

const Tiles = [T, L, J, S, Z, I, O]
