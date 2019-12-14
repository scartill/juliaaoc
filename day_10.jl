
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

function pushlist!(dict, key, val)
    if haskey(dict, key)
        push!(dict[key], val)
    else
        push!(dict, key => [val])
    end
end

function shape(starmap, pivx, pivy)
    vdlist = Dict()
    for y in 1:size(starmap, 1)
        for x in 1:size(starmap, 2)
            (starmap[y, x] && (x, y) != (pivx, pivy)) ? true : continue
            dx = x - pivx
            dy = pivy - y
            g = if dx == 0
                abs(dy)
            elseif dy == 0
                abs(dx)
            else
                gcd(abs(dx), abs(dy))
            end
            pushlist!(vdlist, (Int(dx/g), Int(dy/g)), [x, y, abs(dx) + abs(dy)])
        end
    end
    return vdlist
end

function visible(starmap, pivx, pivy)
    shape(starmap, pivx, pivy) |>
    keys |> unique |> length
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
                    maxinx = (x, y)
                end
            end
        end
    end
    return (maxvis, maxinx)
end

function vaporised(starmap, which)
    laser = maxvisible(starmap) |> last
    vdlist = shape(starmap, laser...)
    sorter = function(vect)
        (dx, dy) = vect
        (q, da, db) = if dx >= 0 && dy >= 0
            (10, dx, dy)
        elseif dx >= 0 && dy <= 0
            (20, dy, dx)
        elseif dx <= 0 && dy <= 0
            (30, dx, dy)
        elseif dx <= 0 && dy >= 0
            (40, dy, dx)
        end
        q + atan(abs(da), abs(db)) 
    end
    skeys = sort(vdlist |> keys |> collect; by=sorter)

    inx = 1
    while true
        for key in skeys
            onvect = sort(vdlist[key]; by=vd->vd[3], rev=true)
            if !isempty(onvect)
                vd = pop!(onvect)
                if inx == which
                    return 100*(vd[1] - 1) + (vd[2] - 1)
                end
                inx += 1
            end
        end
    end
end

function check(expected)    
    return function(val)
        if val != expected
            println("expected $expected; received $val")
        end
        return val
    end
end

simple_test = """
.#..#
.....
#####
....#
...##
"""
simple_test |> load |> maxvisible |> first |> check(8)

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
""" |> load |> maxvisible |> first |> check(33)

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
"""  |> load |> maxvisible |> first |> check(35)

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
""" |> load |> maxvisible |> first |> check(41)

large_test = """
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
"""

large_test |> load |> maxvisible |> first |> check(210)

starmap = read("input_d10.txt", String)
starmap |> load |> maxvisible |> first |> println

large_test |> load |> m -> vaporised(m, 200) |> check(802)
starmap |> load |> m -> vaporised(m, 200) |> println

