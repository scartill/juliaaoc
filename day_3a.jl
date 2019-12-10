using Base

function wirelocs(wire)
    locs = Dict()
    legs = split(wire, ",")
    dests = Dict('R' => [1, 0], 'L' => [-1, 0], 'U' => [0, 1], 'D' => [0, -1])

    cur = [0, 0]
    path = 0
    for leg in legs
        dest = dests[leg[1]]
        dist = parse(Int, leg[2:length(leg)])
        for _ in 1:dist
            cur += dest
            path += 1
            push!(locs, cur => path)
        end
    end

    return locs
end

function intwires(string)
    strings = split(string, "\n")
    wire_a = wirelocs(strings[1])
    wire_b = wirelocs(strings[2])
    inters = collect(intersect(keys(wire_a), keys(wire_b)))
    combine = pos -> wire_a[pos] + wire_b[pos]
    dist = min(map(combine, inters)...)
    return dist
end

wires = read("input_d3.txt", String)
println(intwires(wires))
