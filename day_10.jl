
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

function shape(starmap, pivx, pivy)
    vdlist = []
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
            vd = [x, y, dx/g, dy/g, abs(dx) + abs(dy)]
            push!(vdlist, vd)
        end
    end
    return vdlist
end

function visible(starmap, pivx, pivy)
    shape(starmap, pivx, pivy) |>
    v -> map(vd -> vd[3:4], v) |>
    unique |> length
end

function maxvisible(starmap)
    maxvis = 0
    maxinx = (0, 0)
    for y in 1:size(starmap, 1)        
        for x in 1:size(starmap, 2)
            if starmap[y, x]
                vis = visible(starmap, x, y)
                if vis > maxvis
                    maxvis = vis
                    maxinx = (y, x)
                end
            end
        end
    end
    return (maxvis, maxinx)
end

function vaporised(starmap, which)
    laser = maxvisible(starmap) |> last
    vdlist = shape(starmap, laser...)
    sorter = function(vd)
        dx = vd[3]
        dy = vd[4]
        dist = vd[5]
        c
    end
    vd = sort(vdlist; by=sorter)[which]
    return 100*vd[1] + vd[2]
end

"""
.#..#
.....
#####
....#
...##
""" |> load |> maxvisible |> first |> (x -> x == 8) |> println

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
""" |> load |> maxvisible |> first |> (x -> x == 33) |> println

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
"""  |> load |> maxvisible |> first |> (x -> x == 35) |> println

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
""" |> load |> maxvisible |> first |> (x -> x == 41) |> println

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
""" |> load |> maxvisible |> first |> (x -> x == 210) |> println

starmap = read("input_d10.txt", String)
starmap |> load |> maxvisible |> first |> println
#starmap |> load |> m -> vaporised(m, 210) |> println
