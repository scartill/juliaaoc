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
""" |> load |> m -> iterate!(m, 10) |> energy |> println

read("input_d12.txt", String) |> load |> m -> iterate!(m, 1000) |> energy |> println
