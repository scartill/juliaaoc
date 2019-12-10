function pushlist(dict, key, value)
    if !haskey(dict, key)
        push!(dict, key => [value])
    else
        push!(dict[key], value)
    end
end

function load(string)
    orbits = Dict()
    addpair = function(unit)
        s = split(unit, ")")
        parent = s[1]
        child = s[2]
        pushlist(orbits, parent, child)
    end
    map(addpair, split(string))

    return orbits
end

function deepcount(root, depth, orbits)
    result = depth
    if root in keys(orbits)
        for child in orbits[root]
            result += deepcount(child, depth + 1, orbits)
        end
    end
    return result
end

function count(orbits)    
    return deepcount("COM", 0, orbits)
end

function getpaths(orbits)
    paths = Dict()
    parentpath("COM", [], paths, orbits)
    return paths
end

function parentpath(node, path, paths, orbits)
    push!(paths, node => path)
    if node in keys(orbits)
        newpath = [path..., node]
        for child in orbits[node]
            parentpath(child, newpath, paths, orbits)
        end
    end    
end

function getminpath(orbits)
    paths = getpaths(orbits)
    you = paths["YOU"]
    santa = paths["SAN"]
    int = intersect(you, santa)
    return length(you) + length(santa) - 2*length(int)
end

test = """
COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L
"""

println(count(load(test)) == 42)
println(count(load(read("input_d6.txt", String))))

test_path = """
COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L
K)YOU
I)SAN
"""
println(getminpath(load(test_path)) == 4)
println(getminpath(load(read("input_d6.txt", String))))

