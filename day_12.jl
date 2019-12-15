using Combinatorics

function load(strings)
    strings |> v -> split(v, "\n")[1:end-1] |>
    sl -> map(sl) do s
        match(r"<x=([-]?\d+), y=([-]?\d+), z=([-]?\d+)>", s) |>
        ma -> map(1:3) do inx
            [parse(Float64, ma[inx]), 0.0]
        end
    end
end

function makestep!(moons)
    combinations(eachindex(moons), 2) |>
    pairs -> map(pairs) do pair
        map(1:3) do coord
            a = moons[first(pair)][coord]
            b = moons[last(pair)][coord]
            if a[1] < b[1]
                a[2] += 1
                b[2] -= 1
            elseif a[1] > b[1]
                a[2] -= 1
                b[2] += 1
            end
        end
    end
    map(moons) do moon
        map(1:3) do coord
            a = moon[coord]
            a[1] += a[2]
        end
    end
end

function iterate!(moons, num)
    for i in 1:num
        makestep!(moons)
    end
    return moons
end

function iterate2begin(moons, coord)
    cslice = ms -> map(ms) do m
        m[coord]
    end    
    startmoons = cslice(deepcopy(moons))
    step = 0
    while true
        makestep!(moons)
        step += 1
        if cslice(moons) == startmoons
            return step
        end
    end
end

function findback(moons)
    map(1:3) do coord
        iterate2begin(moons, coord)
    end |> lcm
end

function energy(moons)
    map(moons) do moon
        (sc, sv) = (0.0, 0.0)
        map(moon) do coord
            sc += abs(coord[1])
            sv += abs(coord[2])
        end
        sc*sv
    end |> sum
end

"""
<x=-1, y=0, z=2>
<x=2, y=-10, z=-7>
<x=4, y=-8, z=8>
<x=3, y=5, z=-1>
""" |> load |> m -> iterate!(m, 10) |> energy |> (x -> x == 179) |> println

read("input_d12.txt", String) |> load |> m -> iterate!(m, 1000) |> energy |> println

"""
<x=-8, y=-10, z=0>
<x=5, y=5, z=10>
<x=2, y=-7, z=3>
<x=9, y=-8, z=-3>
""" |> load |> findback |> (x -> x == 4686774924)|> println

read("input_d12.txt", String) |> load |> findback |> println
