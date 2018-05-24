# REPLTetris.jl
This started as an exercise to learn terminal rendering and key-input.

Still needs some work to improve rendering speed - but it's suprisingly playable.

![Julia REPL Screenshot of a lost game of REPLTetris](resources/Screenshot.PNG)

ToDO:
- [ ] improve rendering speed
- [ ] look up and comply with traditional scoring and colors
- [ ] present upcoming tile to the right
- [ ] look into better type-structures - `StaticArrays` aren't really needed
- [ ] ~~sound & music~~

# Installation & Usage
The package is not yet registered in Meta-Data. You will need to clone it from this site:

```julia-REPL
Julia> Pkg.clone("https://github.com/ChristianKurz/REPLTetris.jl")
Julia> using REPLTetris
Julia> tetris()
```

Game is controlled via arrow-keys and space - any other Key will quit the game:
- `Up`: Rotate Clockwise
- `Left` / `Right` / `Down`: Move Current Tile
- `Space`: Drop Current Tile to Bottom
