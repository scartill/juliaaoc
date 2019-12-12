function load(string) :: Matrix{Bool}
    string |>
    x -> split(x, "\n") |>
    x -> map(x) do x
        split(x, "") |>
        x -> map(x -> x == "#", x)
    end |>
    x -> x[1:end-1] |>
    x -> hcat(x...)'
end

function visible(starmap, pivx, pivy)
    result = Set()
    for y in 1:size(starmap, 1)
        for x in 1:size(starmap, 2)
            (starmap[y, x] && (x, y) != (pivx, pivy)) ? true : continue
            dx = x - pivx
            dy = y - pivy
            g = if dx == 0
                dy
            elseif dy == 0
                dx
            else
                gcd(abs(dx), abs(dy))
            end
            vect = (dx/g, dy/g)
            if vect ∉ result
                push!(result, vect)
            end        
        end
    end
    return length(result)
end

function maxvisible(starmap)
    result = 0
    for y in 1:size(starmap, 1)        
        for x in 1:size(starmap, 2)
            if starmap[y, x]
                vis = visible(starmap, x, y)
                result = max(result, vis)
            end
        end
    end
    return result
end

"""
.#..#
.....
#####
....#
...##
""" |> load |> maxvisible |> println

"""
......#.#.
#..#.#....
..#######.
.#.#.###..
.#..#.....
..#....#.#
#..#....#.
.##.#..###
##...#..#.
.#....####
""" |> load |> maxvisible |> println

"""
#.#...#.#.
.###....#.
.#....#...
##.#.#.#.#
....#.#.#.
.##..###.#
..#...##..
..##....##
......#...
.####.###.
"""  |> load |> maxvisible |> println

"""
.#..#..###
####.###.#
....###.#.
..###.##.#
##.##.#.#.
....###..#
..#.#..#.#
#..#.#.###
.##...##.#
.....#.#..
""" |> load |> maxvisible |> println

"""
.#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##
""" |> load |> maxvisible |> println

read("input_d10.txt", String) |> load |> maxvisible |> println
